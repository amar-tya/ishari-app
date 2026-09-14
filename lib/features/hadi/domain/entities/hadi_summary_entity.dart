import 'package:freezed_annotation/freezed_annotation.dart';

part 'hadi_summary_entity.freezed.dart';

@freezed
abstract class HadiSummaryEntity with _$HadiSummaryEntity {
  const factory HadiSummaryEntity({
    required String id,
    required String name,
    String? photoUrl,
    String? description,
  }) = _HadiSummaryEntity;
}
