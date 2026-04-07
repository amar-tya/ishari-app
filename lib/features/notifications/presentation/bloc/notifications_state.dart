part of 'notifications_bloc.dart';

@freezed
sealed class NotificationsState with _$NotificationsState {
  const factory NotificationsState.initial() = _Initial;

  const factory NotificationsState.loading() = _Loading;

  const factory NotificationsState.loaded({
    required List<NotificationEntity> notifications,
    @Default(0) int unreadCount,
  }) = _Loaded;

  const factory NotificationsState.error({required String message}) = _Error;
}
