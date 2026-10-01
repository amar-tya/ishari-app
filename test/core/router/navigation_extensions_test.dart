import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ishari/core/router/navigation_extensions.dart';

void main() {
  Widget buildPage(String label) {
    return Builder(
      builder: (context) => Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () => context.popOrHome(),
            child: Text(label),
          ),
        ),
      ),
    );
  }

  GoRouter buildRouter(String initialLocation) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(path: '/home', builder: (_, _) => buildPage('home')),
        GoRoute(path: '/audio', builder: (_, _) => buildPage('audio')),
      ],
    );
  }

  group('popOrHome', () {
    testWidgets('falls back to /home when the stack has nothing to pop', (
      tester,
    ) async {
      // Deep-link entry: /audio is the only page in the stack, so a bare
      // context.pop() here would throw "GoError: There is nothing to pop".
      final router = buildRouter('/audio');
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      expect(find.text('audio'), findsOneWidget);

      await tester.tap(find.text('audio'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('home'), findsOneWidget);
    });

    testWidgets('pops normally when a page sits underneath', (tester) async {
      final router = buildRouter('/home');
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));

      router.push<void>('/audio');
      await tester.pumpAndSettle();
      expect(find.text('audio'), findsOneWidget);

      await tester.tap(find.text('audio'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('home'), findsOneWidget);
      expect(router.canPop(), isFalse);
    });
  });
}
