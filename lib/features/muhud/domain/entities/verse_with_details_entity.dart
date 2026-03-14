import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ishari/features/muhud/domain/entities/translation_entity.dart';
import 'package:ishari/features/muhud/domain/entities/verse_entity.dart';
import 'package:ishari/features/muhud/domain/entities/verse_media_entity.dart';

part 'verse_with_details_entity.freezed.dart';

@freezed
abstract class VerseWithDetailsEntity with _$VerseWithDetailsEntity {
  const factory VerseWithDetailsEntity({
    required VerseEntity verse,
    required List<TranslationEntity> translations,
    required List<VerseMediaEntity> mediaList,
  }) = _VerseWithDetailsEntity;
}
