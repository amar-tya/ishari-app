import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/features/notifications/domain/entities/notification_entity.dart';
import 'package:ishari/features/notifications/domain/usecases/get_notifications.dart';
import 'package:ishari/features/notifications/domain/usecases/mark_all_notifications_read.dart';

part 'notifications_bloc.freezed.dart';
part 'notifications_event.dart';
part 'notifications_state.dart';

@lazySingleton
class NotificationsBloc
    extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc(
    this._getNotifications,
    this._markAllNotificationsRead,
  ) : super(const NotificationsState.initial()) {
    on<_Load>(_onLoad);
    on<_MarkAllRead>(_onMarkAllRead);
  }

  final GetNotifications _getNotifications;
  final MarkAllNotificationsRead _markAllNotificationsRead;

  Future<void> _onLoad(_Load event, Emitter<NotificationsState> emit) async {
    emit(const NotificationsState.loading());
    final result = await _getNotifications(userId: event.userId);
    result.fold(
      (failure) => emit(NotificationsState.error(message: failure.message)),
      (notifications) {
        final unreadCount = notifications.where((n) => !n.isRead).length;
        emit(
          NotificationsState.loaded(
            notifications: notifications,
            unreadCount: unreadCount,
          ),
        );
      },
    );
  }

  Future<void> _onMarkAllRead(
    _MarkAllRead event,
    Emitter<NotificationsState> emit,
  ) async {
    await _markAllNotificationsRead(
      userId: event.userId,
      notificationIds: event.notificationIds,
    );
    state.mapOrNull(
      loaded: (s) {
        final idsToMark = event.notificationIds.toSet();
        final updated = s.notifications.map((n) {
          if (idsToMark.isEmpty || idsToMark.contains(n.id)) {
            return n.copyWith(isRead: true);
          }
          return n;
        }).toList();
        final unreadCount = updated.where((n) => !n.isRead).length;
        emit(s.copyWith(notifications: updated, unreadCount: unreadCount));
      },
    );
  }
}
