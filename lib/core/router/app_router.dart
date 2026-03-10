import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/auth/presentation/pages/home_page.dart';
import 'package:ishari/features/auth/presentation/pages/login_page.dart';

/// Application router powered by [GoRouter].
///
/// Redirect logic:
/// - Unauthenticated users are always sent to [LoginPage].
/// - Authenticated users trying to visit /login are redirected to [HomePage].
GoRouter createRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: LoginPage.routePath,
    refreshListenable: GoRouterAuthRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final isAuthenticated = authBloc.state.maybeWhen(
        authenticated: (_) => true,
        orElse: () => false,
      );
      final isOnLogin = state.matchedLocation == LoginPage.routePath;

      if (!isAuthenticated && !isOnLogin) return LoginPage.routePath;
      if (isAuthenticated && isOnLogin) return HomePage.routePath;
      return null;
    },
    routes: [
      GoRoute(
        path: LoginPage.routePath,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: HomePage.routePath,
        name: 'home',
        builder: (context, state) => const HomePage(),
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
