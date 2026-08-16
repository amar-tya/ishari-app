import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/router/app_router.dart';
import 'package:ishari/firebase_options.dart';

const _newAudioTopic = 'new_audio';
const _channelId = 'new_audio_channel';
const _channelName = 'Audio Baru';
const _channelDescription = 'Notifikasi saat ada audio Hadi baru';

/// Wraps [FirebaseMessaging] + [FlutterLocalNotificationsPlugin] to deliver
/// "audio baru" push notifications (topic-based FCM — see AMA-60 PRD for
/// why topics were chosen over per-device-token sends).
@lazySingleton
class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _messaging.requestPermission();
    await _initLocalNotifications();
    await _messaging.subscribeToTopic(_newAudioTopic);

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_onNotificationTap);

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) _onNotificationTap(initialMessage);
  }

  Future<void> _initLocalNotifications() async {
    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@drawable/ic_stat_notify'),
    );
    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload == null || payload.isEmpty) return;
        final data = jsonDecode(payload) as Map<String, dynamic>;
        _navigateToChapter(
          data['chapterId'] as String?,
          verseId: data['verseId'] as String?,
        );
      },
    );
  }

  void _onForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    unawaited(
      _localNotifications.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(_channelId, _channelName),
        ),
        payload: jsonEncode({
          'chapterId': message.data['chapterId'],
          'verseId': message.data['verseId'],
        }),
      ),
    );
  }

  void _onNotificationTap(RemoteMessage message) {
    _navigateToChapter(
      message.data['chapterId'] as String?,
      verseId: message.data['verseId'] as String?,
    );
  }

  void _navigateToChapter(String? chapterId, {String? verseId}) {
    if (chapterId == null || chapterId.isEmpty) return;

    void attempt() {
      final context = rootNavigatorKey.currentContext;
      if (context != null && context.mounted) {
        final path = verseId != null && verseId.isNotEmpty
            ? '/chapter/$chapterId?verseId=$verseId'
            : '/chapter/$chapterId';
        GoRouter.of(context).go(path);
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) => attempt());
      }
    }

    attempt();
  }
}

/// Must stay top-level (outside any class) per FCM requirements — it runs in
/// a separate isolate when a data message arrives while the app is
/// backgrounded or terminated.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
