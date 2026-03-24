import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';

abstract interface class SearchRepository {
  /// Search chapters by [query] in title, optionally filtered by [category].
  ///
  /// Pass `'Semua'` for [category] to search across all categories.
  Future<Either<Failure, List<ChapterEntity>>> searchChapters({
    required String query,
    required String category,
  });
}
