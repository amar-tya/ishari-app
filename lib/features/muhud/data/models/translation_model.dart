import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ishari/features/muhud/domain/entities/translation_entity.dart';

part 'translation_model.freezed.dart';
part 'translation_model.g.dart';

String _idToString(dynamic v) => v.toString();

@freezed
abstract class TranslationModel with _$TranslationModel {
  const factory TranslationModel({
    @JsonKey(fromJson: _idToString) required String id,
    @JsonKey(name: 'verse_id', fromJson: _idToString) required String verseId,
    @JsonKey(name: 'language_code') required String languageCode,
    @JsonKey(name: 'translation_text') required String translationText,
  }) = _TranslationModel;

  const TranslationModel._();

  factory TranslationModel.fromJson(Map<String, dynamic> json) =>
      _$TranslationModelFromJson(json);

  TranslationEntity toEntity() => TranslationEntity(
    id: int.parse(id),
    verseId: int.parse(verseId),
    languageCode: languageCode,
    translationText: translationText,
  );
}
