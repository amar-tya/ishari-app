import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/error_mapper.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/network/network_info.dart';
import 'package:ishari/core/utils/app_logger.dart';
import 'package:ishari/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:ishari/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ishari/features/auth/domain/entities/user_entity.dart';
import 'package:ishari/features/auth/domain/repositories/auth_repository.dart';

/// Concrete implementation of [AuthRepository].
///
/// The Supabase SDK session is the only source of truth for who is signed in:
/// the SDK persists it and restores it offline. Local storage is only touched
/// to delete the user copy that older app versions cached.
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(
    this._remote,
    this._local,
    this._networkInfo,
  );

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    if (!await _networkInfo.isConnected) {
      return left(const NetworkFailure());
    }
    try {
      final model = await _remote.signInWithGoogle();
      return right(model.toEntity());
    } on CanceledSignInException {
      return left(const CanceledFailure());
    } on ServerException catch (e, stackTrace) {
      return left(mapErrorToFailure(e, stackTrace));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _remote.signOut();
      return right(unit);
    } on ServerException catch (e, stackTrace) {
      return left(mapErrorToFailure(e, stackTrace));
    } finally {
      await _clearLegacyCache();
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final model = await _remote.getCurrentUser();
      if (model == null) await _clearLegacyCache();
      return right(model?.toEntity());
    } on ServerException catch (e, stackTrace) {
      return left(mapErrorToFailure(e, stackTrace));
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _remote.authStateChanges.map((model) => model?.toEntity());
  }

  /// Best effort: nothing reads the cache, so a failure must not fail auth.
  Future<void> _clearLegacyCache() async {
    try {
      await _local.clearCachedUser();
    } on CacheException catch (e) {
      appLogger.w('[Auth] Could not clear the legacy user cache', error: e);
    }
  }
}
