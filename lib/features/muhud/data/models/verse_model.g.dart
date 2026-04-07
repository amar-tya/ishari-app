// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verse_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VerseModel _$VerseModelFromJson(Map<String, dynamic> json) => _VerseModel(
  id: _idToString(json['id']),
  chapterId: _idToString(json['chapter_id']),
  verseNumber: _idToString(json['verse_number']),
  arabicText: json['arabic_text'] as String,
  transliteration: json['transliteration'] as String,
);

Map<String, dynamic> _$VerseModelToJson(_VerseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chapter_id': instance.chapterId,
      'verse_number': instance.verseNumber,
      'arabic_text': instance.arabicText,
      'transliteration': instance.transliteration,
    };
