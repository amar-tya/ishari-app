import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/usecases/usecase.dart';
import 'package:ishari/features/update/domain/entities/app_version_entity.dart';
import 'package:ishari/features/update/domain/repositories/update_repository.dart';

/// Fetches app version config from server for the given [platform].
@lazySingleton
class CheckForUpdate implements UseCase<AppVersionEntity, String> {
  const CheckForUpdate(this._repository);

  final UpdateRepository _repository;

  @override
  Future<Either<Failure, AppVersionEntity>> call(String platform) =>
      _repository.getAppVersion(platform);
}
