import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ishari/features/muhud/domain/entities/hadi_media_entity.dart';
import 'package:ishari/features/muhud/domain/entities/verse_media_type.dart';

part 'verse_media_entity.freezed.dart';

@freezed
abstract class VerseMediaEntity with _$VerseMediaEntity {
  const factory VerseMediaEntity({
    required int id,
    required int verseId,
    required HadiMediaEntity hadi,
    required String mediaUrl,
    required int duration,
    required VerseMediaType type,
  }) = _VerseMediaEntity;
}
