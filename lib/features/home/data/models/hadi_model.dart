import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ishari/features/home/domain/entities/hadi_entity.dart';

part 'hadi_model.freezed.dart';
part 'hadi_model.g.dart';

String _idToString(dynamic v) => v.toString();

@freezed
abstract class HadiModel with _$HadiModel {
  const factory HadiModel({
    @JsonKey(fromJson: _idToString) required String id,
    required String name,
    @JsonKey(name: 'image_url') String? photoUrl,
  }) = _HadiModel;

  const HadiModel._();

  factory HadiModel.fromJson(Map<String, dynamic> json) =>
      _$HadiModelFromJson(json);

  HadiEntity toEntity() => HadiEntity(
    id: id,
    name: name,
    photoUrl: photoUrl,
  );
}
