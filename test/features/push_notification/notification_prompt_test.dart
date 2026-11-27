import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ishari/core/router/app_router.dart';
import 'package:ishari/core/wizard/wizard_cubit.dart';
import 'package:ishari/features/push_notification/data/services/notification_permission_prompter.dart';
import 'package:ishari/features/push_notification/presentation/home_notification_prompt.dart';
import 'package:ishari/features/push_notification/presentation/notification_prompt.dart';
import 'package:ishari/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fakes.dart';

const _title = 'Dapatkan notifikasi audio baru';
const _accept = 'Aktifkan';
const _later = 'Nanti saja';
const _settingsHint =
    'Pengaturan > Aplikasi > Sholawat Hadrah Ishari > Notifikasi';
const _countKey = 'notification_prompt_count';

class _GatedMessaging extends FakePushMessagingClient {
  /// While set, the permission status is not answered until it completes.
  Completer<void>? statusGate;
  Object? statusError;
  Object? requestError;

  @override
  Future<AuthorizationStatus> permissionStatus() async {
    await statusGate?.future;
    if (statusError case final error?) throw error;
    return super.permissionStatus();
  }

  @override
  Future<AuthorizationStatus> requestPermission() async {
    if (requestError case final error?) throw error;
    return super.requestPermission();
  }
}

void main() {
  late _GatedMessaging messaging;
  late SharedPreferences prefs;
  late NotificationPermissionPrompter prompter;
  late WizardCubit wizard;
  late Completer<void> wizardReady;
  late GoRouter router;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    messaging = _GatedMessaging();
    prompter = NotificationPermissionPrompter(messaging, prefs);
    sl.registerSingleton<NotificationPermissionPrompter>(prompter);
    wizard = WizardCubit(const FlutterSecureStorage());
  });

  tearDown(() async {
    await wizard.close();
    await sl.reset();
  });

  /// `/home` carries the home trigger; `/plain` and `/other` have none.
  Future<void> pumpApp(
    WidgetTester tester, {
    String initialLocation = '/home',
  }) async {
    GoRoute plain(String path) => GoRoute(
      path: path,
      builder: (_, __) => Scaffold(body: Text(path)),
    );
    router = GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: initialLocation,
      observers: [appRouteObserver],
      routes: [
        GoRoute(
          path: '/home',
          builder: (_, __) => HomeNotificationPrompt(
            wizardReady: wizardReady.future,
            child: const Scaffold(body: Text('/home')),
          ),
        ),
        plain('/plain'),
        plain('/other'),
      ],
    );
    addTearDown(router.dispose);
    // Made here, inside the test's fake clock; one from setUp would never run
    // its callbacks.
    wizardReady = Completer<void>();
    await tester.pumpWidget(
      BlocProvider<WizardCubit>.value(
        value: wizard,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> finishWizardInit(WidgetTester tester) async {
    wizardReady.complete();
    await tester.pumpAndSettle();
  }

  Future<void> push(WidgetTester tester, String location) async {
    unawaited(router.push(location));
    await tester.pumpAndSettle();
  }

  Future<void> pop(WidgetTester tester) async {
    router.pop();
    await tester.pumpAndSettle();
  }

  Future<void> tap(WidgetTester tester, String label) async {
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
  }

  BuildContext contextOf(WidgetTester tester, String text) =>
      tester.element(find.text(text));

  group('sheet', () {
    testWidgets('explains first; the system dialog is not opened by '
        'showing it', (tester) async {
      await pumpApp(tester);
      await finishWizardInit(tester);

      expect(find.text(_title), findsOneWidget);
      expect(find.text(_accept), findsOneWidget);
      expect(find.text(_later), findsOneWidget);
      expect(messaging.permissionRequests, 0);
    });

    testWidgets('counts as shown before it is answered', (tester) async {
      await pumpApp(tester);
      await finishWizardInit(tester);

      expect(prefs.getInt(_countKey), 1);
    });

    testWidgets('"Nanti saja" closes it without asking the system', (
      tester,
    ) async {
      await pumpApp(tester);
      await finishWizardInit(tester);

      await tap(tester, _later);

      expect(find.text(_title), findsNothing);
      expect(messaging.permissionRequests, 0);
      expect(find.textContaining(_settingsHint), findsNothing);
    });

    testWidgets('dismissing it does not ask the system', (tester) async {
      await pumpApp(tester);
      await finishWizardInit(tester);

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(find.text(_title), findsNothing);
      expect(messaging.permissionRequests, 0);
    });

    testWidgets('"Aktifkan" asks the system once', (tester) async {
      await pumpApp(tester);
      await finishWizardInit(tester);

      await tap(tester, _accept);

      expect(messaging.permissionRequests, 1);
      expect(find.text(_title), findsNothing);
      expect(find.textContaining(_settingsHint), findsNothing);
    });

    testWidgets('a denied request points to the system settings', (
      tester,
    ) async {
      messaging.requestAnswer = AuthorizationStatus.denied;
      await pumpApp(tester);
      await finishWizardInit(tester);

      await tap(tester, _accept);

      expect(find.textContaining(_settingsHint), findsOneWidget);
      expect(await prompter.shouldPrompt(), isFalse);
    });

    testWidgets('is not shown when notifications are already allowed', (
      tester,
    ) async {
      messaging.status = AuthorizationStatus.authorized;
      await pumpApp(tester);
      await finishWizardInit(tester);

      expect(find.text(_title), findsNothing);
      expect(prefs.getInt(_countKey), isNull);
    });

    testWidgets('only one is shown when two screens ask at once', (
      tester,
    ) async {
      await pumpApp(tester, initialLocation: '/plain');
      final context = contextOf(tester, '/plain');

      unawaited(offerNotificationPrompt(context));
      unawaited(offerNotificationPrompt(context));
      await tester.pumpAndSettle();

      expect(find.text(_title), findsOneWidget);
      expect(prefs.getInt(_countKey), 1);
    });

    testWidgets('a page covered while permission is being read gets none, '
        'and nothing is counted', (tester) async {
      messaging.statusGate = Completer<void>();
      await pumpApp(tester, initialLocation: '/plain');
      unawaited(offerNotificationPrompt(contextOf(tester, '/plain')));

      await push(tester, '/other');
      messaging.statusGate!.complete();
      await tester.pumpAndSettle();

      expect(find.text(_title), findsNothing);
      expect(prefs.getInt(_countKey), isNull);
      expect(prompter.tryAcquire(), isTrue);
    });

    testWidgets('a failing permission check neither throws nor blocks later '
        'prompts', (tester) async {
      messaging.statusError = StateError('status');
      await pumpApp(tester, initialLocation: '/plain');

      await offerNotificationPrompt(contextOf(tester, '/plain'));

      expect(tester.takeException(), isNull);
      expect(prompter.tryAcquire(), isTrue);
    });

    testWidgets('a failing system request neither throws nor blocks later '
        'prompts', (tester) async {
      messaging.requestError = StateError('request');
      await pumpApp(tester, initialLocation: '/plain');
      unawaited(offerNotificationPrompt(contextOf(tester, '/plain')));
      await tester.pumpAndSettle();

      await tap(tester, _accept);

      expect(tester.takeException(), isNull);
      expect(prompter.tryAcquire(), isTrue);
    });

    testWidgets('frees the slot when its page is replaced', (tester) async {
      await pumpApp(tester);
      await push(tester, '/plain');
      unawaited(offerNotificationPrompt(contextOf(tester, '/plain')));
      await tester.pumpAndSettle();
      expect(find.text(_title), findsOneWidget);

      unawaited(router.pushReplacement<void>('/other'));
      await tester.pumpAndSettle();

      expect(find.text(_title), findsNothing);
      expect(prompter.tryAcquire(), isTrue);
    });
  });

  group('home trigger', () {
    testWidgets('waits until the wizard has loaded its state', (tester) async {
      await pumpApp(tester);

      expect(find.text(_title), findsNothing);
      expect(messaging.statusReads, 0);
    });

    testWidgets('stays away during the tour and appears when it ends on '
        'home', (tester) async {
      await wizard.init();
      await pumpApp(tester);
      await finishWizardInit(tester);
      expect(find.text(_title), findsNothing);
      expect(prefs.getInt(_countKey), isNull);

      wizard.skip();
      await tester.pumpAndSettle();

      expect(find.text(_title), findsOneWidget);
    });

    testWidgets('waits for the way back when the tour ends on a pushed '
        'page', (tester) async {
      await wizard.init();
      await pumpApp(tester);
      await finishWizardInit(tester);
      await push(tester, '/plain');

      wizard.skip();
      await tester.pumpAndSettle();
      expect(find.text(_title), findsNothing);
      expect(prefs.getInt(_countKey), isNull);

      await pop(tester);

      expect(find.text(_title), findsOneWidget);
    });

    testWidgets('stays away on the way back while the tour is still '
        'running', (tester) async {
      await wizard.init();
      await pumpApp(tester);
      await finishWizardInit(tester);
      await push(tester, '/plain');

      await pop(tester);

      expect(find.text(_title), findsNothing);
    });

    testWidgets('a home that is covered gets it once uncovered', (
      tester,
    ) async {
      await pumpApp(tester);
      await push(tester, '/plain');

      await finishWizardInit(tester);
      expect(find.text(_title), findsNothing);

      await pop(tester);

      expect(find.text(_title), findsOneWidget);
    });
  });
}
