import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/features/muhud/domain/entities/bookmarked_verse_entity.dart';
import 'package:ishari/features/muhud/domain/usecases/get_bookmarked_verses.dart';
import 'package:ishari/features/muhud/domain/usecases/toggle_bookmark.dart';

part 'bookmark_bloc.freezed.dart';
part 'bookmark_event.dart';
part 'bookmark_state.dart';

@injectable
class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  BookmarkBloc(this._getBookmarkedVerses, this._toggleBookmark)
      : super(const BookmarkState.initial()) {
    on<_Load>(_onLoad);
    on<_FilterChanged>(_onFilterChanged);
    on<_ToggleSort>(_onToggleSort);
    on<_SearchChanged>(_onSearchChanged);
    on<_RemoveBookmark>(_onRemoveBookmark);
  }

  final GetBookmarkedVerses _getBookmarkedVerses;
  final ToggleBookmark _toggleBookmark;

  Future<void> _onLoad(_Load event, Emitter<BookmarkState> emit) async {
    emit(const BookmarkState.loading());
    final result = await _getBookmarkedVerses(event.userId);
    result.fold(
      (failure) => emit(BookmarkState.error(message: failure.message)),
      (bookmarks) => emit(
        BookmarkState.loaded(
          allBookmarks: bookmarks,
          filtered: bookmarks,
          selectedCategory: 'Semua',
        ),
      ),
    );
  }

  void _onFilterChanged(_FilterChanged event, Emitter<BookmarkState> emit) {
    state.mapOrNull(
      loaded: (l) {
        final filtered = _applyFilters(
          l.allBookmarks,
          event.category,
          l.searchQuery,
          l.newestFirst,
        );
        emit(l.copyWith(selectedCategory: event.category, filtered: filtered));
      },
    );
  }

  void _onToggleSort(_ToggleSort event, Emitter<BookmarkState> emit) {
    state.mapOrNull(
      loaded: (l) {
        final newNewest = !l.newestFirst;
        final filtered = _applyFilters(
          l.allBookmarks,
          l.selectedCategory,
          l.searchQuery,
          newNewest,
        );
        emit(l.copyWith(newestFirst: newNewest, filtered: filtered));
      },
    );
  }

  void _onSearchChanged(_SearchChanged event, Emitter<BookmarkState> emit) {
    state.mapOrNull(
      loaded: (l) {
        final filtered = _applyFilters(
          l.allBookmarks,
          l.selectedCategory,
          event.query,
          l.newestFirst,
        );
        emit(l.copyWith(searchQuery: event.query, filtered: filtered));
      },
    );
  }

  Future<void> _onRemoveBookmark(
    _RemoveBookmark event,
    Emitter<BookmarkState> emit,
  ) async {
    await _toggleBookmark(event.verseId, event.userId);
    state.mapOrNull(
      loaded: (l) {
        final updated =
            l.allBookmarks.where((b) => b.verseId != event.verseId).toList();
        final filtered = _applyFilters(
          updated,
          l.selectedCategory,
          l.searchQuery,
          l.newestFirst,
        );
        emit(l.copyWith(allBookmarks: updated, filtered: filtered));
      },
    );
  }

  List<BookmarkedVerseEntity> _applyFilters(
    List<BookmarkedVerseEntity> all,
    String category,
    String query,
    bool newestFirst,
  ) {
    var result = all;

    if (category != 'Semua') {
      result = result.where((b) => b.chapterCategory == category).toList();
    }

    if (query.isNotEmpty) {
      final q = query.toLowerCase();
      result = result
          .where(
            (b) =>
                b.chapterTitle.toLowerCase().contains(q) ||
                b.arabicText.contains(q) ||
                b.transliteration.toLowerCase().contains(q),
          )
          .toList();
    }

    result.sort(
      (a, b) => newestFirst
          ? b.bookmarkedAt.compareTo(a.bookmarkedAt)
          : a.bookmarkedAt.compareTo(b.bookmarkedAt),
    );

    return result;
  }
}
