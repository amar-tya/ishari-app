import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/home/domain/entities/hadi_entity.dart';

abstract interface class HomeRepository {
  /// Returns the chapter to feature (last read or first Diwan chapter).
  ///
  /// Pass [lastChapterId] to fetch a specific chapter (logged-in user's
  /// last read). Pass `null` to fetch the default first chapter (guest).
  Future<Either<Failure, ChapterEntity>> getFeaturedChapter(
    String? lastChapterId,
  );

  /// Returns all chapters for the given [category].
  Future<Either<Failure, List<ChapterEntity>>> getChaptersByCategory(
    String category,
  );

  /// Returns all pimpinan shalawat (hadi).
  Future<Either<Failure, List<HadiEntity>>> getHadiList();
}
