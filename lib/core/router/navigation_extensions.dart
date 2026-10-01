import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:ishari/features/auth/presentation/pages/home_page.dart';

/// Safe back-navigation helpers for in-app back buttons.
extension SafeNavigationX on BuildContext {
  /// Pops the current route, or falls back to [HomePage] when there is
  /// nothing to pop.
  ///
  /// A bare `context.pop()` throws `GoError: There is nothing to pop` whenever
  /// the current page is the only entry in the stack. That happens on every
  /// deep-link entry: `GoRouter.go()` (used by the FCM notification-tap
  /// handler and by `initialLocation` on cold start) *replaces* the stack
  /// instead of pushing onto it, so a page opened that way has no page
  /// underneath it — yet it still renders its own back button.
  ///
  /// Use this for any back button on a route that can be reached by deep link.
  void popOrHome() {
    final router = GoRouter.of(this);
    if (router.canPop()) {
      router.pop();
    } else {
      router.go(HomePage.routePath);
    }
  }
}
