import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmarked_verse_entity.freezed.dart';

@freezed
abstract class BookmarkedVerseEntity with _$BookmarkedVerseEntity {
  const factory BookmarkedVerseEntity({
    required int verseId,
    required int verseNumber,
    required String arabicText,
    required String transliteration,
    required int chapterId,
    required String chapterTitle,
    required String chapterCategory,
    required DateTime bookmarkedAt,
    String? note,
  }) = _BookmarkedVerseEntity;
}
