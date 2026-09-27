import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ishari/features/audio/domain/entities/audio_category.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_sort.dart';

part 'audio_list_event.freezed.dart';

@freezed
sealed class AudioListEvent with _$AudioListEvent {
  const factory AudioListEvent.loadAll({@Default(false) bool forceRefresh}) =
      _LoadAll;

  const factory AudioListEvent.searchChanged(String query) = _SearchChanged;

  const factory AudioListEvent.sortChanged(AudioSort sort) = _SortChanged;

  /// Clones `appliedSelected` into `draftSelected` — called right before
  /// opening the filter sheet (a `showModalBottomSheet`, which owns its own
  /// visibility/dismiss — the bloc only needs to seed the draft).
  const factory AudioListEvent.openFilterSheet() = _OpenFilterSheet;

  const factory AudioListEvent.resetFilterDraft() = _ResetFilterDraft;

  const factory AudioListEvent.applyFilter() = _ApplyFilter;

  const factory AudioListEvent.toggleDraftChip(
    AudioCategory category,
    String value,
  ) = _ToggleDraftChip;

  /// Tapped from a track row or the mini player. Loads [trackId] if it isn't
  /// already the current one; otherwise toggles pause/resume in place
  /// (position is preserved either way).
  const factory AudioListEvent.playTrack(String trackId) = _PlayTrack;

  /// Track finished playing on its own (not via pause/replace).
  const factory AudioListEvent.stopAudio() = _StopAudio;

  /// Another audio source (chapter-reader verse audio) claimed the shared
  /// player — clear local playback state without touching the player itself
  /// (it's already been stopped/replaced by that source's own load call).
  const factory AudioListEvent.ownershipLost() = _OwnershipLost;

  /// Mini player's ±10s buttons.
  const factory AudioListEvent.seekBy(Duration offset) = _SeekBy;

  /// Mini player's progress bar — tap or drag to an absolute position.
  const factory AudioListEvent.seekTo(Duration position) = _SeekTo;

  const factory AudioListEvent.positionChanged(Duration position) =
      _PositionChanged;

  const factory AudioListEvent.durationChanged(Duration? duration) =
      _DurationChanged;

  const factory AudioListEvent.playingChanged({required bool isPlaying}) =
      _PlayingChanged;
}
