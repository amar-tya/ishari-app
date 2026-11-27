// The real router, AuthBloc and introduction page when the session changes.
// The notification pages stand in for any signed-in screen: unlike `/home`
// and the readers, they build without the app's dependency injection.
import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:go_router/go_router.dart';
import 'package:ishari/core/analytics/analytics_service.dart';
import 'package:ishari/core/app_state.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/router/app_router.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/introduction/presentation/pages/introduction_page.dart';
import 'package:ishari/features/notifications/domain/entities/notification_entity.dart';
import 'package:ishari/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:ishari/features/notifications/domain/usecases/get_notifications.dart';
import 'package:ishari/features/notifications/domain/usecases/mark_all_notifications_read.dart';
import 'package:ishari/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:ishari/features/notifications/presentation/pages/notification_detail_page.dart';
import 'package:ishari/features/notifications/presentation/pages/notifications_page.dart';
import 'package:ishari/features/update/presentation/pages/force_update_page.dart';

import '../../features/auth/auth_fakes.dart';

const _message = 'Sesi berakhir, silakan masuk lagi';
const _introduction = IntroductionPage.routePath;

class _FakeFirebaseAnalytics implements FirebaseAnalytics {
  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.value();
}

class _FakeAnalyticsService extends Fake implements AnalyticsService {
  @override
  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _FakeFirebaseAnalytics());
}

class _FakeNotificationsRepository extends Fake
    implements NotificationsRepository {
  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    String? userId,
  }) async => right([
    NotificationEntity(
      id: 'a',
      title: 'Judul a',
      body: 'Isi a',
      type: 'info',
      publishedAt: DateTime(2026, 11),
    ),
  ]);

  @override
  Future<Either<Failure, Unit>> markAllAsReadForUser({
    required String userId,
    required List<String> notificationIds,
  }) async => right(unit);

  @override
  Future<Either<Failure, Unit>> updateGuestLastSeen() async => right(unit);
}

/// The app as it is after startup. Create it inside the test body: a bloc built
/// outside the fake-async zone never receives its events under `pump`.
class _App {
  _App(this.tester);

  final WidgetTester tester;
  final repository = ControllableAuthRepository();
  late final bloc = buildControllableAuthBloc(repository);
  late final GoRouter router;

  String get location => router.routerDelegate.currentConfiguration.uri.path;

  /// What the SDK does at startup, then the startup auth check.
  Future<void> coldStart({required bool withSession}) async {
    repository
      ..sessionUser = withSession ? testUser : null
      ..changes.add(repository.sessionUser);
    bloc.add(const AuthEvent.checkAuthStatus());
    await tester.pump();
    await tester.pump();
  }

  /// The SDK removes the session, e.g. its refresh token was rejected.
  Future<void> loseSession() async {
    repository
      ..sessionUser = null
      ..changes.add(null);
    await tester.pumpAndSettle();
  }

  Future<void> open(String initialLocation) async {
    final notifications = NotificationsBloc(
      GetNotifications(_FakeNotificationsRepository()),
      MarkAllNotificationsRead(_FakeNotificationsRepository()),
    );
    router = createRouter(
      bloc,
      _FakeAnalyticsService(),
      initialLocation: initialLocation,
    );
    addTearDown(() {
      router.dispose();
      unawaited(notifications.close());
      unawaited(bloc.close());
    });
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: bloc),
          BlocProvider<NotificationsBloc>.value(value: notifications),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Waits out any snack bar, so a later one can only be a new one.
  Future<void> letSnackBarExpire() async {
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  }
}

void main() {
  setUp(() => AppState.isGuestMode.value = false);
  tearDown(() => AppState.isGuestMode.value = false);

  void usePhoneScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  group('losing the session', () {
    testWidgets('redirects a pushed route and says why', (tester) async {
      usePhoneScreen(tester);
      final app = _App(tester);
      await app.coldStart(withSession: true);
      await app.open(NotificationsPage.routePath);
      unawaited(app.router.push('${NotificationsPage.routePath}/a'));
      await tester.pumpAndSettle();
      expect(find.byType(NotificationDetailPage), findsOneWidget);

      await app.loseSession();

      expect(app.location, _introduction);
      expect(find.byType(IntroductionPage), findsOneWidget);
      expect(
        find.byType(NotificationDetailPage, skipOffstage: false),
        findsNothing,
      );
      expect(
        find.byType(NotificationsPage, skipOffstage: false),
        findsNothing,
      );
      expect(app.router.canPop(), isFalse);
      expect(find.text(_message), findsOneWidget);
    });

    testWidgets('before the app is shown also says why', (tester) async {
      usePhoneScreen(tester);
      final app = _App(tester);
      await app.coldStart(withSession: true);
      await app.loseSession();

      await app.open(_introduction);

      expect(find.text(_message), findsOneWidget);
    });

    testWidgets('says why once: not on a rebuild or a later visit', (
      tester,
    ) async {
      usePhoneScreen(tester);
      final app = _App(tester);
      await app.coldStart(withSession: true);
      await app.open(NotificationsPage.routePath);
      await app.loseSession();
      expect(find.text(_message), findsOneWidget);
      await app.letSnackBarExpire();
      expect(find.text(_message), findsNothing);

      tester.view.physicalSize = const Size(440, 940);
      await tester.pumpAndSettle();
      expect(find.text(_message), findsNothing);

      // Leave for the one page the router never redirects away from, then
      // come back to a fresh introduction page.
      app.router.go(
        ForceUpdatePage.routePath,
        extra: {'storeUrl': 'https://example.com/app'},
      );
      await tester.pumpAndSettle();
      expect(
        find.byType(IntroductionPage, skipOffstage: false),
        findsNothing,
      );
      app.router.go(_introduction);
      await tester.pumpAndSettle();

      expect(find.byType(IntroductionPage), findsOneWidget);
      expect(find.text(_message), findsNothing);
    });
  });

  group('no message', () {
    testWidgets('after an explicit sign-out', (tester) async {
      usePhoneScreen(tester);
      final app = _App(tester);
      await app.coldStart(withSession: true);
      await app.open(NotificationsPage.routePath);
      app.repository.signOutResult = () async {
        app.repository.changes.add(null);
        return right(unit);
      };

      app.bloc.add(const AuthEvent.signOut());
      await tester.pumpAndSettle();

      expect(app.location, _introduction);
      expect(find.text(_message), findsNothing);
    });

    testWidgets('on first launch or a cold start without a session', (
      tester,
    ) async {
      usePhoneScreen(tester);
      final app = _App(tester);
      await app.coldStart(withSession: false);

      await app.open(_introduction);

      expect(find.byType(IntroductionPage), findsOneWidget);
      expect(find.text(_message), findsNothing);
    });

    testWidgets('in guest mode, which a signed-out event leaves alone', (
      tester,
    ) async {
      usePhoneScreen(tester);
      final app = _App(tester);
      await app.coldStart(withSession: false);
      AppState.isGuestMode.value = true;
      await app.open(NotificationsPage.routePath);

      await app.loseSession();

      expect(app.location, NotificationsPage.routePath);
      expect(find.byType(NotificationsPage), findsOneWidget);
      expect(find.text(_message), findsNothing);

      // Leaving guest mode shows the introduction page without it too.
      AppState.isGuestMode.value = false;
      await tester.pumpAndSettle();

      expect(find.byType(IntroductionPage), findsOneWidget);
      expect(find.text(_message), findsNothing);
    });
  });
}
