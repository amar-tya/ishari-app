import 'package:freezed_annotation/freezed_annotation.dart';

part 'hadi_entity.freezed.dart';

@freezed
abstract class HadiEntity with _$HadiEntity {
  const factory HadiEntity({
    required String id,
    required String name,
    String? photoUrl,
  }) = _HadiEntity;
}
