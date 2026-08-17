import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/kitab/domain/entities/book_entity.dart';
import 'package:ishari/features/kitab/domain/entities/book_page_entity.dart';

abstract interface class KitabRepository {
  Future<Either<Failure, List<BookEntity>>> getAllBooks();

  /// Returns chapters belonging to [bookId], ordered by chapter_number.
  Future<Either<Failure, List<ChapterEntity>>> getChaptersByBook(int bookId);

  /// Returns pre-rendered per-halaman page images for [chapterId], ordered
  /// by page_number.
  Future<Either<Failure, List<BookPageEntity>>> getPagesByChapter(
    int chapterId,
  );
}
