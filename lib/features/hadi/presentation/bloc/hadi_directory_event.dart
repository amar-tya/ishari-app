import 'package:freezed_annotation/freezed_annotation.dart';

part 'hadi_directory_event.freezed.dart';

@freezed
sealed class HadiDirectoryEvent with _$HadiDirectoryEvent {
  const factory HadiDirectoryEvent.loadAll() = _LoadAll;

  const factory HadiDirectoryEvent.searchChanged(String query) =
      _SearchChanged;

  const factory HadiDirectoryEvent.playTrack(int audioId) = _PlayTrack;

  const factory HadiDirectoryEvent.stopAudio() = _StopAudio;
}
