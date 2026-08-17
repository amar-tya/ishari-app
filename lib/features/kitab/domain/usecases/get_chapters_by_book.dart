import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/kitab/domain/repositories/kitab_repository.dart';

@injectable
class GetChaptersByBook {
  const GetChaptersByBook(this._repository);

  final KitabRepository _repository;

  Future<Either<Failure, List<ChapterEntity>>> call(int bookId) =>
      _repository.getChaptersByBook(bookId);
}
