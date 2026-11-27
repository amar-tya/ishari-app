import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/router/route_guards.dart';
import 'package:ishari/features/audio/presentation/pages/audio_list_page.dart';
import 'package:ishari/features/push_notification/data/services/local_notifications_client.dart';
import 'package:ishari/features/push_notification/data/services/push_error_report.dart';
import 'package:ishari/features/push_notification/data/services/push_messaging_client.dart';
import 'package:ishari/features/push_notification/presentation/notification_tap_navigator.dart';
import 'package:ishari/firebase_options.dart';

const _newAudioTopic = 'new_audio';

/// Route to open for a tapped "audio baru" notification, or `null` when the
/// payload carries neither id.
///
/// verse_media notif carries `verseId` (per-verse audio → open the verse
/// in ChapterReaderPage). chapter_media notif never carries `verseId`
/// (full-chapter recording, not tied to a verse) → open AudioListPage
/// instead, since ChapterReaderPage would be the wrong context for it.
///
/// The reader also needs a usable `chapterId`; a verse payload without one
/// falls back to AudioListPage
/// (see docs/fix-fcm-chapter-media-audio-route/spec.md).
@visibleForTesting
String? fcmTargetPath(String? chapterId, {String? verseId}) {
  final hasVerse = verseId != null && verseId.isNotEmpty;
  final hasChapter = chapterId != null && chapterId.isNotEmpty;
  if (!hasVerse && !hasChapter) return null;

  final chapter = parseRouteId(chapterId);
  if (!hasVerse || chapter == null) return AudioListPage.routePath;
  return '/chapter/$chapter?verseId=${Uri.encodeQueryComponent(verseId)}';
}

/// Wraps FCM and local notifications to deliver "audio baru" push
/// notifications (topic-based FCM — see AMA-60 PRD for why topics were chosen
/// over per-device-token sends).
///
/// Asking for the notification permission is not done here; see
/// `NotificationPermissionPrompter`.
@lazySingleton
class FcmService {
  // Called only by the generated DI config, which analysis does not see.
  // ignore: unreachable_from_main
  FcmService(this._messaging, this._localNotifications, this._navigator);

  final PushMessagingClient _messaging;
  final LocalNotificationsClient _localNotifications;
  final NotificationTapNavigator _navigator;

  @visibleForTesting
  void Function(Object error, StackTrace stack) reportError = reportPushError;

  /// Call once per app launch. Every step runs on its own, so that one failing
  /// does not cost the others, and nothing here needs the permission.
  Future<void> init() async {
    await _step(_localNotifications.createChannel);
    await _step(
      () => _localNotifications.initialize(onTap: _onLocalNotificationTap),
    );
    await _step(() async {
      _messaging.onMessage.listen(_onForegroundMessage);
    });
    await _step(() async {
      _messaging.onMessageOpenedApp.listen(_onNotificationTap);
    });
    // The tap that launched a terminated app, by kind of notification.
    await _step(() async {
      final message = await _messaging.getInitialMessage();
      if (message != null) _onNotificationTap(message);
    });
    await _step(() async {
      _onLocalNotificationTap(await _localNotifications.launchPayload());
    });
    // Last: offline it can stay pending for a long time.
    await _step(() => _messaging.subscribeToTopic(_newAudioTopic));
  }

  Future<void> _step(Future<void> Function() step) async {
    try {
      await step();
    } on Object catch (error, stack) {
      reportError(error, stack);
    }
  }

  void _onForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    unawaited(
      _step(
        () => _localNotifications.show(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          payload: jsonEncode({
            'chapterId': message.data['chapterId'],
            'verseId': message.data['verseId'],
          }),
        ),
      ),
    );
  }

  void _onNotificationTap(RemoteMessage message) => _openTarget(message.data);

  void _onLocalNotificationTap(String? payload) {
    if (payload == null || payload.isEmpty) return;
    final Object? data;
    try {
      data = jsonDecode(payload);
    } on FormatException {
      return;
    }
    if (data is Map<String, dynamic>) _openTarget(data);
  }

  void _openTarget(Map<String, dynamic> data) {
    String? read(String key) {
      final value = data[key];
      return value is String ? value : null;
    }

    final path = fcmTargetPath(read('chapterId'), verseId: read('verseId'));
    if (path != null) _navigator.open(path);
  }
}

/// Must stay top-level (outside any class) per FCM requirements — it runs in
/// a separate isolate when a data message arrives while the app is
/// backgrounded or terminated.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
