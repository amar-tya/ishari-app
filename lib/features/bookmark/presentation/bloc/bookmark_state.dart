part of 'bookmark_bloc.dart';

@freezed
sealed class BookmarkState with _$BookmarkState {
  const factory BookmarkState.initial() = _Initial;

  const factory BookmarkState.loading() = _Loading;

  const factory BookmarkState.loaded({
    required List<BookmarkedVerseEntity> allBookmarks,
    required List<BookmarkedVerseEntity> filtered,
    required String selectedCategory,
    @Default(true) bool newestFirst,
    @Default('') String searchQuery,
  }) = _Loaded;

  const factory BookmarkState.error({required String message}) = _Error;
}
