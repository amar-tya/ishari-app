import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/muhud/domain/entities/verse_with_details_entity.dart';

part 'muhud_state.freezed.dart';

@freezed
sealed class MuhudState with _$MuhudState {
  const factory MuhudState.initial() = _Initial;

  const factory MuhudState.loading() = _Loading;

  const factory MuhudState.loaded({
    required ChapterEntity chapter,
    required List<VerseWithDetailsEntity> verses,
    required Set<int> bookmarkedVerseIds,
    required bool showTranslation,
    int? playingVerseId,
    @Default(false) bool isAudioLoading,
    @Default(true) bool showArabic,
    @Default(true) bool showTransliteration,
  }) = _Loaded;

  const factory MuhudState.error({required String message}) = _Error;
}
