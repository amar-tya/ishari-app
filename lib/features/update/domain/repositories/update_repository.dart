import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/update/domain/entities/app_version_entity.dart';

/// Boundary interface between domain and data layers for version checking.
abstract interface class UpdateRepository {
  Future<Either<Failure, AppVersionEntity>> getAppVersion(String platform);
}
