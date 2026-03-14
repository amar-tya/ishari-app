// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadi_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HadiModel _$HadiModelFromJson(Map<String, dynamic> json) => _HadiModel(
  id: _idToString(json['id']),
  name: json['name'] as String,
  photoUrl: json['image_url'] as String?,
);

Map<String, dynamic> _$HadiModelToJson(_HadiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image_url': instance.photoUrl,
    };
