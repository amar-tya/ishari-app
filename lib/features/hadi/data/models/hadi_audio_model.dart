import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ishari/features/hadi/domain/entities/hadi_audio_entity.dart';
import 'package:ishari/features/muhud/domain/entities/verse_media_type.dart';

part 'hadi_audio_model.freezed.dart';

int _toInt(dynamic v) => v is int ? v : int.parse(v.toString());

@freezed
abstract class HadiAudioModel with _$HadiAudioModel {
  const factory HadiAudioModel({
    required int id,
    required String hadiId,
    required int verseId,
    required int verseNumber,
    required String chapterTitle,
    required String arabicText,
    required String mediaUrl,
    required VerseMediaType type,
    int? duration,
  }) = _HadiAudioModel;

  const HadiAudioModel._();

  /// Built from a `verse_media` row joined with
  /// `verses(verse_number, arabic_text, chapters(title))`.
  factory HadiAudioModel.fromJson(Map<String, dynamic> json) {
    final verse = json['verses'] as Map<String, dynamic>;
    final chapter = verse['chapters'] as Map<String, dynamic>;
    return HadiAudioModel(
      id: _toInt(json['id']),
      hadiId: json['hadi_id'].toString(),
      verseId: _toInt(json['verse_id']),
      verseNumber: _toInt(verse['verse_number']),
      chapterTitle: chapter['title'] as String,
      arabicText: verse['arabic_text'] as String,
      mediaUrl: json['media_url'] as String,
      duration: json['duration'] == null ? null : _toInt(json['duration']),
      type: VerseMediaTypeExt.fromString(json['type'] as String? ?? 'joz'),
    );
  }

  HadiAudioEntity toEntity() => HadiAudioEntity(
    id: id,
    hadiId: hadiId,
    verseId: verseId,
    verseNumber: verseNumber,
    chapterTitle: chapterTitle,
    arabicText: arabicText,
    mediaUrl: mediaUrl,
    duration: duration,
    type: type,
  );
}
