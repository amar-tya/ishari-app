import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/update/data/datasources/update_remote_datasource.dart';
import 'package:ishari/features/update/data/models/app_version_model.dart';
import 'package:ishari/features/update/domain/entities/app_version_entity.dart';
import 'package:ishari/features/update/domain/repositories/update_repository.dart';

@LazySingleton(as: UpdateRepository)
class UpdateRepositoryImpl implements UpdateRepository {
  const UpdateRepositoryImpl(this._remote);

  final UpdateRemoteDataSource _remote;

  @override
  Future<Either<Failure, AppVersionEntity>> getAppVersion(
    String platform,
  ) async {
    try {
      final model = await _remote.getAppVersion(platform);
      return right(model.toEntity());
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    } catch (e) {
      return left(UnknownFailure(message: e.toString()));
    }
  }
}
