import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/usecases/usecase.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/home/domain/repositories/home_repository.dart';

class FeaturedChapterParams {
  const FeaturedChapterParams({this.lastChapterId});

  /// ID of the last chapter read by the user. `null` for guest mode.
  final String? lastChapterId;
}

@injectable
class GetFeaturedChapter
    implements UseCase<ChapterEntity, FeaturedChapterParams> {
  const GetFeaturedChapter(this._repository);

  final HomeRepository _repository;

  @override
  Future<Either<Failure, ChapterEntity>> call(
    FeaturedChapterParams params,
  ) =>
      _repository.getFeaturedChapter(params.lastChapterId);
}
