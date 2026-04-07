import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ishari/features/muhud/data/models/translation_model.dart';
import 'package:ishari/features/muhud/data/models/verse_media_model.dart';
import 'package:ishari/features/muhud/data/models/verse_model.dart';
import 'package:ishari/features/muhud/domain/entities/verse_with_details_entity.dart';

part 'verse_with_details_model.freezed.dart';
part 'verse_with_details_model.g.dart';

@freezed
abstract class VerseWithDetailsModel with _$VerseWithDetailsModel {
  const factory VerseWithDetailsModel({
    required VerseModel verse,
    @Default([]) List<TranslationModel> translations,
    @Default([]) List<VerseMediaModel> mediaList,
  }) = _VerseWithDetailsModel;

  const VerseWithDetailsModel._();

  factory VerseWithDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$VerseWithDetailsModelFromJson(json);

  VerseWithDetailsEntity toEntity() => VerseWithDetailsEntity(
    verse: verse.toEntity(),
    translations: translations.map((t) => t.toEntity()).toList(),
    mediaList: mediaList.map((m) => m.toEntity()).toList(),
  );
}
