import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';

part 'chapter_model.freezed.dart';
part 'chapter_model.g.dart';

String _idToString(dynamic v) => v.toString();

@freezed
abstract class ChapterModel with _$ChapterModel {
  const factory ChapterModel({
    @JsonKey(fromJson: _idToString) required String id,
    required String title,
    required String category,
    @JsonKey(name: 'total_verses') @Default(0) int verseCount,
    @JsonKey(name: 'chapter_number') int? number,
  }) = _ChapterModel;

  const ChapterModel._();

  factory ChapterModel.fromJson(Map<String, dynamic> json) =>
      _$ChapterModelFromJson(json);

  ChapterEntity toEntity() => ChapterEntity(
        id: id,
        title: title,
        category: category,
        verseCount: verseCount,
        number: number,
      );
}
