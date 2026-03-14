import 'package:freezed_annotation/freezed_annotation.dart';

part 'hadi_media_entity.freezed.dart';

@freezed
abstract class HadiMediaEntity with _$HadiMediaEntity {
  const factory HadiMediaEntity({
    required String id,
    required String name,
    String? photoUrl,
  }) = _HadiMediaEntity;
}
