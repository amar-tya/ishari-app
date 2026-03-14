// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verse_with_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VerseWithDetailsModel _$VerseWithDetailsModelFromJson(
  Map<String, dynamic> json,
) => _VerseWithDetailsModel(
  verse: VerseModel.fromJson(json['verse'] as Map<String, dynamic>),
  translations:
      (json['translations'] as List<dynamic>?)
          ?.map((e) => TranslationModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  mediaList:
      (json['mediaList'] as List<dynamic>?)
          ?.map((e) => VerseMediaModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$VerseWithDetailsModelToJson(
  _VerseWithDetailsModel instance,
) => <String, dynamic>{
  'verse': instance.verse,
  'translations': instance.translations,
  'mediaList': instance.mediaList,
};
