import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/tatanan/domain/entities/tatanan_verse_entity.dart';
import 'package:ishari/features/tatanan/domain/repositories/tatanan_repository.dart';

@injectable
class GetTatananDetail {
  const GetTatananDetail(this._repository);

  final TatananRepository _repository;

  Future<Either<Failure, List<TatananVerseEntity>>> call(String tatananId) =>
      _repository.getTatananDetail(tatananId);
}
