import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/notifications/domain/repositories/notifications_repository.dart';

@injectable
class MarkAllNotificationsRead {
  const MarkAllNotificationsRead(this.repository);

  final NotificationsRepository repository;

  Future<Either<Failure, Unit>> call({
    String? userId,
    List<String> notificationIds = const [],
  }) =>
      userId != null
          ? repository.markAllAsReadForUser(
              userId: userId,
              notificationIds: notificationIds,
            )
          : repository.updateGuestLastSeen();
}
