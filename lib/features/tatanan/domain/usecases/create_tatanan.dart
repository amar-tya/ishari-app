import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/tatanan/domain/repositories/tatanan_repository.dart';

@injectable
class CreateTatanan {
  const CreateTatanan(this._repository);

  final TatananRepository _repository;

  Future<Either<Failure, String>> call({
    required String userId,
    required int chapterId,
    required String name,
    String? description,
  }) =>
      _repository.createTatanan(
        userId: userId,
        chapterId: chapterId,
        name: name,
        description: description,
      );
}
