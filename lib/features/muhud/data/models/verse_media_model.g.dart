// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verse_media_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VerseMediaModel _$VerseMediaModelFromJson(Map<String, dynamic> json) =>
    _VerseMediaModel(
      id: _idToString(json['id']),
      verseId: _verseIdToString(json['verse_id']),
      hadi: HadiMediaModel.fromJson(json['hadi'] as Map<String, dynamic>),
      mediaUrl: json['media_url'] as String,
      duration: _idToString(json['duration']),
      type: _typeToString(json['type']),
    );

Map<String, dynamic> _$VerseMediaModelToJson(_VerseMediaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'verse_id': instance.verseId,
      'hadi': instance.hadi,
      'media_url': instance.mediaUrl,
      'duration': instance.duration,
      'type': instance.type,
    };
