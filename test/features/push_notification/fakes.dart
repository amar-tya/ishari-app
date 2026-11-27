import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ishari/features/push_notification/data/services/push_messaging_client.dart';

class FakePushMessagingClient implements PushMessagingClient {
  AuthorizationStatus status = AuthorizationStatus.denied;

  /// What the system dialog answers.
  AuthorizationStatus requestAnswer = AuthorizationStatus.authorized;

  int statusReads = 0;
  int permissionRequests = 0;
  final subscribedTopics = <String>[];

  RemoteMessage? initialMessage;
  Future<void> Function() onSubscribe = () async {};
  Future<RemoteMessage?> Function()? onGetInitialMessage;

  final foreground = StreamController<RemoteMessage>.broadcast(sync: true);
  final opened = StreamController<RemoteMessage>.broadcast(sync: true);

  @override
  Stream<RemoteMessage> get onMessage => foreground.stream;

  @override
  Stream<RemoteMessage> get onMessageOpenedApp => opened.stream;

  @override
  Future<RemoteMessage?> getInitialMessage() =>
      onGetInitialMessage?.call() ?? Future.value(initialMessage);

  @override
  Future<void> subscribeToTopic(String topic) {
    subscribedTopics.add(topic);
    return onSubscribe();
  }

  @override
  Future<AuthorizationStatus> permissionStatus() async {
    statusReads++;
    return status;
  }

  @override
  Future<AuthorizationStatus> requestPermission() async {
    permissionRequests++;
    return requestAnswer;
  }
}
