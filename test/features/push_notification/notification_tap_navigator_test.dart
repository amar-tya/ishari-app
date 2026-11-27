import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ishari/core/router/app_router.dart';
import 'package:ishari/core/wakelock/screen_wakelock.dart';
import 'package:ishari/features/push_notification/presentation/notification_tap_navigator.dart';
import 'package:ishari/shared/widgets/keep_screen_on.dart';

/// A page whose State identity tells whether it was rebuilt from scratch.
class _Page extends StatefulWidget {
  const _Page(this.location);

  final String location;

  @override
  State<_Page> createState() => _PageState();
}

class _PageState extends State<_Page> {
  /// Read once, like the real pages load their target: a page that go_router
  /// reused for a new location would keep showing the old one.
  late final String _loaded = widget.location;

  @override
  Widget build(BuildContext context) => Scaffold(body: Text(_loaded));
}

GoRouter _buildRouter({
  String initialLocation = '/home',
  ScreenWakelock? wakelock,
  GoRouterRedirect? redirect,
}) {
  GoRoute route(String path) => GoRoute(
    path: path,
    builder: (_, state) {
      final page = _Page(state.uri.toString());
      final isReader = path.startsWith('/chapter');
      return isReader && wakelock != null
          ? KeepScreenOn(wakelock: wakelock, child: page)
          : page;
    },
  );

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialLocation,
    observers: [appRouteObserver],
    redirect: redirect,
    routes: [
      route('/home'),
      route('/introduction'),
      route('/force-update'),
      route('/audio'),
      route('/tatanan'),
      route('/chapter/:chapterId'),
      route('/notifications'),
    ],
  );
}

/// Every page in the stack, bottom first. All test routes are top level, so the
/// configuration's own URI belongs to the only page that was not pushed.
List<String> _stackOf(GoRouter router) {
  final configuration = router.routerDelegate.currentConfiguration;
  return [
    for (final match in configuration.matches)
      if (match is ImperativeRouteMatch)
        match.matches.uri.toString()
      else
        configuration.uri.toString(),
  ];
}

State _topState(WidgetTester tester) => tester.state(find.byType(_Page).last);

void main() {
  late NotificationTapNavigator navigator;
  late GoRouter router;

  setUp(() => navigator = NotificationTapNavigator());

  tearDown(() => navigator.dispose());

  Future<void> pumpRouter(
    WidgetTester tester, {
    String initialLocation = '/home',
    ScreenWakelock? wakelock,
    GoRouterRedirect? redirect,
  }) async {
    router = _buildRouter(
      initialLocation: initialLocation,
      wakelock: wakelock,
      redirect: redirect,
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
  }

  Future<void> push(WidgetTester tester, String location) async {
    unawaited(router.push(location));
    await tester.pumpAndSettle();
  }

  group('delivery', () {
    testWidgets('pushes the target on top of home, so back returns '
        'there', (tester) async {
      await pumpRouter(tester);

      navigator.open('/chapter/3?verseId=9');
      await tester.pumpAndSettle();

      expect(_stackOf(router), ['/home', '/chapter/3?verseId=9']);

      router.pop();
      await tester.pumpAndSettle();
      expect(_stackOf(router), ['/home']);
    });

    testWidgets('an idle app gets a frame to deliver on', (tester) async {
      await pumpRouter(tester);
      expect(tester.binding.hasScheduledFrame, isFalse);

      navigator.open('/audio');

      expect(tester.binding.hasScheduledFrame, isTrue);
      await tester.pumpAndSettle();
    });

    testWidgets('waits for a router that is not mounted yet (splash still '
        'up)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: CircularProgressIndicator()),
      );
      navigator.open('/chapter/3?verseId=9');
      await tester.pump(const Duration(seconds: 2));

      await pumpRouter(tester);

      expect(_stackOf(router), ['/home', '/chapter/3?verseId=9']);
    });

    testWidgets('does not keep scheduling frames while there is no '
        'router', (tester) async {
      await tester.pumpWidget(const SizedBox.shrink());

      navigator.open('/audio');
      await tester.pump();

      expect(tester.binding.hasScheduledFrame, isFalse);
    });

    testWidgets('holds the target on the introduction and opens it once, on '
        'top of home', (tester) async {
      await pumpRouter(tester, initialLocation: '/introduction');
      navigator.open('/audio');
      await tester.pumpAndSettle();
      expect(_stackOf(router), ['/introduction']);

      router.go('/home');
      await tester.pumpAndSettle();
      expect(_stackOf(router), ['/home', '/audio']);

      router.pop();
      await tester.pumpAndSettle();
      router.go('/introduction');
      await tester.pumpAndSettle();
      router.go('/home');
      await tester.pumpAndSettle();
      expect(_stackOf(router), ['/home']);
    });

    testWidgets('only the latest held target is opened', (tester) async {
      await pumpRouter(tester, initialLocation: '/introduction');
      navigator.open('/audio');
      await tester.pumpAndSettle();
      navigator.open('/chapter/4?verseId=1');
      await tester.pumpAndSettle();

      router.go('/home');
      await tester.pumpAndSettle();

      expect(_stackOf(router), ['/home', '/chapter/4?verseId=1']);
    });

    testWidgets('drops the target on the force-update screen', (tester) async {
      await pumpRouter(tester, initialLocation: '/force-update');
      navigator.open('/audio');
      await tester.pumpAndSettle();

      router.go('/home');
      await tester.pumpAndSettle();

      expect(_stackOf(router), ['/home']);
    });
  });

  group('no needless duplicates', () {
    testWidgets('the exact location already on top is left alone', (
      tester,
    ) async {
      await pumpRouter(tester);
      await push(tester, '/chapter/3?verseId=9');
      final before = _topState(tester);

      navigator.open('/chapter/3?verseId=9');
      await tester.pumpAndSettle();

      expect(_stackOf(router), ['/home', '/chapter/3?verseId=9']);
      expect(_topState(tester), same(before));
    });

    testWidgets('/audio on top is replaced by a new page', (tester) async {
      await pumpRouter(tester);
      await push(tester, '/audio');
      final before = _topState(tester);

      navigator.open('/audio');
      await tester.pumpAndSettle();

      expect(_stackOf(router), ['/home', '/audio']);
      expect(_topState(tester), isNot(same(before)));
      expect(before.mounted, isFalse);
    });

    testWidgets('the same chapter on top is replaced for another '
        'verse', (tester) async {
      await pumpRouter(tester);
      await push(tester, '/chapter/3?verseId=9');
      final before = _topState(tester);

      navigator.open('/chapter/3?verseId=12');
      await tester.pumpAndSettle();

      expect(_stackOf(router), ['/home', '/chapter/3?verseId=12']);
      expect(find.text('/chapter/3?verseId=12'), findsOneWidget);
      expect(find.text('/chapter/3?verseId=9'), findsNothing);
      expect(_topState(tester), isNot(same(before)));
      expect(before.mounted, isFalse);
    });

    testWidgets('another chapter is pushed over the current one', (
      tester,
    ) async {
      await pumpRouter(tester);
      await push(tester, '/chapter/3?verseId=9');

      navigator.open('/chapter/4?verseId=1');
      await tester.pumpAndSettle();

      expect(_stackOf(router), [
        '/home',
        '/chapter/3?verseId=9',
        '/chapter/4?verseId=1',
      ]);
    });

    testWidgets('a target lower in the stack is pushed again, keeping the '
        'pages above it', (tester) async {
      await pumpRouter(tester);
      await push(tester, '/audio');
      await push(tester, '/tatanan');
      final tatanan = _topState(tester);

      navigator.open('/audio');
      await tester.pumpAndSettle();

      expect(_stackOf(router), ['/home', '/audio', '/tatanan', '/audio']);
      expect(tatanan.mounted, isTrue);
    });
  });

  group('a stack that does not start at home', () {
    testWidgets('goes home first, so back from the target returns '
        'there', (tester) async {
      await pumpRouter(tester, initialLocation: '/notifications');

      navigator.open('/chapter/3?verseId=9');
      await tester.pumpAndSettle();

      expect(_stackOf(router), ['/home', '/chapter/3?verseId=9']);
    });

    testWidgets('goes home first when the same chapter is the only page', (
      tester,
    ) async {
      await pumpRouter(tester, initialLocation: '/chapter/3?verseId=9');

      navigator.open('/chapter/3?verseId=12');
      await tester.pumpAndSettle();

      expect(_stackOf(router), ['/home', '/chapter/3?verseId=12']);
      expect(find.text('/chapter/3?verseId=12'), findsOneWidget);
    });

    testWidgets('is left alone when the target is already on top', (
      tester,
    ) async {
      await pumpRouter(tester, initialLocation: '/chapter/3?verseId=9');
      final before = _topState(tester);

      navigator.open('/chapter/3?verseId=9');
      await tester.pumpAndSettle();

      expect(_stackOf(router), ['/chapter/3?verseId=9']);
      expect(_topState(tester), same(before));
    });

    testWidgets('keeps the target while going home lands on the '
        'introduction', (tester) async {
      var hasAccess = true;
      await pumpRouter(
        tester,
        initialLocation: '/notifications',
        redirect: (_, state) => !hasAccess && state.matchedLocation == '/home'
            ? '/introduction'
            : null,
      );
      hasAccess = false;

      navigator.open('/audio');
      await tester.pumpAndSettle();
      expect(_stackOf(router), ['/introduction']);

      hasAccess = true;
      router.go('/home');
      await tester.pumpAndSettle();
      expect(_stackOf(router), ['/home', '/audio']);
    });
  });

  group('screen wakelock', () {
    late bool screenKeptOn;
    late ScreenWakelock wakelock;

    setUp(() {
      screenKeptOn = false;
      wakelock = ScreenWakelock(
        toggle: ({required enable}) async => screenKeptOn = enable,
      );
    });

    testWidgets('stays balanced when a reader is replaced', (tester) async {
      await pumpRouter(tester, wakelock: wakelock);
      await push(tester, '/chapter/3?verseId=9');

      navigator.open('/chapter/3?verseId=12');
      await tester.pumpAndSettle();
      expect(screenKeptOn, isTrue);

      // Anything left held by the replaced reader would keep it on here.
      router.pop();
      await tester.pumpAndSettle();
      expect(screenKeptOn, isFalse);
    });

    testWidgets('stays balanced when a reader is pushed over '
        'another', (tester) async {
      await pumpRouter(tester, wakelock: wakelock);
      await push(tester, '/chapter/3?verseId=9');

      navigator.open('/chapter/4?verseId=1');
      await tester.pumpAndSettle();
      expect(screenKeptOn, isTrue);

      router.pop();
      await tester.pumpAndSettle();
      expect(screenKeptOn, isTrue);

      router.pop();
      await tester.pumpAndSettle();
      expect(screenKeptOn, isFalse);
    });
  });

  group('dispose', () {
    testWidgets('forgets a target held on the introduction', (tester) async {
      await pumpRouter(tester, initialLocation: '/introduction');
      navigator.open('/audio');
      await tester.pumpAndSettle();

      navigator.dispose();
      router.go('/home');
      await tester.pumpAndSettle();

      expect(_stackOf(router), ['/home']);
    });

    testWidgets('forgets a target waiting for the router', (tester) async {
      await tester.pumpWidget(const SizedBox.shrink());
      navigator
        ..open('/audio')
        ..dispose();

      await pumpRouter(tester);

      expect(_stackOf(router), ['/home']);
    });

    testWidgets('ignores later taps', (tester) async {
      await pumpRouter(tester);

      navigator
        ..dispose()
        ..open('/audio');
      await tester.pumpAndSettle();

      expect(_stackOf(router), ['/home']);
    });
  });
}
