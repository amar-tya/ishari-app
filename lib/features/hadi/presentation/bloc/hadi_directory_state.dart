import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ishari/features/hadi/domain/entities/hadi_audio_entity.dart';
import 'package:ishari/features/hadi/domain/entities/hadi_summary_entity.dart';
import 'package:ishari/features/muhud/domain/entities/verse_media_type.dart';

part 'hadi_directory_state.freezed.dart';

T? _firstWhereOrNull<T>(Iterable<T> items, bool Function(T) test) {
  for (final item in items) {
    if (test(item)) return item;
  }
  return null;
}

enum HadiDirectoryStatus { initial, loading, loaded, error }

@freezed
abstract class HadiDirectoryState with _$HadiDirectoryState {
  const factory HadiDirectoryState({
    @Default(HadiDirectoryStatus.initial) HadiDirectoryStatus status,
    @Default(<HadiSummaryEntity>[]) List<HadiSummaryEntity> hadiList,
    @Default(<HadiAudioEntity>[]) List<HadiAudioEntity> audioList,
    @Default('') String searchQuery,
    int? playingAudioId,
    @Default(false) bool isAudioLoading,
    String? errorMessage,
    // Bumped on every fetch completion so RefreshIndicator's stream.firstWhere
    // can detect "done" even when the refreshed data is value-equal to the
    // previous state (freezed equality would otherwise never emit a change).
    @Default(0) int refreshTick,
  }) = _HadiDirectoryState;

  const HadiDirectoryState._();

  List<HadiSummaryEntity> get filteredHadiList {
    if (searchQuery.trim().isEmpty) return hadiList;
    final query = searchQuery.trim().toLowerCase();
    return hadiList.where((h) => h.name.toLowerCase().contains(query)).toList();
  }

  int get totalAudioCount => audioList.length;

  String get hadiCountLabel =>
      '${hadiList.length} Hadi · $totalAudioCount audio';

  int audioCountFor(String hadiId) =>
      audioList.where((a) => a.hadiId == hadiId).length;

  HadiSummaryEntity? hadiById(String hadiId) =>
      _firstWhereOrNull(hadiList, (h) => h.id == hadiId);

  List<HadiAudioEntity> audioForHadi(String hadiId) =>
      audioList.where((a) => a.hadiId == hadiId).toList();

  Map<VerseMediaType, List<HadiAudioEntity>> groupedAudioForHadi(
    String hadiId,
  ) {
    final tracks = audioForHadi(hadiId);
    final grouped = <VerseMediaType, List<HadiAudioEntity>>{};
    for (final type in VerseMediaType.values) {
      final inGroup = tracks.where((t) => t.type == type).toList();
      if (inGroup.isNotEmpty) grouped[type] = inGroup;
    }
    return grouped;
  }

  HadiAudioEntity? get playingTrack =>
      _firstWhereOrNull(audioList, (a) => a.id == playingAudioId);
}
