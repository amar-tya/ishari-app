import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/network/network_info.dart';
import 'package:ishari/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:ishari/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ishari/features/auth/domain/entities/user_entity.dart';
import 'package:ishari/features/auth/domain/repositories/auth_repository.dart';

/// Concrete implementation of [AuthRepository].
///
/// Strategy:
/// - Online  → call remote, cache result locally
/// - Offline → fall back to cached user (read-only)
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
      await _local.cacheUser(model);
      return right(model.toEntity());
    } on CanceledSignInException {
      return left(const CanceledFailure());
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _remote.signOut();
      await _local.clearCachedUser();
      return right(unit);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    } on CacheException catch (e) {
      return left(CacheFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      if (await _networkInfo.isConnected) {
        final model = await _remote.getCurrentUser();
        if (model != null) await _local.cacheUser(model);
        return right(model?.toEntity());
      } else {
        // Offline: attempt to read from cache
        try {
          final cached = await _local.getCachedUser();
          return right(cached.toEntity());
        } on CacheException {
          return right(null);
        }
      }
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _remote.authStateChanges.map((model) => model?.toEntity());
  }
}
