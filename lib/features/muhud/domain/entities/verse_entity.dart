import 'package:freezed_annotation/freezed_annotation.dart';

part 'verse_entity.freezed.dart';

@freezed
abstract class VerseEntity with _$VerseEntity {
  const factory VerseEntity({
    required int id,
    required int chapterId,
    required int verseNumber,
    required String arabicText,
    required String transliteration,
  }) = _VerseEntity;
}
