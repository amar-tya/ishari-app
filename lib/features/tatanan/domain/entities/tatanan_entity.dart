import 'package:freezed_annotation/freezed_annotation.dart';

part 'tatanan_entity.freezed.dart';

@freezed
abstract class TatananEntity with _$TatananEntity {
  const factory TatananEntity({
    required String id,
    required String userId,
    required int chapterId,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? description,
    @Default(0) int verseCount,
    @Default('') String chapterTitle,
    @Default('') String category,
    int? chapterNumber,
  }) = _TatananEntity;
}
