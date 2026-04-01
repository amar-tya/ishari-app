import 'package:flutter/rendering.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ishari/features/muhud/domain/entities/verse_entity.dart';

part 'verse_model.freezed.dart';
part 'verse_model.g.dart';

String _idToString(dynamic v) => v.toString();

@freezed
abstract class VerseModel with _$VerseModel {
  const factory VerseModel({
    @JsonKey(fromJson: _idToString) required String id,
    @JsonKey(name: 'chapter_id', fromJson: _idToString)
    required String chapterId,
    @JsonKey(name: 'verse_number', fromJson: _idToString)
    required String verseNumber,
    @JsonKey(name: 'arabic_text') required String arabicText,
    required String transliteration,
  }) = _VerseModel;

  const VerseModel._();

  factory VerseModel.fromJson(Map<String, dynamic> json) =>
      _$VerseModelFromJson(json);

  VerseEntity toEntity() {
    try {
      debugPrint(
        '[VerseModel] Converting to entity - id: $id, chapterId: $chapterId, verseNumber: $verseNumber',
      );
      return VerseEntity(
        id: int.parse(id),
        chapterId: int.parse(chapterId),
        verseNumber: int.parse(verseNumber),
        arabicText: arabicText,
        transliteration: transliteration,
      );
    } catch (e) {
      debugPrint('[VerseModel] ERROR in toEntity: $e');
      debugPrint('[VerseModel] id=$id (type: ${id.runtimeType})');
      debugPrint(
        '[VerseModel] chapterId=$chapterId (type: ${chapterId.runtimeType})',
      );
      debugPrint(
        '[VerseModel] verseNumber=$verseNumber (type: ${verseNumber.runtimeType})',
      );
      rethrow;
    }
  }
}
