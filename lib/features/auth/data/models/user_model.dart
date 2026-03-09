import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ishari/features/auth/domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Data Transfer Object (DTO) for [UserEntity].
///
/// Serializes to/from JSON for secure-storage caching.
/// The domain layer never imports this model.
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    String? displayName,
    String? avatarUrl,
  }) = _UserModel;

  const UserModel._();

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Build from a Supabase User JSON map (maps snake_case → camelCase).
  factory UserModel.fromSupabaseUser(Map<String, dynamic> supabaseUser) {
    final meta = supabaseUser['user_metadata'] as Map<String, dynamic>? ?? {};
    return UserModel(
      id: supabaseUser['id'] as String,
      email: supabaseUser['email'] as String,
      displayName: meta['full_name'] as String? ?? meta['name'] as String?,
      avatarUrl: meta['avatar_url'] as String?,
    );
  }

  /// Convert to domain entity.
  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        displayName: displayName,
        avatarUrl: avatarUrl,
      );
}
