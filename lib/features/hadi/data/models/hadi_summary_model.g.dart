// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadi_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HadiSummaryModel _$HadiSummaryModelFromJson(Map<String, dynamic> json) =>
    _HadiSummaryModel(
      id: _idToString(json['id']),
      name: json['name'] as String,
      photoUrl: json['image_url'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$HadiSummaryModelToJson(_HadiSummaryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image_url': instance.photoUrl,
      'description': instance.description,
    };
