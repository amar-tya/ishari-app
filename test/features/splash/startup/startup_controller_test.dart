import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/splash/startup/startup_controller.dart';
import 'package:ishari/features/splash/startup/startup_steps.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'startup_fakes.dart';

class _Harness {
  final auth = FakeAuthRepository();
  final update = FakeUpdateRepository();
  late final updateCubit = buildUpdateCubit(update);

  final createdBlocs = <AuthBloc>[];
  final reported = <Object>[];
  final uncaught = <Object>[];
  final backgroundTasks = <String, Future<void> Function()>{};

  Future<void> Function(StartupSteps steps) initialize = (_) async {};

  late final controller = StartupController(
    initialize: (steps) => initialize(steps),
    createAuthBloc: () {
      // A throwing bloc handler rethrows into the zone the bloc was built in.
      final bloc = runZonedGuarded(
        () => buildAuthBloc(auth),
        (error, _) => uncaught.add(error),
      )!;
      createdBlocs.add(bloc);
      return bloc;
    },
    resolveUpdateCubit: () => updateCubit,
    backgroundTasks: backgroundTasks,
    reportError: (error, _) => reported.add(error),
  );
}

/// Whether `close()` was called. `isClosed` only flips once close() finishes,
/// which does not happen on the fake clock.
bool _closeRequested(AuthBloc bloc) {
  try {
    bloc.add(const AuthEvent.checkAuthStatus());
    return false;
  } on StateError {
    return true;
  }
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 1));
  }
}

void main() {
  setUp(() {
    PackageInfo.setMockInitialValues(
      appName: 'ishari',
      packageName: 'com.ishari.app',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  testWidgets('a healthy startup becomes ready without reporting', (
    tester,
  ) async {
    final h = _Harness();

    unawaited(h.controller.start());
    await _settle(tester);

    expect(h.controller.status, StartupStatus.ready);
    expect(h.reported, isEmpty);
    h.controller.dispose();
  });

  testWidgets('an init error is reported, and retry recovers without '
      'repeating finished steps', (tester) async {
    final h = _Harness();
    var firebaseRuns = 0;
    var supabaseRuns = 0;
    h.initialize = (steps) async {
      await steps.runOnce('firebase', () async => firebaseRuns++);
      await steps.runOnce('supabase', () async {
        supabaseRuns++;
        if (supabaseRuns == 1) throw StateError('supabase down');
      });
    };

    unawaited(h.controller.start());
    await _settle(tester);

    expect(h.controller.status, StartupStatus.failed);
    expect(h.reported.single, isStateError);

    unawaited(h.controller.start());
    await _settle(tester);

    expect(h.controller.status, StartupStatus.ready);
    expect(firebaseRuns, 1);
    expect(supabaseRuns, 2);
    h.controller.dispose();
  });

  testWidgets('a background task waiting on the user does not block startup, '
      'and is not started again by retry', (tester) async {
    final h = _Harness();
    var permissionRequests = 0;
    h.backgroundTasks['fcm'] = () {
      permissionRequests++;
      return Completer<void>().future;
    };
    h.auth.currentUser = hungAuth;

    unawaited(h.controller.start());
    await _settle(tester);
    await tester.pump(const Duration(seconds: 21));
    h.auth.currentUser = signedOut;
    unawaited(h.controller.start());
    await _settle(tester);

    expect(h.controller.status, StartupStatus.ready);
    expect(permissionRequests, 1);
    h.controller.dispose();
  });

  testWidgets('a failing background task is reported but does not fail '
      'startup', (tester) async {
    final h = _Harness();
    h.backgroundTasks['ads'] = () => throw StateError('ads');

    unawaited(h.controller.start());
    await _settle(tester);

    expect(h.controller.status, StartupStatus.ready);
    expect(h.reported.single, isStateError);
    h.controller.dispose();
  });

  testWidgets('the deadline shows the retry state after 20s, not before', (
    tester,
  ) async {
    final h = _Harness();
    h.initialize = (_) => Completer<void>().future;

    unawaited(h.controller.start());
    await tester.pump(const Duration(seconds: 19));
    expect(h.controller.status, StartupStatus.loading);

    await tester.pump(const Duration(seconds: 2));
    expect(h.controller.status, StartupStatus.failed);
    expect(h.reported.single, isA<TimeoutException>());
    h.controller.dispose();
  });

  testWidgets('a slow init that succeeds after the deadline recovers by '
      'itself', (tester) async {
    final h = _Harness();
    final gate = Completer<void>();
    h.initialize = (_) => gate.future;

    unawaited(h.controller.start());
    await tester.pump(const Duration(seconds: 21));
    expect(h.controller.status, StartupStatus.failed);

    gate.complete();
    await _settle(tester);

    expect(h.controller.status, StartupStatus.ready);
    h.controller.dispose();
  });

  testWidgets('a slow auth check that answers after the deadline recovers by '
      'itself', (tester) async {
    final h = _Harness();
    h.auth.currentUser = () => Future.delayed(
      const Duration(seconds: 25),
      signedOut,
    );

    unawaited(h.controller.start());
    await _settle(tester);
    await tester.pump(const Duration(seconds: 21));
    expect(h.controller.status, StartupStatus.failed);

    await tester.pump(const Duration(seconds: 5));
    await _settle(tester);

    expect(h.controller.status, StartupStatus.ready);
    h.controller.dispose();
  });

  testWidgets('retry joins in-flight init and the older run is ignored', (
    tester,
  ) async {
    final h = _Harness();
    final gate = Completer<void>();
    var supabaseRuns = 0;
    h.initialize = (steps) => steps.runOnce('supabase', () {
      supabaseRuns++;
      return gate.future;
    });

    unawaited(h.controller.start());
    await tester.pump(const Duration(seconds: 21));
    unawaited(h.controller.start());
    await _settle(tester);
    expect(h.controller.status, StartupStatus.loading);

    gate.complete();
    await _settle(tester);

    expect(h.controller.status, StartupStatus.ready);
    expect(supabaseRuns, 1);
    expect(h.createdBlocs, hasLength(1));
    h.controller.dispose();
  });

  testWidgets('retry replaces a stuck AuthBloc with a fresh one', (
    tester,
  ) async {
    final h = _Harness()..auth.currentUser = hungAuth;

    unawaited(h.controller.start());
    await _settle(tester);
    await tester.pump(const Duration(seconds: 21));
    expect(h.controller.status, StartupStatus.failed);

    h.auth.currentUser = signedOut;
    unawaited(h.controller.start());
    await _settle(tester);

    expect(h.controller.status, StartupStatus.ready);
    expect(h.createdBlocs, hasLength(2));
    expect(h.controller.authBloc, same(h.createdBlocs.last));
    expect(_closeRequested(h.createdBlocs.first), isTrue);
    expect(_closeRequested(h.createdBlocs.last), isFalse);
    await _settle(tester);
    h.controller.dispose();
  });

  testWidgets('an auth check that throws is covered by the deadline and '
      'retry', (tester) async {
    final h = _Harness();
    h.auth.currentUser = () async =>
        throw const CacheException(message: 'keystore');

    unawaited(h.controller.start());
    await _settle(tester);
    await tester.pump(const Duration(seconds: 21));

    expect(h.uncaught.single, isA<CacheException>());
    expect(h.controller.status, StartupStatus.failed);

    h.auth.currentUser = signedOut;
    unawaited(h.controller.start());
    await _settle(tester);

    expect(h.controller.status, StartupStatus.ready);
    h.controller.dispose();
  });

  testWidgets('time spent after ready (soft update dialog) never trips the '
      'deadline', (tester) async {
    final h = _Harness();

    unawaited(h.controller.start());
    await _settle(tester);
    await tester.pump(const Duration(minutes: 1));

    expect(h.controller.status, StartupStatus.ready);
    expect(h.reported, isEmpty);
    h.controller.dispose();
  });

  testWidgets('start after ready keeps the AuthBloc that was handed off', (
    tester,
  ) async {
    final h = _Harness();

    unawaited(h.controller.start());
    await _settle(tester);
    unawaited(h.controller.start());
    await _settle(tester);

    expect(h.createdBlocs, hasLength(1));
    expect(_closeRequested(h.createdBlocs.single), isFalse);
    await _settle(tester);
    h.controller.dispose();
  });

  testWidgets('a throwing error reporter does not stop the retry state', (
    tester,
  ) async {
    final h = _Harness();
    final controller = StartupController(
      initialize: (_) async => throw StateError('boom'),
      createAuthBloc: () => buildAuthBloc(h.auth),
      resolveUpdateCubit: () => h.updateCubit,
      backgroundTasks: const {},
      reportError: (_, _) => throw StateError('reporter'),
    );

    unawaited(controller.start());
    await _settle(tester);

    expect(controller.status, StartupStatus.failed);
    controller.dispose();
  });
}
