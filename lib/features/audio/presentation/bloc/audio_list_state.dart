import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ishari/features/audio/domain/entities/audio_category.dart';
import 'package:ishari/features/audio/domain/entities/audio_track_entity.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_sort.dart';

part 'audio_list_state.freezed.dart';

T? _firstWhereOrNull<T>(Iterable<T> items, bool Function(T) test) {
  for (final item in items) {
    if (test(item)) return item;
  }
  return null;
}

enum AudioListStatus { initial, loading, loaded, error }

@freezed
abstract class AudioListState with _$AudioListState {
  const factory AudioListState({
    @Default(AudioListStatus.initial) AudioListStatus status,
    @Default(<AudioTrackEntity>[]) List<AudioTrackEntity> tracks,
    @Default('') String query,
    @Default(<AudioCategory, Set<String>>{})
    Map<AudioCategory, Set<String>> appliedSelected,
    @Default(<AudioCategory, Set<String>>{})
    Map<AudioCategory, Set<String>> draftSelected,
    @Default(AudioSort.terbaru) AudioSort sort,
    // Id of the loaded/current track — stays set while paused, only clears
    // on stop/completion/losing ownership to muhudVerse.
    String? playingId,
    @Default(false) bool isAudioLoading,
    // Actually producing sound right now — distinct from `playingId != null`
    // (loaded), since a loaded track can be paused.
    @Default(false) bool isPlaying,
    @Default(Duration.zero) Duration position,
    Duration? duration,
    String? errorMessage,
    // Bumped on every fetch completion so RefreshIndicator's stream.firstWhere
    // can detect "done" even when the refreshed data is value-equal to the
    // previous state (freezed equality would otherwise never emit a change).
    @Default(0) int refreshTick,
  }) = _AudioListState;

  const AudioListState._();

  /// Search + filter + sort, in that order.
  ///
  /// Filter matches a track if it satisfies AT LEAST ONE selected chip,
  /// across ANY section (OR-across-everything) — Hadi/Muhud/Rodad Cabang
  /// are independent facets a track can carry simultaneously (e.g. a
  /// specific hadi's recording of a specific rodad_cabang branch), not a
  /// single exclusive category. Treating them as exclusive would hide a
  /// track from the Hadi filter just because it also has a rodad_cabang
  /// value, which is wrong — the track genuinely has both.
  List<AudioTrackEntity> get filteredSortedTracks {
    final q = query.trim().toLowerCase();
    final hadiSel = appliedSelected[AudioCategory.hadi] ?? const <String>{};
    final muhudSel = appliedSelected[AudioCategory.muhud] ?? const <String>{};
    final rodadSel =
        appliedSelected[AudioCategory.rodadCabang] ?? const <String>{};
    final hasAnySelection =
        hadiSel.isNotEmpty || muhudSel.isNotEmpty || rodadSel.isNotEmpty;

    final list =
        tracks.where((t) {
          if (hasAnySelection) {
            final matchesHadi =
                t.hadiName != null && hadiSel.contains(t.hadiName);
            final matchesMuhud = muhudSel.contains(t.title);
            final matchesRodad =
                t.rodadCabang != null && rodadSel.contains(t.rodadCabang);
            if (!matchesHadi && !matchesMuhud && !matchesRodad) return false;
          }
          if (q.isNotEmpty) {
            final matchesTitle = t.title.toLowerCase().contains(q);
            final matchesHadi = (t.hadiName ?? '').toLowerCase().contains(q);
            if (!matchesTitle && !matchesHadi) return false;
          }
          return true;
        }).toList()..sort((a, b) {
          return switch (sort) {
            AudioSort.terbaru => b.createdAt.compareTo(a.createdAt),
            AudioSort.terlama => a.createdAt.compareTo(b.createdAt),
            AudioSort.az => a.title.toLowerCase().compareTo(
              b.title.toLowerCase(),
            ),
          };
        });
    return list;
  }

  /// Distinct chip values per filter section, sorted alphabetically. Each
  /// section reads a different, independent facet — a track can contribute
  /// to more than one section at once. "Muhud" reads chapter title (every
  /// track has one, so this section only empties out when there are no
  /// tracks at all); Hadi/Rodad Cabang are optional and can genuinely be
  /// empty. Empty sections are omitted so the UI doesn't show one with no
  /// chips.
  Map<AudioCategory, List<String>> get categorySubValues {
    final map = <AudioCategory, List<String>>{};

    final hadiValues =
        tracks
            .where((t) => t.hadiName != null)
            .map((t) => t.hadiName!)
            .toSet()
            .toList()
          ..sort();
    if (hadiValues.isNotEmpty) map[AudioCategory.hadi] = hadiValues;

    // "Muhud" in this app's terminology means "chapter" — every track has
    // one, so this facet reads straight off `title` for ALL tracks, not
    // gated by any DB category value.
    final muhudValues = tracks.map((t) => t.title).toSet().toList()..sort();
    if (muhudValues.isNotEmpty) map[AudioCategory.muhud] = muhudValues;

    final rodadValues =
        tracks
            .where((t) => t.rodadCabang != null)
            .map((t) => t.rodadCabang!)
            .toSet()
            .toList()
          ..sort();
    if (rodadValues.isNotEmpty) map[AudioCategory.rodadCabang] = rodadValues;

    return map;
  }

  int get totalAppliedFilterCount =>
      appliedSelected.values.fold(0, (n, s) => n + s.length);

  int get totalDraftFilterCount =>
      draftSelected.values.fold(0, (n, s) => n + s.length);

  AudioTrackEntity? get playingTrack =>
      _firstWhereOrNull(tracks, (t) => t.id == playingId);
}
