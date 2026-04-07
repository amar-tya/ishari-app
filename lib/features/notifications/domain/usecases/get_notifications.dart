import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/notifications/domain/entities/notification_entity.dart';
import 'package:ishari/features/notifications/domain/repositories/notifications_repository.dart';

@injectable
class GetNotifications {
  const GetNotifications(this.repository);

  final NotificationsRepository repository;

  Future<Either<Failure, List<NotificationEntity>>> call({String? userId}) =>
      repository.getNotifications(userId: userId);
}
