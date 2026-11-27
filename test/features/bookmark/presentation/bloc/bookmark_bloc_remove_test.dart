import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:ishari/features/muhud/domain/entities/bookmarked_verse_entity.dart';
import 'package:ishari/features/muhud/domain/usecases/get_bookmarked_verses.dart';
import 'package:ishari/features/muhud/domain/usecases/toggle_bookmark.dart';
import 'package:ishari/features/muhud/domain/usecases/update_bookmark_note.dart';

import '../../../muhud/fakes/fake_muhud_repository.dart';

BookmarkedVerseEntity _bookmark(int verseId) => BookmarkedVerseEntity(
  verseId: verseId,
  verseNumber: verseId,
  arabicText: 'a',
  transliteration: 't',
  chapterId: 1,
  chapterTitle: 'Chapter',
  chapterCategory: 'Diwan',
  bookmarkedAt: DateTime(2024, 1, verseId),
);

void main() {
  Future<BookmarkBloc> loadedBloc(FakeMuhudRepository repository) async {
    final bloc = BookmarkBloc(
      GetBookmarkedVerses(repository),
      ToggleBookmark(repository),
      UpdateBookmarkNote(repository),
    );
    addTearDown(bloc.close);
    bloc.add(const BookmarkEvent.load(userId: 'u'));
    await pump();
    return bloc;
  }

  FakeMuhudRepository repositoryWithTwoBookmarks() =>
      FakeMuhudRepository(bookmarks: [_bookmark(5), _bookmark(6)]);

  List<int> visibleIds(BookmarkBloc bloc) => bloc.state.mapOrNull(
    loaded: (l) => l.filtered.map((b) => b.verseId).toList()..sort(),
  )!;

  Future<void> remove(BookmarkBloc bloc, int verseId) async {
    bloc.add(BookmarkEvent.removeBookmark(verseId: verseId, userId: 'u'));
    await pump();
  }

  test('ignores a second removal while the first is in flight', () async {
    final repository = repositoryWithTwoBookmarks();
    final bloc = await loadedBloc(repository);

    await remove(bloc, 5);
    await remove(bloc, 5);

    expect(repository.toggledVerseIds, [5]);

    repository.toggles.single.complete(right(false));
    await pump();

    expect(visibleIds(bloc), [6]);
  });

  test('keeps the card when removal fails and accepts a retry', () async {
    final repository = repositoryWithTwoBookmarks();
    final bloc = await loadedBloc(repository);

    await remove(bloc, 5);
    repository.toggles.single.complete(left(const ServerFailure()));
    await pump();

    expect(visibleIds(bloc), [5, 6]);

    await remove(bloc, 5);
    expect(repository.toggledVerseIds, [5, 5]);
  });

  test('keeps the card when the toggle re-added the bookmark', () async {
    final repository = repositoryWithTwoBookmarks();
    final bloc = await loadedBloc(repository);

    await remove(bloc, 5);
    repository.toggles.single.complete(right(true));
    await pump();

    expect(visibleIds(bloc), [5, 6]);
  });

  test('releases the in-flight entry when the use case throws', () async {
    final repository = repositoryWithTwoBookmarks();
    final errors = <Object>[];
    // The bloc rethrows handler errors into the zone it was created in.
    await runZonedGuarded(() async {
      final bloc = await loadedBloc(repository);
      await remove(bloc, 5);
      repository.toggles.single.completeError(StateError('boom'));
      await pump();
      await remove(bloc, 5);
    }, (error, _) => errors.add(error));

    expect(errors.single, isStateError);
    expect(repository.toggledVerseIds, [5, 5]);
  });
}
