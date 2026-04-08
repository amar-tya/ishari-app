part of 'update_cubit.dart';

@freezed
class UpdateState with _$UpdateState {
  /// Before check is triggered.
  const factory UpdateState.initial() = _Initial;

  /// Check in progress.
  const factory UpdateState.checking() = _Checking;

  /// Current version is up to date.
  const factory UpdateState.upToDate() = _UpToDate;

  /// A newer version is available but not required.
  const factory UpdateState.softUpdate({
    required String latestVersion,
    required String storeUrl,
    required String releaseNotes,
  }) = _SoftUpdate;

  /// Current version is below the minimum — user must update.
  const factory UpdateState.forceUpdate({
    required String storeUrl,
    required String releaseNotes,
  }) = _ForceUpdate;

  /// Check failed (treated as up-to-date so user is not blocked).
  const factory UpdateState.error(String message) = _Error;
}
