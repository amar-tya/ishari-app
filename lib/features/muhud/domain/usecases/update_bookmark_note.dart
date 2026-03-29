import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/muhud/domain/repositories/muhud_repository.dart';

@injectable
class UpdateBookmarkNote {
  const UpdateBookmarkNote(this.repository);

  final MuhudRepository repository;

  Future<Either<Failure, void>> call(int verseId, String? note) =>
      repository.updateBookmarkNote(verseId, note);
}
