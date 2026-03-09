import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/auth/domain/entities/user_entity.dart';

/// Boundary interface between the domain layer and the data layer.
///
/// Implementations live in `auth/data/repositories/`.
abstract interface class AuthRepository {
  /// Sign in with Google via Supabase OAuth.
  Future<Either<Failure, UserEntity>> signInWithGoogle();

  /// Sign out from Supabase and revoke Google token.
  Future<Either<Failure, Unit>> signOut();

  /// Return the currently authenticated user, or null if not signed in.
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Stream of auth state changes (emits [UserEntity] or null).
  Stream<UserEntity?> get authStateChanges;
}
