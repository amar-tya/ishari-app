import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/muhud/domain/repositories/muhud_repository.dart';

@injectable
class GetAllChapters {
  const GetAllChapters(this.repository);

  final MuhudRepository repository;

  Future<Either<Failure, List<ChapterEntity>>> call() =>
      repository.getAllChapters();
}
