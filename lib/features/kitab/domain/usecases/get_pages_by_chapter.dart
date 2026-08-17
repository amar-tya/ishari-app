import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/kitab/domain/entities/book_page_entity.dart';
import 'package:ishari/features/kitab/domain/repositories/kitab_repository.dart';

@injectable
class GetPagesByChapter {
  const GetPagesByChapter(this._repository);

  final KitabRepository _repository;

  Future<Either<Failure, List<BookPageEntity>>> call(int chapterId) =>
      _repository.getPagesByChapter(chapterId);
}
