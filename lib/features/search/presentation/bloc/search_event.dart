part of 'search_bloc.dart';

@freezed
class SearchEvent with _$SearchEvent {
  /// User typed in the search bar.
  const factory SearchEvent.queryChanged(String query) = _QueryChanged;

  /// User selected a category chip.
  const factory SearchEvent.categorySelected(String category) =
      _CategorySelected;

  /// User tapped the clear button.
  const factory SearchEvent.cleared() = _Cleared;
}
