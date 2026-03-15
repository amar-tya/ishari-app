import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ishari/features/muhud/domain/entities/verse_media_type.dart';

part 'muhud_event.freezed.dart';

@freezed
sealed class MuhudEvent with _$MuhudEvent {
  const factory MuhudEvent.loadChapter({required int chapterId}) =
      _LoadChapter;

  const factory MuhudEvent.toggleTranslation() = _ToggleTranslation;

  const factory MuhudEvent.toggleBookmark({required int verseId}) =
      _ToggleBookmark;

  const factory MuhudEvent.playVerse({
    required int verseId,
    required String hadiId,
    required VerseMediaType recitationType,
  }) = _PlayVerse;

  const factory MuhudEvent.stopAudio() = _StopAudio;

  const factory MuhudEvent.toggleArabic() = _ToggleArabic;

  const factory MuhudEvent.toggleTransliteration() = _ToggleTransliteration;
}
