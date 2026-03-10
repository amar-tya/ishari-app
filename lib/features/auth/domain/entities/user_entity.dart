import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

/// Pure domain entity — no framework dependencies, no JSON serialization.
///
/// Lives in the innermost Clean Architecture ring (Entities).
@freezed
abstract class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String email,
    String? displayName,
    String? avatarUrl,
  }) = _UserEntity;
}
