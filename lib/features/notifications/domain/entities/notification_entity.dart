import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_entity.freezed.dart';

@freezed
abstract class NotificationEntity with _$NotificationEntity {
  const factory NotificationEntity({
    required String id,
    required String title,
    required String body,
    required String type, // 'info' | 'update' | 'warning' | 'promo'
    String? imageUrl,
    String? actionUrl,
    required DateTime publishedAt,
    DateTime? expiresAt,
    @Default(false) bool isRead,
  }) = _NotificationEntity;
}
