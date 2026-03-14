import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/muhud/domain/repositories/muhud_repository.dart';

@injectable
class GetBookmarkedVerseIds {
  const GetBookmarkedVerseIds(this.repository);

  final MuhudRepository repository;

  Future<Either<Failure, List<int>>> call(String userId) =>
      repository.getBookmarkedVerseIds(userId);
}
