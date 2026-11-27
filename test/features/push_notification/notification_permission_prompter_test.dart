import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishari/features/push_notification/data/services/notification_permission_prompter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fakes.dart';

void main() {
  late FakePushMessagingClient messaging;
  late SharedPreferences prefs;
  late DateTime now;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    messaging = FakePushMessagingClient();
    now = DateTime(2026, 11, 27, 10);
  });

  tearDown(() => debugDefaultTargetPlatformOverride = null);

  /// A new instance stands for a new app launch.
  NotificationPermissionPrompter launch() =>
      NotificationPermissionPrompter(messaging, prefs)..clock = () => now;

  group('permission status', () {
    final cases = {
      (TargetPlatform.android, AuthorizationStatus.denied): true,
      (TargetPlatform.android, AuthorizationStatus.authorized): false,
      (TargetPlatform.iOS, AuthorizationStatus.notDetermined): true,
      (TargetPlatform.iOS, AuthorizationStatus.denied): false,
      (TargetPlatform.iOS, AuthorizationStatus.authorized): false,
      (TargetPlatform.iOS, AuthorizationStatus.provisional): false,
    };

    for (final MapEntry(key: (platform, status), value: expected)
        in cases.entries) {
      test('${platform.name} ${status.name}: prompt is $expected', () async {
        debugDefaultTargetPlatformOverride = platform;
        messaging.status = status;

        expect(await launch().shouldPrompt(), expected);
      });
    }

    test('checking never opens the system dialog', () async {
      await launch().shouldPrompt();

      expect(messaging.permissionRequests, 0);
    });
  });

  group('frequency', () {
    test('is not shown again within 14 days', () async {
      await launch().recordShown();
      now = now.add(const Duration(days: 13, hours: 23));

      expect(await launch().shouldPrompt(), isFalse);
    });

    test('is shown a second time after 14 days', () async {
      await launch().recordShown();
      now = now.add(const Duration(days: 14));

      expect(await launch().shouldPrompt(), isTrue);
    });

    test('is never shown a third time', () async {
      await launch().recordShown();
      now = now.add(const Duration(days: 14));
      await launch().recordShown();
      now = now.add(const Duration(days: 365));

      expect(await launch().shouldPrompt(), isFalse);
    });

    test('is never shown again once the system request ends denied', () async {
      messaging.requestAnswer = AuthorizationStatus.denied;

      expect(await launch().requestPermission(), isFalse);
      now = now.add(const Duration(days: 365));

      expect(await launch().shouldPrompt(), isFalse);
    });

    test('a granted request reports success', () async {
      expect(await launch().requestPermission(), isTrue);
      expect(messaging.permissionRequests, 1);
    });

    test('a grant revoked later in settings can be prompted again', () async {
      await launch().recordShown();
      await launch().requestPermission();
      now = now.add(const Duration(days: 14));

      expect(await launch().shouldPrompt(), isTrue);
    });
  });

  test('only one prompt can be in progress at a time', () {
    final prompter = launch();

    expect(prompter.tryAcquire(), isTrue);
    expect(prompter.tryAcquire(), isFalse);

    prompter.release();
    expect(prompter.tryAcquire(), isTrue);
  });
}
