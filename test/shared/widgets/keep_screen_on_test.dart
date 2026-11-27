import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishari/core/wakelock/screen_wakelock.dart';
import 'package:ishari/shared/widgets/keep_screen_on.dart';

void main() {
  late List<bool> toggles;
  late ScreenWakelock wakelock;
  late RouteObserver<PageRoute<void>> observer;
  late GlobalKey<NavigatorState> navigator;

  bool screenKeptOn() => toggles.isNotEmpty && toggles.last;

  setUp(() {
    toggles = [];
    wakelock = ScreenWakelock(
      toggle: ({required enable}) async => toggles.add(enable),
    );
    observer = RouteObserver<PageRoute<void>>();
    navigator = GlobalKey<NavigatorState>();
  });

  Widget reader(String label) => KeepScreenOn(
    wakelock: wakelock,
    routeObserver: observer,
    child: Scaffold(body: Text(label)),
  );

  Future<void> pumpApp(WidgetTester tester) => tester.pumpWidget(
    MaterialApp(
      navigatorKey: navigator,
      navigatorObservers: [observer],
      home: const Scaffold(body: Text('home')),
    ),
  );

  Future<void> push(WidgetTester tester, Widget page) async {
    unawaited(
      navigator.currentState!.push(
        MaterialPageRoute<void>(builder: (_) => page),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> pop(WidgetTester tester) async {
    navigator.currentState!.pop();
    await tester.pumpAndSettle();
  }

  Future<void> lifecycle(
    WidgetTester tester,
    List<AppLifecycleState> states,
  ) async {
    states.forEach(tester.binding.handleAppLifecycleStateChanged);
    await tester.pump();
  }

  const toBackground = [
    AppLifecycleState.inactive,
    AppLifecycleState.hidden,
    AppLifecycleState.paused,
  ];
  const toForeground = [
    AppLifecycleState.hidden,
    AppLifecycleState.inactive,
    AppLifecycleState.resumed,
  ];

  testWidgets('screens that are not readers leave the wakelock alone', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(toggles, isEmpty);
  });

  testWidgets('on while a reader is open, off once it is closed', (
    tester,
  ) async {
    await pumpApp(tester);

    await push(tester, reader('a'));
    expect(toggles, [true]);

    await pop(tester);
    expect(toggles, [true, false]);
  });

  testWidgets('off while backgrounded, on again after resume', (tester) async {
    await pumpApp(tester);
    await push(tester, reader('a'));

    await lifecycle(tester, toBackground);
    expect(screenKeptOn(), isFalse);

    await lifecycle(tester, toForeground);
    expect(screenKeptOn(), isTrue);

    await pop(tester);
    expect(screenKeptOn(), isFalse);
  });

  testWidgets('inactive alone (notification shade) changes nothing', (
    tester,
  ) async {
    await pumpApp(tester);
    await push(tester, reader('a'));

    await lifecycle(tester, [AppLifecycleState.inactive]);
    await lifecycle(tester, [AppLifecycleState.resumed]);

    expect(toggles, [true]);
    await pop(tester);
  });

  testWidgets('resuming without a reader does not enable', (tester) async {
    await pumpApp(tester);
    await push(tester, reader('a'));
    await pop(tester);

    await lifecycle(tester, toBackground);
    await lifecycle(tester, toForeground);

    expect(screenKeptOn(), isFalse);
  });

  testWidgets('a reader pushed over a reader keeps it on until both close', (
    tester,
  ) async {
    await pumpApp(tester);
    await push(tester, reader('a'));
    await push(tester, reader('b'));
    expect(screenKeptOn(), isTrue);

    await pop(tester);
    expect(screenKeptOn(), isTrue);

    await pop(tester);
    expect(screenKeptOn(), isFalse);
  });

  testWidgets('stacked readers are both released while backgrounded', (
    tester,
  ) async {
    await pumpApp(tester);
    await push(tester, reader('a'));
    await push(tester, reader('b'));

    await lifecycle(tester, toBackground);
    expect(screenKeptOn(), isFalse);

    await lifecycle(tester, toForeground);
    expect(screenKeptOn(), isTrue);

    await pop(tester);
    expect(screenKeptOn(), isTrue);
    await pop(tester);
    expect(screenKeptOn(), isFalse);
  });

  testWidgets('off while another full page covers the reader', (tester) async {
    await pumpApp(tester);
    await push(tester, reader('a'));

    await push(tester, const Scaffold(body: Text('audio list')));
    expect(screenKeptOn(), isFalse);

    // Resume must not re-enable for a reader that is still covered.
    await lifecycle(tester, toBackground);
    await lifecycle(tester, toForeground);
    expect(screenKeptOn(), isFalse);

    await pop(tester);
    expect(screenKeptOn(), isTrue);
    await pop(tester);
    expect(screenKeptOn(), isFalse);
  });

  testWidgets('a bottom sheet over the reader keeps it on', (tester) async {
    await pumpApp(tester);
    await push(tester, reader('a'));

    unawaited(
      showModalBottomSheet<void>(
        context: tester.element(find.text('a')),
        builder: (_) => const Text('sheet'),
      ),
    );
    await tester.pumpAndSettle();

    expect(toggles, [true]);
    await pop(tester);
    await pop(tester);
    expect(screenKeptOn(), isFalse);
  });

  testWidgets('removing the whole stack releases every reader', (tester) async {
    await pumpApp(tester);
    await push(tester, reader('a'));
    await push(tester, reader('b'));

    unawaited(
      navigator.currentState!.pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const Scaffold()),
        (_) => false,
      ),
    );
    await tester.pumpAndSettle();

    expect(screenKeptOn(), isFalse);
  });
}
