import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/tatanan/domain/entities/tatanan_entity.dart';
import 'package:ishari/features/tatanan/domain/repositories/tatanan_repository.dart';

@injectable
class GetTatananList {
  const GetTatananList(this._repository);

  final TatananRepository _repository;

  Future<Either<Failure, List<TatananEntity>>> call(String userId) =>
      _repository.getTatananList(userId);
}
