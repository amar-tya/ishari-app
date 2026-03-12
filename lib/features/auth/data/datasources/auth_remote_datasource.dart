import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/env/app_env.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Contract for remote auth operations.
abstract interface class AuthRemoteDataSource {
  /// Authenticate via Google OAuth and return the signed-in [UserModel].
  Future<UserModel> signInWithGoogle();

  /// Sign out from Supabase and revoke the Google Sign-In token.
  Future<void> signOut();

  /// Return the current Supabase user, or null if not authenticated.
  Future<UserModel?> getCurrentUser();

  /// Stream that emits [UserModel] on login and null on logout.
  Stream<UserModel?> get authStateChanges;
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._supabaseClient);

  final SupabaseClient _supabaseClient;

  // google_sign_in v6: instantiate directly with serverClientId (Web Client ID).
  // serverClientId is required on Android so that an idToken is included
  // in the authentication response.
  final _googleSignIn = GoogleSignIn(
    serverClientId: AppEnv.googleWebClientId,
    scopes: ['email', 'profile'],
  );

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      debugPrint('[GoogleSignIn] Starting signIn...');

      // Step 1: Open the Google account picker dialog
      final googleUser = await _googleSignIn.signIn();
      debugPrint('[GoogleSignIn] googleUser: $googleUser');

      if (googleUser == null) {
        throw const ServerException(message: 'Google Sign-In cancelled by user');
      }

      // Step 2: Get the authentication tokens
      debugPrint('[GoogleSignIn] Fetching authentication tokens...');
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      debugPrint('[GoogleSignIn] idToken is null: ${idToken == null}');
      debugPrint('[GoogleSignIn] accessToken is null: ${accessToken == null}');

      if (idToken == null) {
        throw const ServerException(
          message: 'Failed to obtain Google idToken. Ensure serverClientId is set correctly.',
        );
      }

      // Step 3: Exchange Google tokens with Supabase
      debugPrint('[GoogleSignIn] Signing in to Supabase with idToken...');
      final response = await _supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      final user = response.user;
      debugPrint('[GoogleSignIn] Supabase user: ${user?.email}');

      if (user == null) {
        throw const ServerException(
          message: 'Supabase authentication failed — no user returned',
        );
      }

      return UserModel.fromSupabaseUser(user.toJson());
    } on ServerException {
      rethrow;
    } catch (e, stackTrace) {
      debugPrint('[GoogleSignIn] ERROR: $e');
      debugPrint('[GoogleSignIn] StackTrace: $stackTrace');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait<void>([
        _supabaseClient.auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) return null;
      return UserModel.fromSupabaseUser(user.toJson());
    } catch (e) {
      throw ServerException(message: e.toString());
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
