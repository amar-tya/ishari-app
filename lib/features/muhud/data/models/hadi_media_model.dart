import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ishari/features/muhud/domain/entities/hadi_media_entity.dart';

part 'hadi_media_model.freezed.dart';
part 'hadi_media_model.g.dart';

String _idToString(dynamic v) => v.toString();

@freezed
abstract class HadiMediaModel with _$HadiMediaModel {
  const factory HadiMediaModel({
    @JsonKey(fromJson: _idToString) required String id,
    required String name,
    @JsonKey(name: 'image_url') String? photoUrl,
  }) = _HadiMediaModel;

  const HadiMediaModel._();

  factory HadiMediaModel.fromJson(Map<String, dynamic> json) =>
      _$HadiMediaModelFromJson(json);

  HadiMediaEntity toEntity() => HadiMediaEntity(
    id: id,
    name: name,
    photoUrl: photoUrl,
  );
}
