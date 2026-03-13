part of 'home_bloc.dart';

@freezed
class HomeEvent with _$HomeEvent {
  /// Load home data. Pass [userId] for authenticated users (determines which
  /// featured chapter to show). Pass `null` for guest mode.
  const factory HomeEvent.load({String? userId}) = _Load;

  /// User tapped a category chip.
  const factory HomeEvent.categorySelected(String category) =
      _CategorySelected;

  /// Pull-to-refresh.
  const factory HomeEvent.refresh({String? userId}) = _Refresh;
}
