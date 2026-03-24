import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/search/domain/repositories/search_repository.dart';

class SearchParams {
  const SearchParams({required this.query, required this.category});

  final String query;
  final String category;
}

@injectable
class SearchChapters {
  const SearchChapters(this._repository);

  final SearchRepository _repository;

  Future<Either<Failure, List<ChapterEntity>>> call(SearchParams params) =>
      _repository.searchChapters(
        query: params.query,
        category: params.category,
      );
}
