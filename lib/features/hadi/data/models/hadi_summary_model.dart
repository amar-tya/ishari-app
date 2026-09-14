import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ishari/features/hadi/domain/entities/hadi_summary_entity.dart';

part 'hadi_summary_model.freezed.dart';
part 'hadi_summary_model.g.dart';

String _idToString(dynamic v) => v.toString();

@freezed
abstract class HadiSummaryModel with _$HadiSummaryModel {
  const factory HadiSummaryModel({
    @JsonKey(fromJson: _idToString) required String id,
    required String name,
    @JsonKey(name: 'image_url') String? photoUrl,
    String? description,
  }) = _HadiSummaryModel;

  const HadiSummaryModel._();

  factory HadiSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$HadiSummaryModelFromJson(json);

  HadiSummaryEntity toEntity() => HadiSummaryEntity(
    id: id,
    name: name,
    photoUrl: photoUrl,
    description: description,
  );
}
