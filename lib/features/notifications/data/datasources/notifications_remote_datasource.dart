import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/features/notifications/data/models/notification_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class NotificationsRemoteDatasource {
  Future<List<NotificationModel>> getNotifications();

  Future<Set<String>> getReadNotificationIds({required String userId});

  Future<void> markAllAsRead({
    required String userId,
    required List<String> notificationIds,
  });
}

@LazySingleton(as: NotificationsRemoteDatasource)
class NotificationsRemoteDatasourceImpl
    implements NotificationsRemoteDatasource {
  const NotificationsRemoteDatasourceImpl(this._supabase);

  final SupabaseClient _supabase;

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final data = await _supabase
          .from('developer_notifications')
          .select()
          .eq('is_active', true)
          .order('published_at', ascending: false);
      return data.map(NotificationModel.fromJson).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Set<String>> getReadNotificationIds({required String userId}) async {
    try {
      final data = await _supabase
          .from('user_notification_reads')
          .select('notification_id')
          .eq('user_id', userId);
      return data
          .map((r) => r['notification_id'] as String)
          .toSet();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> markAllAsRead({
    required String userId,
    required List<String> notificationIds,
  }) async {
    if (notificationIds.isEmpty) return;
    try {
      await _supabase.from('user_notification_reads').upsert(
            notificationIds
                .map(
                  (id) => {'user_id': userId, 'notification_id': id},
                )
                .toList(),
          );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
