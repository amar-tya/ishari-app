import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/usecases/usecase.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/home/domain/repositories/home_repository.dart';

class CategoryParams {
  const CategoryParams(this.category);

  final String category;
}

@injectable
class GetChaptersByCategory
    implements UseCase<List<ChapterEntity>, CategoryParams> {
  const GetChaptersByCategory(this._repository);

  final HomeRepository _repository;

  @override
  Future<Either<Failure, List<ChapterEntity>>> call(CategoryParams params) =>
      _repository.getChaptersByCategory(params.category);
}
