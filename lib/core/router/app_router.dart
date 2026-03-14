import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ishari/core/app_state.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/auth/presentation/pages/home_page.dart';
import 'package:ishari/features/introduction/presentation/pages/introduction_page.dart';
import 'package:ishari/features/muhud/presentation/pages/chapter_reader_page.dart';

/// Application router powered by [GoRouter].
///
/// Redirect logic:
/// - Unauthenticated / non-guest users are sent to [IntroductionPage].
/// - Authenticated or guest users trying to visit introduction are redirected
///   to [HomePage].
GoRouter createRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: IntroductionPage.routePath,
    refreshListenable: Listenable.merge([
      GoRouterAuthRefreshStream(authBloc.stream),
      AppState.isGuestMode,
    ]),
    redirect: (context, state) {
      final isAuthenticated = authBloc.state.maybeWhen(
        authenticated: (_) => true,
        orElse: () => false,
      );
      final hasAccess = isAuthenticated || AppState.isGuestMode.value;
      final isOnIntroduction =
          state.matchedLocation == IntroductionPage.routePath;

      if (!hasAccess && !isOnIntroduction) return IntroductionPage.routePath;
      if (hasAccess && isOnIntroduction) return HomePage.routePath;
      return null;
    },
    routes: [
      GoRoute(
        path: IntroductionPage.routePath,
        name: 'introduction',
        builder: (context, state) => const IntroductionPage(),
      ),
      GoRoute(
        path: HomePage.routePath,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: ChapterReaderPage.routePath,
        name: 'chapter-reader',
        builder: (context, state) {
          final chapterId = int.parse(state.pathParameters['chapterId'] ?? '0');
          return ChapterReaderPage(chapterId: chapterId);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
}

/// Bridges [AuthBloc] stream to [GoRouter]'s [Listenable] refresh mechanism.
class GoRouterAuthRefreshStream extends ChangeNotifier {
  GoRouterAuthRefreshStream(Stream<AuthState> stream) {
    notifyListeners();
    _sub = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthState> _sub;

  @override
  void dispose() {
    unawaited(_sub.cancel());
    super.dispose();
  }
}
