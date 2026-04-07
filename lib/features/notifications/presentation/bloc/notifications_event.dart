part of 'notifications_bloc.dart';

@freezed
sealed class NotificationsEvent with _$NotificationsEvent {
  const factory NotificationsEvent.load({String? userId}) = _Load;

  const factory NotificationsEvent.markAllRead({
    String? userId,
    @Default(<String>[]) List<String> notificationIds,
  }) = _MarkAllRead;
}
