import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ishari/features/muhud/domain/entities/verse_media_type.dart';

part 'hadi_audio_entity.freezed.dart';

@freezed
abstract class HadiAudioEntity with _$HadiAudioEntity {
  const factory HadiAudioEntity({
    required int id,
    required String hadiId,
    required int verseId,
    required int verseNumber,
    required String chapterTitle,
    required String arabicText,
    required String mediaUrl,
    required VerseMediaType type,
    int? duration,
  }) = _HadiAudioEntity;
}
