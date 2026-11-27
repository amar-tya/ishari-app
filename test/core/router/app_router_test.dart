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
import 'package:ishari/features/auth/domain/entities/user_entity.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/notifications/domain/entities/notification_entity.dart';
import 'package:ishari/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:ishari/features/notifications/domain/usecases/get_notifications.dart';
import 'package:ishari/features/notifications/domain/usecases/mark_all_notifications_read.dart';
import 'package:ishari/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:ishari/features/notifications/presentation/pages/notification_detail_page.dart';
import 'package:ishari/features/notifications/presentation/pages/notifications_page.dart';
import 'package:ishari/features/update/presentation/pages/force_update_page.dart';

class _FakeAuthBloc extends Fake implements AuthBloc {
  _FakeAuthBloc(this.state);

  @override
  final AuthState state;

  @override
  Stream<AuthState> get stream => const Stream.empty();
}

class _FakeFirebaseAnalytics implements FirebaseAnalytics {
  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.value();
}

class _FakeAnalyticsService extends Fake implements AnalyticsService {
  @override
  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _FakeFirebaseAnalytics());
}

typedef _LoadResult = Either<Failure, List<NotificationEntity>>;

class _FakeNotificationsRepository implements NotificationsRepository {
  /// Answers handed out in order; the last one repeats.
  List<Future<_LoadResult> Function()> answers = [
    () async => right(const <NotificationEntity>[]),
  ];

  final List<String?> loadUserIds = [];
  final List<List<String>> markedForUser = [];

  @override
  Future<_LoadResult> getNotifications({String? userId}) {
    loadUserIds.add(userId);
    final index = loadUserIds.length - 1;
    return answers[index < answers.length ? index : answers.length - 1]();
  }

  @override
  Future<Either<Failure, Unit>> markAllAsReadForUser({
    required String userId,
    required List<String> notificationIds,
  }) async {
    markedForUser.add(notificationIds);
    return right(unit);
  }

  @override
  Future<Either<Failure, Unit>> updateGuestLastSeen() async => right(unit);
}

NotificationEntity _notification(String id, {String? title}) =>
    NotificationEntity(
      id: id,
      title: title ?? 'Judul $id',
      body: 'Isi $id',
      type: 'info',
      publishedAt: DateTime(2026, 11),
    );

void main() {
  late _FakeNotificationsRepository repository;
  late _FakeAuthBloc authBloc;
  NotificationsBloc? bloc;

  // Built on first use, inside the test body: a bloc created in `setUp` lives
  // outside the fake-async zone, so `pump` would never deliver its events.
  NotificationsBloc notificationsBloc() => bloc ??= NotificationsBloc(
    GetNotifications(repository),
    MarkAllNotificationsRead(repository),
  );

  setUp(() {
    AppState.isGuestMode.value = true;
    repository = _FakeNotificationsRepository();
    authBloc = _FakeAuthBloc(const AuthState.unauthenticated());
  });

  tearDown(() {
    AppState.isGuestMode.value = false;
    unawaited(bloc?.close());
    bloc = null;
  });

  /// Pumps the real app router. Starts on `/notifications`, which needs
  /// nothing from GetIt, unless [location] says otherwise.
  Future<GoRouter> pumpRouter(
    WidgetTester tester, {
    String location = NotificationsPage.routePath,
  }) async {
    final router = createRouter(
      authBloc,
      _FakeAnalyticsService(),
      initialLocation: location,
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: authBloc),
          BlocProvider<NotificationsBloc>.value(value: notificationsBloc()),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    return router;
  }

  String locationOf(GoRouter router) =>
      router.routerDelegate.currentConfiguration.uri.path;

  /// Runs the router's redirects for [location] without building the target
  /// page, so `/home` and the readers need no dependency injection here.
  Future<String> redirectedPath(WidgetTester tester, String location) async {
    final router = createRouter(authBloc, _FakeAnalyticsService());
    addTearDown(router.dispose);
    await tester.pumpWidget(const SizedBox.shrink());
    final result = await router.configuration.redirect(
      tester.element(find.byType(SizedBox)),
      router.configuration.findMatch(Uri.parse(location)),
      redirectHistory: [],
    );
    return result.uri.toString();
  }

  group('chapter routes', () {
    const invalid = [
      '/chapter/abc',
      '/chapter/null?verseId=5',
      '/chapter/0',
      '/chapter/-3',
      '/chapter/1.5',
      '/kitab-page/abc',
    ];

    for (final location in invalid) {
      testWidgets('$location redirects to /home', (tester) async {
        expect(await redirectedPath(tester, location), '/home');
      });
    }

    for (final location in [
      '/chapter/12?verseId=5',
      '/chapter/12?verseId=abc',
      '/kitab-page/12?bookId=2',
    ]) {
      testWidgets('$location is left alone', (tester) async {
        expect(await redirectedPath(tester, location), location);
      });
    }
  });

  group('force-update route', () {
    testWidgets('accepts a Map<String, dynamic> extra', (tester) async {
      final router = await pumpRouter(tester);

      router.go(
        ForceUpdatePage.routePath,
        extra: <String, dynamic>{
          'storeUrl': 'https://example.com/app',
          'releaseNotes': 'Catatan rilis',
        },
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final page = tester.widget<ForceUpdatePage>(find.byType(ForceUpdatePage));
      expect(page.storeUrl, 'https://example.com/app');
      expect(page.releaseNotes, 'Catatan rilis');
    });

    testWidgets('ignores non-String release notes', (tester) async {
      final router = await pumpRouter(tester);

      router.go(
        ForceUpdatePage.routePath,
        extra: <String, dynamic>{
          'storeUrl': 'https://example.com/app',
          'releaseNotes': 42,
        },
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      final page = tester.widget<ForceUpdatePage>(find.byType(ForceUpdatePage));
      expect(page.releaseNotes, isEmpty);
    });

    final unusable = <String, Object?>{
      'no extra': null,
      'a non-Map extra': 'junk',
      'an empty storeUrl': <String, String>{'storeUrl': ''},
      'a non-String storeUrl': <String, dynamic>{'storeUrl': 7},
    };

    for (final entry in unusable.entries) {
      testWidgets('redirects to /home with ${entry.key}', (tester) async {
        final router = createRouter(authBloc, _FakeAnalyticsService());
        addTearDown(router.dispose);
        await tester.pumpWidget(const SizedBox.shrink());

        final result = await router.configuration.redirect(
          tester.element(find.byType(SizedBox)),
          router.configuration.findMatch(
            Uri.parse(ForceUpdatePage.routePath),
            extra: entry.value,
          ),
          redirectHistory: [],
        );

        expect(result.uri.path, '/home');
      });
    }
  });

  group('notification detail without a usable extra', () {
    testWidgets('loads the notification by id', (tester) async {
      repository.answers = [
        () async => right([_notification('a'), _notification('b')]),
      ];

      await pumpRouter(tester, location: '/notifications/b');
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Detail Notifikasi'), findsOneWidget);
      expect(find.text('Judul b'), findsOneWidget);
      expect(repository.loadUserIds, [null]);
    });

    testWidgets('uses the already loaded list without loading again', (
      tester,
    ) async {
      repository.answers = [
        () async => right([_notification('a')]),
      ];
      notificationsBloc().add(const NotificationsEvent.load());
      await tester.pump();

      await pumpRouter(tester, location: '/notifications/a');
      await tester.pumpAndSettle();

      expect(find.text('Judul a'), findsOneWidget);
      expect(repository.loadUserIds, hasLength(1));
    });

    testWidgets('loads for the signed-in user and marks it read', (
      tester,
    ) async {
      AppState.isGuestMode.value = false;
      authBloc = _FakeAuthBloc(
        const AuthState.authenticated(
          UserEntity(id: 'user-1', email: 'user@example.com'),
        ),
      );
      // Two unread items: the list page underneath marks both at once, so
      // only the detail page can produce a call for `a` alone.
      repository.answers = [
        () async => right([_notification('a'), _notification('b')]),
      ];

      await pumpRouter(tester, location: '/notifications/a');
      await tester.pumpAndSettle();

      expect(repository.loadUserIds, ['user-1']);
      expect(
        repository.markedForUser,
        contains(equals(<String>['a'])),
      );
    });

    testWidgets('ignores an extra of the wrong type', (tester) async {
      repository.answers = [
        () async => right([_notification('a')]),
      ];
      final router = await pumpRouter(tester);

      router.go('/notifications/a', extra: <String, dynamic>{'id': 'a'});
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Judul a'), findsOneWidget);
    });

    testWidgets('ignores an extra that belongs to another id', (tester) async {
      repository.answers = [
        () async => right([_notification('a')]),
      ];
      final router = await pumpRouter(tester);

      router.go('/notifications/a', extra: _notification('z'));
      await tester.pumpAndSettle();

      expect(find.text('Judul a'), findsOneWidget);
      expect(find.text('Judul z'), findsNothing);
    });

    testWidgets('shows the next notification when only the id changes', (
      tester,
    ) async {
      repository.answers = [
        () async => right([_notification('a'), _notification('b')]),
      ];
      final router = await pumpRouter(tester, location: '/notifications/a');
      await tester.pumpAndSettle();

      router.go('/notifications/b');
      await tester.pumpAndSettle();

      expect(find.text('Judul b'), findsOneWidget);
      expect(find.text('Judul a'), findsNothing);
    });

    testWidgets('shows not found when the list comes back empty', (
      tester,
    ) async {
      final router = await pumpRouter(tester, location: '/notifications/a');
      await tester.pumpAndSettle();

      expect(find.text('Notifikasi tidak ditemukan'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(repository.loadUserIds, hasLength(1));

      await tester.tap(find.text('Lihat semua notifikasi'));
      await tester.pumpAndSettle();

      expect(locationOf(router), NotificationsPage.routePath);
      expect(find.byType(NotificationDetailPage), findsNothing);
    });

    testWidgets('reloads once when a stale list lacks the id', (tester) async {
      repository.answers = [
        () async => right([_notification('a')]),
        () async => right([_notification('a'), _notification('new')]),
      ];
      notificationsBloc().add(const NotificationsEvent.load());
      await tester.pump();

      await pumpRouter(tester, location: '/notifications/new');
      await tester.pumpAndSettle();

      expect(find.text('Judul new'), findsOneWidget);
      expect(repository.loadUserIds, hasLength(2));
    });

    testWidgets('shows the load error and retries only when asked', (
      tester,
    ) async {
      repository.answers = [
        () async => left(const NetworkFailure()),
        () async => right([_notification('a')]),
      ];

      await pumpRouter(tester, location: '/notifications/a');
      await tester.pumpAndSettle();

      expect(find.text('No internet connection'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(repository.loadUserIds, hasLength(1));

      await tester.tap(find.text('Coba lagi'));
      await tester.pumpAndSettle();

      expect(find.text('Judul a'), findsOneWidget);
      expect(repository.loadUserIds, hasLength(2));
    });

    testWidgets('stops spinning when the load never finishes', (tester) async {
      final never = Completer<_LoadResult>();
      repository.answers = [() => never.future];

      await pumpRouter(tester, location: '/notifications/a');
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(NotificationDetailPage.loadTimeout);
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Notifikasi belum bisa dimuat'), findsOneWidget);
      expect(find.text('Coba lagi'), findsOneWidget);
      expect(find.text('Lihat semua notifikasi'), findsOneWidget);
    });

    testWidgets('says not found when a late load lacks the id', (
      tester,
    ) async {
      final late = Completer<_LoadResult>();
      repository.answers = [() => late.future];

      await pumpRouter(tester, location: '/notifications/a');
      await tester.pump(NotificationDetailPage.loadTimeout);
      await tester.pump();

      late.complete(right(const <NotificationEntity>[]));
      await tester.pumpAndSettle();

      expect(find.text('Notifikasi tidak ditemukan'), findsOneWidget);
      expect(find.text('Notifikasi belum bisa dimuat'), findsNothing);
    });

    testWidgets('a later reload elsewhere cannot restart an untimed spinner', (
      tester,
    ) async {
      final never = Completer<_LoadResult>();
      repository.answers = [
        () async => right(const <NotificationEntity>[]),
        () => never.future,
      ];
      await pumpRouter(tester, location: '/notifications/a');
      await tester.pumpAndSettle();

      notificationsBloc().add(const NotificationsEvent.load());
      await tester.pump();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Lihat semua notifikasi'), findsOneWidget);
    });

    testWidgets('back button leaves a direct link', (tester) async {
      repository.answers = [
        () async => right([_notification('a')]),
      ];
      final router = await pumpRouter(tester, location: '/notifications/a');
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(locationOf(router), NotificationsPage.routePath);
      expect(find.byType(NotificationDetailPage), findsNothing);
    });

    testWidgets('a pushed notification still renders from extra', (
      tester,
    ) async {
      final router = await pumpRouter(tester);

      unawaited(
        router.push<void>(
          NotificationDetailPage.routePath('a'),
          extra: _notification('a', title: 'Dari kartu'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Dari kartu'), findsOneWidget);
      expect(repository.loadUserIds, isEmpty);
    });
  });
}
