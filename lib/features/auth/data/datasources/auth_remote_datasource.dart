import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/env/app_env.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/utils/app_logger.dart';
import 'package:ishari/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Contract for remote auth operations.
abstract interface class AuthRemoteDataSource {
  /// Authenticate via Google OAuth and return the signed-in [UserModel].
  Future<UserModel> signInWithGoogle();

  /// Remove the Supabase session from this device and sign out of Google, both
  /// at once.
  ///
  /// Succeeds even if the server or Google cannot be reached: the refresh
  /// token is then not revoked server-side, only removed from the device.
  /// The Google part is given up after a few seconds; the Supabase part has no
  /// time limit. Throws [ServerException] if the local sign-out itself fails.
  Future<void> signOut();

  /// Return the current Supabase user, or null if not authenticated.
  Future<UserModel?> getCurrentUser();

  /// Stream that emits [UserModel] on login and null on logout. Refresh
  /// failures arrive as stream errors.
  ///
  /// Known SDK limitations (gotrue 2.19.0) that the app cannot work around:
  /// - Only network errors and 5xx keep the session when a refresh fails. Any
  ///   other response, such as a 429 or a proxy or captive portal error page
  ///   with a non-2xx status, signs the user out.
  /// - A refresh already in flight during sign-out can save its session again,
  ///   so the next cold start may be signed in.
  Stream<UserModel?> get authStateChanges;
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._supabaseClient);

  final SupabaseClient _supabaseClient;

  /// Limit for waiting on Google where the user is not involved. On Android
  /// these are on-device calls: `initialize` with a server client id makes no
  /// native call, and sign-out only clears the Credential Manager state. Three
  /// seconds is meant to leave a slow device ample room, while a stuck call
  /// holds the user in loading only briefly.
  static const _googleTimeout = Duration(seconds: 3);

  Future<void>? _initialization;

  /// The latest Google sign-out, which may outlive [_googleTimeout].
  Future<void>? _googleSignOut;

  // google_sign_in v7: Use GoogleSignIn.instance and initialize separately.
  // serverClientId is required on Android so that an idToken is included
  // in the authentication response.
  Future<void> _initializeGoogle() async {
    // initialize() should be called once, so callers share one attempt.
    final attempt = _initialization ??= GoogleSignIn.instance.initialize(
      serverClientId: AppEnv.googleWebClientId,
    );
    try {
      await attempt.timeout(_googleTimeout);
    } on Object {
      // Drop a failed or stuck attempt, or every later sign-in would depend on
      // it until the app restarts. A second initialize() is harmless on
      // Android, where it only stores the client id.
      if (identical(_initialization, attempt)) _initialization = null;
      rethrow;
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      appLogger.d('[GoogleSignIn] Starting signIn...');

      // Ensure GoogleSignIn is initialized
      await _initializeGoogle();
      await _waitForGoogleSignOut();

      // Step 1: Open the Google account picker dialog
      // authenticate() throws GoogleSignInException on cancel/failure (no null return)
      GoogleSignInAccount googleUser;
      try {
        googleUser = await GoogleSignIn.instance.authenticate();
      } on GoogleSignInException catch (e) {
        // [16] Account reauth failed — stale Credential Manager entry.
        // Clear it and retry so the user gets a fresh account picker.
        final desc = e.description ?? '';
        if (e.code == GoogleSignInExceptionCode.canceled &&
            RegExp(r'^\[16\]').hasMatch(desc)) {
          appLogger.d('[GoogleSignIn] Stale credential detected ([16]), clearing and retrying...');
          await GoogleSignIn.instance.signOut();
          googleUser = await GoogleSignIn.instance.authenticate();
        } else {
          rethrow;
        }
      }

      // Step 2: Ambil authentication (idToken) — synchronous in v7
      final googleAuth = googleUser.authentication;

      final idToken = googleAuth.idToken;
      // accessToken moved to authorizationClient in v7 — not needed for Supabase idToken exchange

      if (idToken == null) {
        // Usually a wrong serverClientId (Web Client ID) in Google Cloud
        // Console. For the developer only: the user gets a general text.
        appLogger.e('[GoogleSignIn] No idToken returned');
        throw const ServerException(
          message: FailureMessages.googleSignInFailed,
        );
      }

      // Step 3: Exchange Google tokens with Supabase
      final response = await _supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );

      final user = response.user;

      if (user == null) {
        appLogger.e('[GoogleSignIn] Supabase returned no user');
        throw const ServerException(
          message: FailureMessages.googleSignInFailed,
        );
      }

      return UserModel.fromSupabaseUser(user.toJson());
    } on ServerException {
      rethrow;
    } on GoogleSignInException catch (e) {
      final desc = e.description ?? '';
      // Deskripsi dengan kode error dalam bracket (e.g. "[16]") = bukan user cancel biasa
      final isUserCancel = e.code == GoogleSignInExceptionCode.canceled
          && !RegExp(r'^\[\d+\]').hasMatch(desc);

      if (isUserCancel) {
        throw const CanceledSignInException();
      }
      appLogger.e('[GoogleSignIn] GoogleSignInException code=${e.code} desc=${e.description}', error: e);
      // Error code 10 = DEVELOPER_ERROR (SHA-1 not registered or OAuth misconfiguration)
      // Other codes = possible network or service error
      throw const ServerException(message: FailureMessages.googleSignInFailed);
    } catch (e, stackTrace) {
      appLogger.e('[GoogleSignIn] ERROR', error: e, stackTrace: stackTrace);
      throw ServerException.from(e, stackTrace);
    }
  }

  @override
  Future<void> signOut() async {
    // Together, so that a stalled server logout cannot delay the Google
    // sign-out, or skip it if the app is closed meanwhile. Future.wait lets
    // both finish before it reports an error.
    await Future.wait<void>([_signOutOfSupabase(), _signOutOfGoogle()]);
  }

  Future<void> _signOutOfSupabase() async {
    try {
      await _supabaseClient.auth.signOut();
    } on AuthException catch (e, stackTrace) {
      // The SDK removes the local session and emits signedOut before it calls
      // the server, so only the server-side logout failed.
      appLogger.w(
        '[Auth] Server logout failed',
        error: e,
        stackTrace: stackTrace,
      );
    } catch (e, stackTrace) {
      throw ServerException.from(e, stackTrace);
    }
  }

  /// Never throws: a failed or stuck Google sign-out is only logged.
  Future<void> _signOutOfGoogle() async {
    try {
      await _initializeThenSignOutOfGoogle().timeout(_googleTimeout);
    } on Object catch (e, stackTrace) {
      appLogger.w(
        '[GoogleSignIn] Sign-out failed',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _initializeThenSignOutOfGoogle() async {
    // Has its own limit and throws there, so an initialize that finishes late
    // never goes on to sign out in the middle of a newer sign-in.
    await _initializeGoogle();
    final signOut = GoogleSignIn.instance.signOut();
    _googleSignOut = signOut;
    await signOut;
  }

  /// A sign-out past its limit cannot be cancelled and may still be clearing
  /// credentials, so it gets one more chance to finish before the account
  /// picker opens.
  Future<void> _waitForGoogleSignOut() async {
    final signOut = _googleSignOut;
    _googleSignOut = null;
    try {
      await signOut?.timeout(_googleTimeout);
    } on Object catch (e) {
      // Signing in does not depend on it.
      appLogger.w('[GoogleSignIn] Earlier sign-out not finished', error: e);
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) return null;
      return UserModel.fromSupabaseUser(user.toJson());
    } catch (e, stackTrace) {
      throw ServerException.from(e, stackTrace);
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _supabaseClient.auth.onAuthStateChange.map((event) {
      final user = event.session?.user;
      if (user == null) return null;
      return UserModel.fromSupabaseUser(user.toJson());
    });
  }
}
