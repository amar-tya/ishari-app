// The router's auth redirect on its own: where each kind of visitor ends up
// for a location, without building the target page. `/home` and the readers
// need the app's dependency injection to build, so these tests only follow
// the redirects.
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ishari/core/analytics/analytics_service.dart';
import 'package:ishari/core/app_state.dart';
import 'package:ishari/core/router/app_router.dart';
import 'package:ishari/features/auth/domain/entities/user_entity.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/introduction/presentation/pages/introduction_page.dart';
import 'package:ishari/features/notifications/presentation/pages/notifications_page.dart';
import 'package:ishari/features/update/presentation/pages/force_update_page.dart';

const _home = '/home';
const _introduction = IntroductionPage.routePath;
const _forceUpdate = ForceUpdatePage.routePath;

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

const _signedIn = AuthState.authenticated(
  UserEntity(id: 'user-1', email: 'user@example.com'),
);

/// Every state in which the user has no session.
const _withoutSession = <String, AuthState>{
  'initial': AuthState.initial(),
  'loading': AuthState.loading(),
  'unauthenticated': AuthState.unauthenticated(),
  'error': AuthState.error('boom'),
};

/// Signed-in screens that can be opened with nothing but a path.
const _protected = [
  _home,
  '/chapter/12',
  '/chapter/12?verseId=5',
  '/kitab-page/12?bookId=2',
  NotificationsPage.routePath,
  '${NotificationsPage.routePath}/a',
  '/audio',
];

const _storeExtra = <String, dynamic>{
  'storeUrl': 'https://example.com/app',
  'releaseNotes': 'Catatan rilis',
};

void main() {
  setUp(() => AppState.isGuestMode.value = false);
  tearDown(() => AppState.isGuestMode.value = false);

  /// Runs the router's redirects for [location] as seen by a visitor in
  /// [auth], and returns where they end up.
  Future<String> redirectedPath(
    WidgetTester tester,
    String location, {
    required AuthState auth,
    bool guest = false,
    Object? extra,
  }) async {
    AppState.isGuestMode.value = guest;
    final router = createRouter(_FakeAuthBloc(auth), _FakeAnalyticsService());
    addTearDown(router.dispose);
    await tester.pumpWidget(const SizedBox.shrink());
    final context = tester.element(find.byType(SizedBox));
    final configuration = router.configuration;
    // The same two steps go_router's parser takes: the router's own redirect
    // once, then the redirect of the matched route.
    final redirectHistory = <RouteMatchList>[];
    final afterAuth = await configuration.applyTopLegacyRedirect(
      context,
      configuration.findMatch(Uri.parse(location), extra: extra),
      redirectHistory: redirectHistory,
    );
    final result = await configuration.redirect(
      context,
      afterAuth,
      redirectHistory: redirectHistory,
    );
    return result.uri.toString();
  }

  group('without a session and not a guest', () {
    for (final entry in _withoutSession.entries) {
      for (final location in _protected) {
        testWidgets('${entry.key}: $location goes to the introduction', (
          tester,
        ) async {
          expect(
            await redirectedPath(tester, location, auth: entry.value),
            _introduction,
          );
        });
      }

      testWidgets('${entry.key}: the introduction stays', (tester) async {
        expect(
          await redirectedPath(tester, _introduction, auth: entry.value),
          _introduction,
        );
      });
    }

    testWidgets('an unusable chapter id still goes to the introduction', (
      tester,
    ) async {
      // The auth rule runs before the chapter route's own redirect.
      expect(
        await redirectedPath(
          tester,
          '/chapter/abc',
          auth: const AuthState.unauthenticated(),
        ),
        _introduction,
      );
    });

    testWidgets('the introduction is matched by path, not by query', (
      tester,
    ) async {
      expect(
        await redirectedPath(
          tester,
          '$_introduction?from=link',
          auth: const AuthState.unauthenticated(),
        ),
        '$_introduction?from=link',
      );
    });
  });

  group('a guest', () {
    testWidgets('on the introduction goes home', (tester) async {
      expect(
        await redirectedPath(
          tester,
          _introduction,
          auth: const AuthState.unauthenticated(),
          guest: true,
        ),
        _home,
      );
    });

    testWidgets('on the introduction goes home whatever the auth state', (
      tester,
    ) async {
      for (final auth in _withoutSession.values) {
        expect(
          await redirectedPath(tester, _introduction, auth: auth, guest: true),
          _home,
        );
      }
    });

    for (final location in _protected) {
      testWidgets('is left alone on $location', (tester) async {
        expect(
          await redirectedPath(
            tester,
            location,
            auth: const AuthState.unauthenticated(),
            guest: true,
          ),
          location,
        );
      });
    }
  });

  group('a signed-in user', () {
    testWidgets('on the introduction goes home', (tester) async {
      expect(
        await redirectedPath(tester, _introduction, auth: _signedIn),
        _home,
      );
    });

    testWidgets('on the introduction goes home even as a guest too', (
      tester,
    ) async {
      expect(
        await redirectedPath(
          tester,
          _introduction,
          auth: _signedIn,
          guest: true,
        ),
        _home,
      );
    });

    for (final location in _protected) {
      testWidgets('is left alone on $location', (tester) async {
        expect(
          await redirectedPath(tester, location, auth: _signedIn),
          location,
        );
      });
    }

    testWidgets('still gets an unusable chapter id sent home', (tester) async {
      expect(
        await redirectedPath(tester, '/chapter/abc', auth: _signedIn),
        _home,
      );
    });
  });

  group('force update is never redirected by auth', () {
    final visitors = <String, ({AuthState auth, bool guest})>{
      for (final entry in _withoutSession.entries)
        'without a session (${entry.key})': (auth: entry.value, guest: false),
      'a guest': (auth: const AuthState.unauthenticated(), guest: true),
      'a signed-in user': (auth: _signedIn, guest: false),
    };

    for (final entry in visitors.entries) {
      testWidgets('${entry.key} stays on it', (tester) async {
        expect(
          await redirectedPath(
            tester,
            _forceUpdate,
            auth: entry.value.auth,
            guest: entry.value.guest,
            extra: _storeExtra,
          ),
          _forceUpdate,
        );
      });
    }

    testWidgets('without a store link a signed-in user or guest goes home', (
      tester,
    ) async {
      expect(
        await redirectedPath(tester, _forceUpdate, auth: _signedIn),
        _home,
      );
      expect(
        await redirectedPath(
          tester,
          _forceUpdate,
          auth: const AuthState.unauthenticated(),
          guest: true,
        ),
        _home,
      );
    });
  });
}
