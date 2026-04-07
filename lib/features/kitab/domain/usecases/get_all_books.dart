import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/usecases/usecase.dart';
import 'package:ishari/features/kitab/domain/entities/book_entity.dart';
import 'package:ishari/features/kitab/domain/repositories/kitab_repository.dart';

@injectable
class GetAllBooks implements UseCase<List<BookEntity>, NoParams> {
  const GetAllBooks(this._repository);

  final KitabRepository _repository;

  @override
  Future<Either<Failure, List<BookEntity>>> call(NoParams params) =>
      _repository.getAllBooks();
}
