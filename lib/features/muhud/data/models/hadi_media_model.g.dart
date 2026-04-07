// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadi_media_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HadiMediaModel _$HadiMediaModelFromJson(Map<String, dynamic> json) =>
    _HadiMediaModel(
      id: _idToString(json['id']),
      name: json['name'] as String,
      photoUrl: json['image_url'] as String?,
    );

Map<String, dynamic> _$HadiMediaModelToJson(_HadiMediaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image_url': instance.photoUrl,
    };
