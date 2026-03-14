import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter_entity.freezed.dart';

@freezed
abstract class ChapterEntity with _$ChapterEntity {
  const factory ChapterEntity({
    required String id,
    required String title,
    required String category,
    required String description,
    @Default(0) int verseCount,
    int? number,
  }) = _ChapterEntity;
}
