import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/tatanan/domain/repositories/tatanan_repository.dart';

@injectable
class AddVerseToTatanan {
  const AddVerseToTatanan(this._repository);

  final TatananRepository _repository;

  Future<Either<Failure, void>> call({
    required String tatananId,
    required int verseId,
    required int position,
  }) =>
      _repository.addVerseToTatanan(
        tatananId: tatananId,
        verseId: verseId,
        position: position,
      );
}
