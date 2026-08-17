// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookPageModel _$BookPageModelFromJson(Map<String, dynamic> json) =>
    _BookPageModel(
      id: (json['id'] as num).toInt(),
      bookId: (json['book_id'] as num).toInt(),
      pageNumber: (json['page_number'] as num).toInt(),
      imageUrl: json['image_url'] as String,
      chapterId: (json['chapter_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BookPageModelToJson(_BookPageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'book_id': instance.bookId,
      'page_number': instance.pageNumber,
      'image_url': instance.imageUrl,
      'chapter_id': instance.chapterId,
    };
