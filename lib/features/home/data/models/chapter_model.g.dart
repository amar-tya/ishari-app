// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChapterModel _$ChapterModelFromJson(Map<String, dynamic> json) =>
    _ChapterModel(
      id: _idToString(json['id']),
      title: json['title'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      verseCount: (json['total_verses'] as num?)?.toInt() ?? 0,
      number: (json['chapter_number'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ChapterModelToJson(_ChapterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': instance.category,
      'description': instance.description,
      'total_verses': instance.verseCount,
      'chapter_number': instance.number,
    };
