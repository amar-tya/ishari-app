import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/muhud/domain/entities/bookmarked_verse_entity.dart';
import 'package:ishari/features/muhud/domain/entities/verse_with_details_entity.dart';
import 'package:ishari/features/muhud/domain/repositories/muhud_repository.dart';

/// [MuhudRepository] double whose toggle calls stay pending until the test
/// completes the matching entry in [toggles].
class FakeMuhudRepository implements MuhudRepository {
  FakeMuhudRepository({
    this.bookmarkedIds = const [],
    this.bookmarks = const [],
  });

  final List<int> bookmarkedIds;
  final List<BookmarkedVerseEntity> bookmarks;

  final toggledVerseIds = <int>[];
  final toggles = <Completer<Either<Failure, bool>>>[];

  @override
  Future<Either<Failure, bool>> toggleBookmark(
    int verseId,
    String userId, {
    String? note,
  }) {
    toggledVerseIds.add(verseId);
    final completer = Completer<Either<Failure, bool>>();
    toggles.add(completer);
    return completer.future;
  }

  @override
  Future<Either<Failure, ChapterEntity>> getChapterById(int chapterId) async =>
      right(
        const ChapterEntity(
          id: '1',
          title: 'Chapter',
          category: 'Diwan',
          description: '',
        ),
      );

  @override
  Future<Either<Failure, List<VerseWithDetailsEntity>>> getVersesByChapter(
    int chapterId,
  ) async => right(const []);

  @override
  Future<Either<Failure, List<int>>> getBookmarkedVerseIds(
    String userId,
  ) async => right(bookmarkedIds);

  @override
  Future<Either<Failure, List<BookmarkedVerseEntity>>> getBookmarkedVerses(
    String userId,
  ) async => right(bookmarks);

  @override
  Future<Either<Failure, List<ChapterEntity>>> getAllChapters() async =>
      right(const []);

  @override
  Future<Either<Failure, void>> updateBookmarkNote(
    int verseId,
    String? note,
  ) async => right(null);
}

/// Lets pending bloc events and futures run.
Future<void> pump() => Future<void>.delayed(Duration.zero);
