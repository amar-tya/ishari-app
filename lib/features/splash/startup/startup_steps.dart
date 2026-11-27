import 'dart:async';

import 'package:get_it/get_it.dart';

/// Makes startup safe to run more than once (the retry button).
///
/// A step that succeeded is never run again, a step that is still running is
/// joined instead of started a second time, and a step that failed can run
/// again.
class StartupSteps {
  final Map<String, Future<void>> _steps = {};

  Future<void> runOnce(String name, Future<void> Function() step) =>
      _steps[name] ??= _run(name, step);

  Future<void> _run(String name, Future<void> Function() step) async {
    // Yield first so the future is cached before a synchronous throw from
    // [step] tries to remove it.
    await null;
    try {
      await step();
    } catch (_) {
      unawaited(_steps.remove(name));
      rethrow;
    }
  }
}

/// Runs a dependency registration and empties [locator] if it fails, so the
/// next attempt does not hit "type is already registered".
///
/// Only use this for the first registration on [locator]: a failure removes
/// everything in it.
Future<void> registerWithRollback(
  GetIt locator,
  Future<void> Function() register,
) async {
  try {
    await register();
  } catch (_) {
    await locator.reset();
    rethrow;
  }
}
