import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:ishari/features/splash/startup/startup_steps.dart';

void main() {
  group('StartupSteps.runOnce', () {
    test('does not run a succeeded step again', () async {
      final steps = StartupSteps();
      var runs = 0;

      await steps.runOnce('firebase', () async => runs++);
      await steps.runOnce('firebase', () async => runs++);

      expect(runs, 1);
    });

    test('a concurrent call joins the in-flight run', () async {
      final steps = StartupSteps();
      final gate = Completer<void>();
      var runs = 0;
      var secondDone = false;

      Future<void> step() {
        runs++;
        return gate.future;
      }

      final first = steps.runOnce('supabase', step);
      final second = steps
          .runOnce('supabase', step)
          .then((_) => secondDone = true);
      await Future<void>.delayed(Duration.zero);

      expect(runs, 1);
      expect(secondDone, isFalse);

      gate.complete();
      await Future.wait<void>([first, second]);
      expect(secondDone, isTrue);
    });

    test('a failed step can run again', () async {
      final steps = StartupSteps();
      var runs = 0;

      Future<void> step() async {
        runs++;
        if (runs == 1) throw StateError('boom');
      }

      await expectLater(steps.runOnce('di', step), throwsStateError);
      await steps.runOnce('di', step);

      expect(runs, 2);
    });

    test('a step that throws synchronously can run again', () async {
      final steps = StartupSteps();
      var runs = 0;

      Future<void> step() {
        runs++;
        if (runs == 1) throw StateError('boom');
        return Future<void>.value();
      }

      await expectLater(steps.runOnce('di', step), throwsStateError);
      await steps.runOnce('di', step);

      expect(runs, 2);
    });
  });

  group('registerWithRollback', () {
    test(
      'a retry after a partial registration does not double register',
      () async {
        final locator = GetIt.asNewInstance();
        var attempts = 0;

        Future<void> register() async {
          attempts++;
          locator.registerSingleton<String>('first');
          if (attempts == 1) throw StateError('half way');
          locator.registerSingleton<int>(2);
        }

        await expectLater(
          registerWithRollback(locator, register),
          throwsStateError,
        );
        expect(locator.isRegistered<String>(), isFalse);

        await registerWithRollback(locator, register);

        expect(locator<String>(), 'first');
        expect(locator<int>(), 2);
      },
    );
  });
}
