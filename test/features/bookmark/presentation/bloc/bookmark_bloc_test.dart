// Loading, filtering, sorting, searching and notes of the bookmark list.
// Removal is in `bookmark_bloc_remove_test.dart`.
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:ishari/features/muhud/domain/entities/bookmarked_verse_entity.dart';
import 'package:ishari/features/muhud/domain/usecases/get_bookmarked_verses.dart';
import 'package:ishari/features/muhud/domain/usecases/toggle_bookmark.dart';
import 'package:ishari/features/muhud/domain/usecases/update_bookmark_note.dart';

import '../../../muhud/fakes/fake_muhud_repository.dart';

BookmarkedVerseEntity _bookmark(
  int verseId, {
  String title = 'Chapter',
  String category = 'Diwan',
  String arabic = 'a',
  String transliteration = 't',
  int day = 1,
  String? note,
}) => BookmarkedVerseEntity(
  verseId: verseId,
  verseNumber: verseId,
  arabicText: arabic,
  transliteration: transliteration,
  chapterId: 1,
  chapterTitle: title,
  chapterCategory: category,
  bookmarkedAt: DateTime(2024, 1, day),
  note: note,
);

/// Answers the bookmark load with [loadResult] and records note updates.
class _Repository extends FakeMuhudRepository {
  _Repository({super.bookmarks});

  Either<Failure, List<BookmarkedVerseEntity>>? loadResult;
  final loadedFor = <String>[];
  final notes = <(int, String?)>[];

  @override
  Future<Either<Failure, List<BookmarkedVerseEntity>>> getBookmarkedVerses(
    String userId,
  ) async {
    loadedFor.add(userId);
    return loadResult ?? right(bookmarks);
  }

  @override
  Future<Either<Failure, void>> updateBookmarkNote(
    int verseId,
    String? note,
  ) async {
    notes.add((verseId, note));
    return right(null);
  }
}

void main() {
  BookmarkBloc buildBloc(_Repository repository) {
    final bloc = BookmarkBloc(
      GetBookmarkedVerses(repository),
      ToggleBookmark(repository),
      UpdateBookmarkNote(repository),
    );
    addTearDown(bloc.close);
    return bloc;
  }

  Future<BookmarkBloc> loadedBloc(_Repository repository) async {
    final bloc = buildBloc(repository);
    bloc.add(const BookmarkEvent.load(userId: 'u'));
    await pump();
    return bloc;
  }

  Future<void> send(BookmarkBloc bloc, BookmarkEvent event) async {
    bloc.add(event);
    await pump();
  }

  List<int> visibleIds(BookmarkBloc bloc) => bloc.state.mapOrNull(
    loaded: (l) => l.filtered.map((b) => b.verseId).toList(),
  )!;

  group('load', () {
    test('starts empty and idle', () {
      expect(
        buildBloc(_Repository()).state,
        const BookmarkState.initial(),
      );
    });

    test('shows loading, then every bookmark under "Semua"', () async {
      final bookmarks = [_bookmark(1, day: 1), _bookmark(2, day: 2)];
      final repository = _Repository(bookmarks: bookmarks);
      final bloc = buildBloc(repository);
      final states = <BookmarkState>[];
      final subscription = bloc.stream.listen(states.add);
      addTearDown(subscription.cancel);

      bloc.add(const BookmarkEvent.load(userId: 'user-7'));
      await pump();

      expect(states, [
        const BookmarkState.loading(),
        BookmarkState.loaded(
          allBookmarks: bookmarks,
          filtered: bookmarks,
          selectedCategory: 'Semua',
        ),
      ]);
      expect(repository.loadedFor, ['user-7']);
    });

    test('loads an empty list as loaded, not as an error', () async {
      final bloc = await loadedBloc(_Repository());

      expect(
        bloc.state,
        const BookmarkState.loaded(
          allBookmarks: [],
          filtered: [],
          selectedCategory: 'Semua',
        ),
      );
    });

    test('a failure becomes the error state with its message', () async {
      final repository = _Repository()
        ..loadResult = left(const NetworkFailure());
      final bloc = await loadedBloc(repository);

      expect(
        bloc.state,
        const BookmarkState.error(
          message: FailureMessages.network,
        ),
      );
    });

    test('a retry after an error loads the list', () async {
      final repository = _Repository(bookmarks: [_bookmark(1)])
        ..loadResult = left(const ServerFailure());
      final bloc = await loadedBloc(repository);
      expect(
        bloc.state,
        const BookmarkState.error(message: FailureMessages.server),
      );

      repository.loadResult = null;
      await send(bloc, const BookmarkEvent.load(userId: 'u'));

      expect(visibleIds(bloc), [1]);
    });

    test('a reload resets the filter, search and sort', () async {
      final repository = _Repository(
        bookmarks: [
          _bookmark(1, category: 'Diwan', day: 1),
          _bookmark(2, category: 'Qasidah', day: 2),
        ],
      );
      final bloc = await loadedBloc(repository);
      await send(bloc, const BookmarkEvent.filterChanged(category: 'Qasidah'));
      await send(bloc, const BookmarkEvent.toggleSort());
      await send(bloc, const BookmarkEvent.searchChanged(query: 'chap'));

      await send(bloc, const BookmarkEvent.load(userId: 'u'));

      final loaded = bloc.state.mapOrNull(loaded: (l) => l)!;
      expect(loaded.selectedCategory, 'Semua');
      expect(loaded.searchQuery, isEmpty);
      expect(loaded.newestFirst, isTrue);
    });
  });

  group('filter, sort and search', () {
    late _Repository repository;

    setUp(() {
      repository = _Repository(
        bookmarks: [
          _bookmark(
            1,
            title: 'Burdah',
            category: 'Diwan',
            arabic: 'مولاي',
            transliteration: 'Mawlaya',
            day: 3,
          ),
          _bookmark(
            2,
            title: 'Simtudduror',
            category: 'Maulid',
            arabic: 'يا نبي',
            transliteration: 'Ya Nabi',
            day: 1,
          ),
          _bookmark(
            3,
            title: 'Diba',
            category: 'Maulid',
            arabic: 'الصلاة',
            transliteration: 'Ash-shalatu',
            day: 2,
          ),
        ],
      );
    });

    test(
      'is set to newest first, and applies it once the list changes',
      () async {
        final bloc = await loadedBloc(repository);
        expect(bloc.state.mapOrNull(loaded: (l) => l.newestFirst), isTrue);

        // Not in the repository's order, so this is the date order.
        await send(bloc, const BookmarkEvent.filterChanged(category: 'Semua'));

        expect(visibleIds(bloc), [1, 3, 2]);
      },
    );

    test('toggling the sort flips between newest and oldest first', () async {
      final bloc = await loadedBloc(repository);

      await send(bloc, const BookmarkEvent.toggleSort());
      expect(visibleIds(bloc), [2, 3, 1]);
      expect(bloc.state.mapOrNull(loaded: (l) => l.newestFirst), isFalse);

      await send(bloc, const BookmarkEvent.toggleSort());
      expect(visibleIds(bloc), [1, 3, 2]);
      expect(bloc.state.mapOrNull(loaded: (l) => l.newestFirst), isTrue);
    });

    test(
      'a category keeps only its bookmarks and "Semua" restores all',
      () async {
        final bloc = await loadedBloc(repository);

        await send(bloc, const BookmarkEvent.filterChanged(category: 'Maulid'));
        expect(visibleIds(bloc), [3, 2]);
        expect(
          bloc.state.mapOrNull(loaded: (l) => l.selectedCategory),
          'Maulid',
        );

        await send(bloc, const BookmarkEvent.filterChanged(category: 'Semua'));
        expect(visibleIds(bloc), [1, 3, 2]);
      },
    );

    test('a category nobody has leaves the list empty', () async {
      final bloc = await loadedBloc(repository);

      await send(bloc, const BookmarkEvent.filterChanged(category: 'Kosong'));

      expect(visibleIds(bloc), isEmpty);
      expect(
        bloc.state.mapOrNull(loaded: (l) => l.allBookmarks),
        hasLength(3),
      );
    });

    test('search matches the title without regard to case', () async {
      final bloc = await loadedBloc(repository);

      await send(bloc, const BookmarkEvent.searchChanged(query: 'BURD'));

      expect(visibleIds(bloc), [1]);
    });

    test('search matches the transliteration without regard to case', () async {
      final bloc = await loadedBloc(repository);

      await send(bloc, const BookmarkEvent.searchChanged(query: 'ya nabi'));

      expect(visibleIds(bloc), [2]);
    });

    test('search matches the Arabic text', () async {
      final bloc = await loadedBloc(repository);

      await send(bloc, const BookmarkEvent.searchChanged(query: 'الصلاة'));

      expect(visibleIds(bloc), [3]);
    });

    test(
      'search with no match is empty and clearing it restores all',
      () async {
        final bloc = await loadedBloc(repository);

        await send(bloc, const BookmarkEvent.searchChanged(query: 'zzz'));
        expect(visibleIds(bloc), isEmpty);

        await send(bloc, const BookmarkEvent.searchChanged(query: ''));
        expect(visibleIds(bloc), [1, 3, 2]);
      },
    );

    test('category, search and sort apply together', () async {
      final bloc = await loadedBloc(repository);

      await send(bloc, const BookmarkEvent.filterChanged(category: 'Maulid'));
      await send(bloc, const BookmarkEvent.searchChanged(query: 'a'));
      await send(bloc, const BookmarkEvent.toggleSort());

      // Diwan's Burdah matches "a" too, but is not in Maulid.
      expect(visibleIds(bloc), [2, 3]);
    });

    test('changing the filter keeps the search and sort', () async {
      final bloc = await loadedBloc(repository);
      await send(bloc, const BookmarkEvent.searchChanged(query: 'a'));
      await send(bloc, const BookmarkEvent.toggleSort());

      await send(bloc, const BookmarkEvent.filterChanged(category: 'Maulid'));

      final loaded = bloc.state.mapOrNull(loaded: (l) => l)!;
      expect(loaded.searchQuery, 'a');
      expect(loaded.newestFirst, isFalse);
      expect(visibleIds(bloc), [2, 3]);
    });

    test('filtering never drops bookmarks from the full list', () async {
      final bloc = await loadedBloc(repository);

      await send(bloc, const BookmarkEvent.filterChanged(category: 'Diwan'));
      await send(bloc, const BookmarkEvent.searchChanged(query: 'zzz'));
      await send(bloc, const BookmarkEvent.toggleSort());

      expect(
        bloc.state.mapOrNull(loaded: (l) => l.allBookmarks.length),
        3,
      );
    });

    test('removing a card keeps the active filter and search', () async {
      final bloc = await loadedBloc(repository);
      await send(bloc, const BookmarkEvent.filterChanged(category: 'Maulid'));
      await send(bloc, const BookmarkEvent.searchChanged(query: 'a'));

      bloc.add(const BookmarkEvent.removeBookmark(verseId: 3, userId: 'u'));
      await pump();
      repository.toggles.single.complete(right(false));
      await pump();

      expect(visibleIds(bloc), [2]);
      expect(
        bloc.state.mapOrNull(loaded: (l) => l.allBookmarks.length),
        2,
      );
    });
  });

  group('while there is no list', () {
    final events = <String, BookmarkEvent>{
      'a filter': const BookmarkEvent.filterChanged(category: 'Diwan'),
      'a sort': const BookmarkEvent.toggleSort(),
      'a search': const BookmarkEvent.searchChanged(query: 'a'),
      'a removal': const BookmarkEvent.removeBookmark(verseId: 1, userId: 'u'),
      'a note': const BookmarkEvent.updateNote(verseId: 1, note: 'n'),
    };

    /// Sends [event] and lets a removal finish as confirmed.
    Future<void> sendAndSettle(
      BookmarkBloc bloc,
      _Repository repository,
      BookmarkEvent event,
    ) async {
      bloc.add(event);
      await pump();
      for (final toggle in repository.toggles) {
        toggle.complete(right(false));
      }
      await pump();
    }

    for (final entry in events.entries) {
      test('${entry.key} changes nothing before the first load', () async {
        final repository = _Repository(bookmarks: [_bookmark(1)]);
        final bloc = buildBloc(repository);

        await sendAndSettle(bloc, repository, entry.value);

        expect(bloc.state, const BookmarkState.initial());
      });

      test('${entry.key} changes nothing after a failed load', () async {
        final repository = _Repository(bookmarks: [_bookmark(1)])
          ..loadResult = left(const ServerFailure());
        final bloc = await loadedBloc(repository);
        final before = bloc.state;

        await sendAndSettle(bloc, repository, entry.value);

        expect(bloc.state, before);
      });
    }
  });

  group('update note', () {
    test('shows the note at once, in the full and the filtered list', () async {
      final repository = _Repository(
        bookmarks: [
          _bookmark(1, category: 'Diwan', day: 1),
          _bookmark(2, category: 'Maulid', day: 2),
        ],
      );
      final bloc = await loadedBloc(repository);
      await send(bloc, const BookmarkEvent.filterChanged(category: 'Maulid'));

      await send(
        bloc,
        const BookmarkEvent.updateNote(verseId: 2, note: 'baru'),
      );

      final loaded = bloc.state.mapOrNull(loaded: (l) => l)!;
      expect(loaded.filtered.single.note, 'baru');
      expect(
        loaded.allBookmarks.firstWhere((b) => b.verseId == 2).note,
        'baru',
      );
      expect(
        loaded.allBookmarks.firstWhere((b) => b.verseId == 1).note,
        isNull,
      );
    });

    test('saves the note for that verse', () async {
      final repository = _Repository(bookmarks: [_bookmark(1), _bookmark(2)]);
      final bloc = await loadedBloc(repository);

      await send(
        bloc,
        const BookmarkEvent.updateNote(verseId: 2, note: 'baru'),
      );

      expect(repository.notes, [(2, 'baru')]);
    });

    test('a null note clears the note', () async {
      final repository = _Repository(bookmarks: [_bookmark(1, note: 'lama')]);
      final bloc = await loadedBloc(repository);

      await send(bloc, const BookmarkEvent.updateNote(verseId: 1, note: null));

      expect(
        bloc.state.mapOrNull(loaded: (l) => l.filtered.single.note),
        isNull,
      );
      expect(repository.notes, [(1, null)]);
    });

    test('a verse that is not listed changes no card', () async {
      final repository = _Repository(bookmarks: [_bookmark(1)]);
      final bloc = await loadedBloc(repository);
      final before = bloc.state;

      await send(bloc, const BookmarkEvent.updateNote(verseId: 99, note: 'x'));

      expect(bloc.state, before);
    });
  });
}
