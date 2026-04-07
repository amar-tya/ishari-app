import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/muhud/domain/repositories/muhud_repository.dart';

@injectable
class ToggleBookmark {
  const ToggleBookmark(this.repository);

  final MuhudRepository repository;

  Future<Either<Failure, bool>> call(
    int verseId,
    String userId, {
    String? note,
  }) => repository.toggleBookmark(verseId, userId, note: note);
}
