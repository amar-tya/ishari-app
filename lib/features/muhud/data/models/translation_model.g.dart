// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TranslationModel _$TranslationModelFromJson(Map<String, dynamic> json) =>
    _TranslationModel(
      id: _idToString(json['id']),
      verseId: _idToString(json['verse_id']),
      languageCode: json['language_code'] as String,
      translationText: json['translation_text'] as String,
    );

Map<String, dynamic> _$TranslationModelToJson(_TranslationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'verse_id': instance.verseId,
      'language_code': instance.languageCode,
      'translation_text': instance.translationText,
    };
