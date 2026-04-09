import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/env/app_env.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/core/utils/app_logger.dart';
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

  // google_sign_in v7: Use GoogleSignIn.instance and initialize separately.
  // serverClientId is required on Android so that an idToken is included
  // in the authentication response.
  late final Future<void> _initializationFuture =
      GoogleSignIn.instance.initialize(
    serverClientId: AppEnv.googleWebClientId,
  );

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      appLogger.d('[GoogleSignIn] Starting signIn...');

      // Ensure GoogleSignIn is initialized
      await _initializationFuture;

      // Step 1: Open the Google account picker dialog
      // authenticate() throws GoogleSignInException on cancel/failure (no null return)
      final googleUser = await GoogleSignIn.instance.authenticate();

      // Step 2: Ambil authentication (idToken) — synchronous in v7
      final googleAuth = googleUser.authentication;

      final idToken = googleAuth.idToken;
      // accessToken moved to authorizationClient in v7 — not needed for Supabase idToken exchange

      if (idToken == null) {
        throw const ServerException(
          message:
              'Gagal mendapatkan Google idToken. Pastikan serverClientId (Web Client ID) sudah benar di Google Cloud Console.',
        );
      }

      // Step 3: Exchange Google tokens with Supabase
      final response = await _supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );

      final user = response.user;

      if (user == null) {
        throw const ServerException(
          message: 'Supabase authentication failed — no user returned',
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
      throw ServerException(
        message: 'Gagal login dengan Google (${e.description ?? e.code.name}). '
            'Jika masalah berlanjut, hubungi pengembang.',
      );
    } catch (e, stackTrace) {
      appLogger.e('[GoogleSignIn] ERROR', error: e, stackTrace: stackTrace);
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait<void>([
        _supabaseClient.auth.signOut(),
        GoogleSignIn.instance.signOut(),
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
