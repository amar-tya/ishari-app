part of 'search_bloc.dart';

@freezed
class SearchState with _$SearchState {
  /// No active query — show idle/prompt UI.
  const factory SearchState.idle() = _Idle;

  /// Query submitted, waiting for results.
  const factory SearchState.loading() = _Loading;

  /// Results returned successfully.
  const factory SearchState.results({
    required List<ChapterEntity> chapters,
    required String query,
    required String category,
  }) = _Results;

  /// Query returned no results.
  const factory SearchState.empty({
    required String query,
    required String category,
  }) = _Empty;

  /// Search failed (network or server error).
  const factory SearchState.error(String message) = _Error;
}
