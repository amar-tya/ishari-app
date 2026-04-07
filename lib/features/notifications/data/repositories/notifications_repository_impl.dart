import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/network/network_info.dart';
import 'package:ishari/features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'package:ishari/features/notifications/data/models/notification_model.dart';
import 'package:ishari/features/notifications/domain/entities/notification_entity.dart';
import 'package:ishari/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: NotificationsRepository)
class NotificationsRepositoryImpl implements NotificationsRepository {
  const NotificationsRepositoryImpl(
    this._remote,
    this._networkInfo,
    this._prefs,
  );

  final NotificationsRemoteDatasource _remote;
  final NetworkInfo _networkInfo;
  final SharedPreferences _prefs;

  static const _guestLastSeenKey = 'notifications_last_seen_at';

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    String? userId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return left(const NetworkFailure());
    }
    try {
      final models = await _remote.getNotifications();

      if (userId != null) {
        final readIds =
            await _remote.getReadNotificationIds(userId: userId);
        return right(
          models
              .map((m) => m.toEntity(isRead: readIds.contains(m.id)))
              .toList(),
        );
      } else {
        // Guest: use SharedPreferences timestamp as read marker
        final lastSeenStr = _prefs.getString(_guestLastSeenKey);
        final lastSeen =
            lastSeenStr != null ? DateTime.tryParse(lastSeenStr) : null;
        return right(
          models
              .map(
                (m) => m.toEntity(
                  isRead: lastSeen != null &&
                      !m.publishedAt.isAfter(lastSeen),
                ),
              )
              .toList(),
        );
      }
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAllAsReadForUser({
    required String userId,
    required List<String> notificationIds,
  }) async {
    if (!await _networkInfo.isConnected) {
      return left(const NetworkFailure());
    }
    try {
      await _remote.markAllAsRead(
        userId: userId,
        notificationIds: notificationIds,
      );
      return right(unit);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateGuestLastSeen() async {
    try {
      await _prefs.setString(
        _guestLastSeenKey,
        DateTime.now().toIso8601String(),
      );
      return right(unit);
    } on Exception catch (_) {
      return left(const CacheFailure());
    }
  }
}
