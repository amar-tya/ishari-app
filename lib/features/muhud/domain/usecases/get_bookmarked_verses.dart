import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/muhud/domain/entities/bookmarked_verse_entity.dart';
import 'package:ishari/features/muhud/domain/repositories/muhud_repository.dart';

@injectable
class GetBookmarkedVerses {
  const GetBookmarkedVerses(this.repository);

  final MuhudRepository repository;

  Future<Either<Failure, List<BookmarkedVerseEntity>>> call(String userId) =>
      repository.getBookmarkedVerses(userId);
}
