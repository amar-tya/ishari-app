import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

/// The parts of [FirebaseMessaging] the app uses, so they can be faked.
abstract class PushMessagingClient {
  /// Messages that arrive while the app is in the foreground.
  Stream<RemoteMessage> get onMessage;

  /// Taps on a notification while the app is in the background.
  Stream<RemoteMessage> get onMessageOpenedApp;

  /// The notification whose tap launched the app, if any.
  Future<RemoteMessage?> getInitialMessage();

  Future<void> subscribeToTopic(String topic);

  /// Current permission. Never opens a system dialog.
  ///
  /// Android only ever answers `authorized` or `denied`, so there "never
  /// asked" and "refused" look the same.
  Future<AuthorizationStatus> permissionStatus();

  /// Opens the system permission dialog if the platform still allows it.
  Future<AuthorizationStatus> requestPermission();
}

@LazySingleton(as: PushMessagingClient)
class FirebasePushMessagingClient implements PushMessagingClient {
  // Resolved on use: Firebase is not initialized yet when tests, or the
  // dependency graph, merely construct this.
  FirebaseMessaging get _messaging => FirebaseMessaging.instance;

  @override
  Stream<RemoteMessage> get onMessage => FirebaseMessaging.onMessage;

  @override
  Stream<RemoteMessage> get onMessageOpenedApp =>
      FirebaseMessaging.onMessageOpenedApp;

  @override
  Future<RemoteMessage?> getInitialMessage() => _messaging.getInitialMessage();

  @override
  Future<void> subscribeToTopic(String topic) =>
      _messaging.subscribeToTopic(topic);

  @override
  Future<AuthorizationStatus> permissionStatus() async =>
      (await _messaging.getNotificationSettings()).authorizationStatus;

  @override
  Future<AuthorizationStatus> requestPermission() async =>
      (await _messaging.requestPermission()).authorizationStatus;
}
