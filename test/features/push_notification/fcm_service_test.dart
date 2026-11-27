import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishari/features/push_notification/data/services/fcm_service.dart';
import 'package:ishari/features/push_notification/data/services/local_notifications_client.dart';
import 'package:ishari/features/push_notification/presentation/notification_tap_navigator.dart';

import 'fakes.dart';

class _FakeLocalNotifications implements LocalNotificationsClient {
  Object? channelError;
  Object? initializeError;
  String? launchedWith;

  var _channelCreated = false;
  void Function(String? payload)? onTap;
  final shown = <({String? title, String? body, String payload})>[];

  bool get channelCreated => _channelCreated;

  @override
  Future<void> createChannel() async {
    if (channelError case final error?) throw error;
    _channelCreated = true;
  }

  @override
  Future<void> initialize({
    required void Function(String? payload) onTap,
  }) async {
    if (initializeError case final error?) throw error;
    this.onTap = onTap;
  }

  @override
  Future<String?> launchPayload() async => launchedWith;

  @override
  Future<void> show({
    required int id,
    required String payload,
    String? title,
    String? body,
  }) async => shown.add((title: title, body: body, payload: payload));
}

class _RecordingNavigator extends Fake implements NotificationTapNavigator {
  final opened = <String>[];

  @override
  void open(String path) => opened.add(path);
}

const _verseData = {'chapterId': '3', 'verseId': '9'};
const _versePath = '/chapter/3?verseId=9';

void main() {
  late FakePushMessagingClient messaging;
  late _FakeLocalNotifications local;
  late _RecordingNavigator navigator;
  late List<Object> reported;
  late FcmService service;

  setUp(() {
    messaging = FakePushMessagingClient();
    local = _FakeLocalNotifications();
    navigator = _RecordingNavigator();
    reported = [];
    service = FcmService(messaging, local, navigator)
      ..reportError = (error, _) => reported.add(error);
  });

  group('init', () {
    test('never asks for the notification permission', () async {
      await service.init();

      expect(messaging.permissionRequests, 0);
    });

    test('subscribes to the topic while permission is denied', () async {
      messaging.status = AuthorizationStatus.denied;

      await service.init();

      expect(messaging.subscribedTopics, ['new_audio']);
    });

    test('handles taps while the subscription is still pending', () async {
      messaging
        ..onSubscribe = (() => Completer<void>().future)
        ..initialMessage = const RemoteMessage(data: _verseData);

      unawaited(service.init());
      await pumpEventQueue();
      messaging.opened.add(const RemoteMessage(data: {'chapterId': '4'}));

      expect(navigator.opened, [_versePath, '/audio']);
      expect(messaging.subscribedTopics, ['new_audio']);
    });

    test('a failing local setup does not skip the other steps', () async {
      local
        ..channelError = StateError('channel')
        ..initializeError = StateError('initialize');
      messaging.initialMessage = const RemoteMessage(data: _verseData);

      await service.init();
      messaging.opened.add(const RemoteMessage(data: {'chapterId': '4'}));

      expect(navigator.opened, [_versePath, '/audio']);
      expect(messaging.subscribedTopics, ['new_audio']);
      expect(reported, hasLength(2));
    });

    test('a failing initial message does not skip the subscription', () async {
      messaging.onGetInitialMessage = () => throw StateError('initial');

      await service.init();

      expect(messaging.subscribedTopics, ['new_audio']);
      expect(reported.single, isStateError);
    });

    test('a failing subscription is reported, not thrown', () async {
      messaging.onSubscribe = () async => throw StateError('offline');

      await service.init();

      expect(reported.single, isStateError);
    });

    test('creates the notification channel', () async {
      await service.init();

      expect(local.channelCreated, isTrue);
    });
  });

  group('taps', () {
    test('a foreground message is shown, and tapping it opens the '
        'target', () async {
      await service.init();

      messaging.foreground.add(
        const RemoteMessage(
          notification: RemoteNotification(title: 'Audio', body: 'Baru'),
          data: _verseData,
        ),
      );
      final shown = local.shown.single;
      expect((shown.title, shown.body), ('Audio', 'Baru'));
      expect(navigator.opened, isEmpty);

      local.onTap!(shown.payload);

      expect(navigator.opened, [_versePath]);
    });

    test('the local notification that launched the app opens its '
        'target', () async {
      local.launchedWith = jsonEncode(_verseData);

      await service.init();

      expect(navigator.opened, [_versePath]);
    });

    test('unusable local payloads are ignored', () async {
      await service.init();

      for (final payload in [
        null,
        '',
        'not json',
        '[1]',
        '{}',
        '{"chapterId": 3, "verseId": 9}',
      ]) {
        local.onTap!(payload);
      }

      expect(navigator.opened, isEmpty);
      expect(reported, isEmpty);
    });

    test('a background tap without ids opens nothing', () async {
      await service.init();

      messaging.opened.add(const RemoteMessage());

      expect(navigator.opened, isEmpty);
    });
  });

  test('Apple settings never ask for permission at initialization', () {
    final ios = localNotificationInitSettings.iOS!;

    expect(ios.requestAlertPermission, isFalse);
    expect(ios.requestBadgePermission, isFalse);
    expect(ios.requestSoundPermission, isFalse);
    expect(ios.requestProvisionalPermission, isFalse);
    expect(ios.requestCriticalPermission, isFalse);
    expect(localNotificationInitSettings.macOS, same(ios));
  });
}
