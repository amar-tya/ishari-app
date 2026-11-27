import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishari/core/app_loader.dart';
import 'package:ishari/features/splash/presentation/widgets/loading_bar.dart';
import 'package:ishari/features/splash/presentation/widgets/startup_error_view.dart';
import 'package:ishari/features/splash/startup/startup_controller.dart';

import 'startup_fakes.dart';

/// Only the splash / retry screen is covered here: leaving the splash builds
/// the real app, which needs Firebase and Supabase.
StartupController _controller(Future<void> Function() initialize) =>
    StartupController(
      initialize: (_) => initialize(),
      createAuthBloc: () => buildAuthBloc(FakeAuthRepository()),
      resolveUpdateCubit: () => buildUpdateCubit(FakeUpdateRepository()),
      backgroundTasks: const {},
      reportError: (_, _) {},
    );

void main() {
  testWidgets('an init error swaps the splash for the retry screen, and retry '
      'goes back to the splash', (tester) async {
    var attempts = 0;
    final controller = _controller(() {
      attempts++;
      if (attempts == 1) throw StateError('boom');
      return Completer<void>().future;
    });

    await tester.pumpWidget(AppLoader(controller: controller));
    await tester.pump(const Duration(seconds: 2));

    expect(find.byType(StartupErrorView), findsOneWidget);
    expect(find.byType(LoadingBarWidget), findsNothing);

    await tester.tap(find.text('Coba Lagi'));
    await tester.pump(const Duration(milliseconds: 10));

    expect(attempts, 2);
    expect(find.byType(StartupErrorView), findsNothing);
    expect(find.byType(LoadingBarWidget), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('a hung init shows the retry screen after the deadline', (
    tester,
  ) async {
    final controller = _controller(() => Completer<void>().future);

    await tester.pumpWidget(AppLoader(controller: controller));
    await tester.pump(const Duration(seconds: 19));
    expect(find.byType(StartupErrorView), findsNothing);

    await tester.pump(const Duration(seconds: 2));
    expect(find.byType(StartupErrorView), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
  });
}
