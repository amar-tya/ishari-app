part of 'bookmark_bloc.dart';

@freezed
sealed class BookmarkEvent with _$BookmarkEvent {
  const factory BookmarkEvent.load({required String userId}) = _Load;

  const factory BookmarkEvent.filterChanged({required String category}) =
      _FilterChanged;

  const factory BookmarkEvent.toggleSort() = _ToggleSort;

  const factory BookmarkEvent.searchChanged({required String query}) =
      _SearchChanged;

  const factory BookmarkEvent.removeBookmark({
    required int verseId,
    required String userId,
  }) = _RemoveBookmark;

  const factory BookmarkEvent.updateNote({
    required int verseId,
    required String? note,
  }) = _UpdateNote;
}
