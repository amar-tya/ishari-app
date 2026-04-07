import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/notifications/domain/entities/notification_entity.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    String? userId,
  });

  Future<Either<Failure, Unit>> markAllAsReadForUser({
    required String userId,
    required List<String> notificationIds,
  });

  Future<Either<Failure, Unit>> updateGuestLastSeen();
}
