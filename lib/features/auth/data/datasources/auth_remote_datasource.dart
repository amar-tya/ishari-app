import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
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
  AuthRemoteDataSourceImpl(this._supabaseClient, this._googleSignIn);

  final SupabaseClient _supabaseClient;
  final GoogleSignIn _googleSignIn;

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      // Step 1: Trigger Google Sign-In dialog
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw const ServerException(message: 'Google sign-in was cancelled');
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      if (idToken == null || accessToken == null) {
        throw const ServerException(
          message: 'Failed to obtain Google tokens',
        );
      }

      // Step 2: Exchange Google tokens with Supabase
      final response = await _supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
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
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
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
