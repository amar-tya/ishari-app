import 'package:freezed_annotation/freezed_annotation.dart';

part 'hadi_directory_event.freezed.dart';

@freezed
sealed class HadiDirectoryEvent with _$HadiDirectoryEvent {
  const factory HadiDirectoryEvent.loadAll({
    @Default(false) bool forceRefresh,
  }) = _LoadAll;

  const factory HadiDirectoryEvent.searchChanged(String query) = _SearchChanged;

  const factory HadiDirectoryEvent.playTrack(int audioId) = _PlayTrack;

  const factory HadiDirectoryEvent.stopAudio() = _StopAudio;

  /// Another feature claimed the shared player.
  const factory HadiDirectoryEvent.ownershipLost() = _OwnershipLost;

  /// The shared player started or stopped producing sound, including through
  /// the lockscreen/notification controls.
  const factory HadiDirectoryEvent.playingChanged({required bool isPlaying}) =
      _PlayingChanged;
}
