import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/kitab/domain/entities/book_entity.dart';

abstract interface class KitabRepository {
  Future<Either<Failure, List<BookEntity>>> getAllBooks();
}
