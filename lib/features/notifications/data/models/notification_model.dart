import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ishari/features/notifications/domain/entities/notification_entity.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
abstract class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String title,
    required String body,
    required String type,
    @JsonKey(name: 'published_at') required DateTime publishedAt,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'action_url') String? actionUrl,
    String? content,
    @JsonKey(name: 'expires_at') DateTime? expiresAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}

extension NotificationModelX on NotificationModel {
  NotificationEntity toEntity({bool isRead = false}) => NotificationEntity(
        id: id,
        title: title,
        body: body,
        type: type,
        imageUrl: imageUrl,
        actionUrl: actionUrl,
        content: content,
        publishedAt: publishedAt,
        expiresAt: expiresAt,
        isRead: isRead,
      );
}
