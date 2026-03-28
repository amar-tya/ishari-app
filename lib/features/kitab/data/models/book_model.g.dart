// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookModel _$BookModelFromJson(Map<String, dynamic> json) => _BookModel(
  id: _idToString(json['id']),
  title: json['title'] as String,
  author: json['author'] as String?,
  description: json['description'] as String?,
  publishedYear: (json['published_year'] as num?)?.toInt(),
  coverImageUrl: json['cover_image_url'] as String?,
);

Map<String, dynamic> _$BookModelToJson(_BookModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'author': instance.author,
      'description': instance.description,
      'published_year': instance.publishedYear,
      'cover_image_url': instance.coverImageUrl,
    };
