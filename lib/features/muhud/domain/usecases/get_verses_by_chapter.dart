import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/muhud/domain/entities/verse_with_details_entity.dart';
import 'package:ishari/features/muhud/domain/repositories/muhud_repository.dart';

@injectable
class GetVersesByChapter {
  const GetVersesByChapter(this.repository);

  final MuhudRepository repository;

  Future<Either<Failure, List<VerseWithDetailsEntity>>> call(int chapterId) =>
      repository.getVersesByChapter(chapterId);
}
