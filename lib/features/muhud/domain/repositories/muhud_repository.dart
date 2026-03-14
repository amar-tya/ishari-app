import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/muhud/domain/entities/verse_with_details_entity.dart';

abstract interface class MuhudRepository {
  /// Returns chapter details by id.
  Future<Either<Failure, ChapterEntity>> getChapterById(int chapterId);

  /// Returns all verses for a given chapter with translations and media.
  Future<Either<Failure, List<VerseWithDetailsEntity>>> getVersesByChapter(
    int chapterId,
  );

  /// Toggles bookmark status for a verse.
  /// Returns true if bookmarked, false if removed.
  Future<Either<Failure, bool>> toggleBookmark(
    int verseId,
    String userId,
  );

  /// Returns list of bookmarked verse IDs for a user.
  Future<Either<Failure, List<int>>> getBookmarkedVerseIds(String userId);
}
