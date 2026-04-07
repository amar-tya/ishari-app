import 'package:freezed_annotation/freezed_annotation.dart';

part 'tatanan_verse_entity.freezed.dart';

@freezed
abstract class TatananVerseEntity with _$TatananVerseEntity {
  const factory TatananVerseEntity({
    required String id,
    required String tatananId,
    required int verseId,
    required int position,
    required int verseNumber,
    required String arabicText,
    required String transliteration,
  }) = _TatananVerseEntity;
}
