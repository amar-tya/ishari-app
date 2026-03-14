import 'package:flutter/rendering.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ishari/features/muhud/data/models/hadi_media_model.dart';
import 'package:ishari/features/muhud/domain/entities/verse_media_entity.dart';
import 'package:ishari/features/muhud/domain/entities/verse_media_type.dart';

part 'verse_media_model.freezed.dart';
part 'verse_media_model.g.dart';

String _idToString(dynamic v) => v.toString();
String _verseIdToString(dynamic v) => v.toString();
String _typeToString(dynamic v) => v.toString();

@freezed
abstract class VerseMediaModel with _$VerseMediaModel {
  const factory VerseMediaModel({
    @JsonKey(fromJson: _idToString) required String id,
    @JsonKey(name: 'verse_id', fromJson: _verseIdToString) required String verseId,
    required HadiMediaModel hadi,
    @JsonKey(name: 'media_url') required String mediaUrl,
    @JsonKey(fromJson: _idToString) required String duration,
    @JsonKey(fromJson: _typeToString) required String type,
  }) = _VerseMediaModel;

  const VerseMediaModel._();

  factory VerseMediaModel.fromJson(Map<String, dynamic> json) =>
      _$VerseMediaModelFromJson(json);

  VerseMediaEntity toEntity() {
    try {
      debugPrint('[VerseMediaModel] Converting to entity - id: $id, verseId: $verseId, duration: $duration, type: $type');

      // Handle null or "null" duration by defaulting to 0
      int parsedDuration = 0;
      if (duration != null && duration != 'null' && duration.toString().isNotEmpty) {
        parsedDuration = int.parse(duration);
      }

      return VerseMediaEntity(
        id: int.parse(id),
        verseId: int.parse(verseId),
        hadi: hadi.toEntity(),
        mediaUrl: mediaUrl,
        duration: parsedDuration,
        type: VerseMediaTypeExt.fromString(type),
      );
    } catch (e) {
      debugPrint('[VerseMediaModel] ERROR in toEntity: $e');
      debugPrint('[VerseMediaModel] id=$id (type: ${id.runtimeType})');
      debugPrint('[VerseMediaModel] verseId=$verseId (type: ${verseId.runtimeType})');
      debugPrint('[VerseMediaModel] duration=$duration (type: ${duration.runtimeType})');
      debugPrint('[VerseMediaModel] type=$type (type: ${type.runtimeType})');
      rethrow;
    }
  }
}
