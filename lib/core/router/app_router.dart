import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ishari/core/analytics/analytics_service.dart';
import 'package:ishari/core/app_state.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/auth/presentation/pages/home_page.dart';
import 'package:ishari/features/introduction/presentation/pages/introduction_page.dart';
import 'package:ishari/features/muhud/presentation/pages/chapter_reader_page.dart';
import 'package:ishari/features/notifications/domain/entities/notification_entity.dart';
import 'package:ishari/features/notifications/presentation/pages/notification_detail_page.dart';
import 'package:ishari/features/notifications/presentation/pages/notifications_page.dart';
import 'package:ishari/features/tatanan/presentation/pages/tatanan_detail_page.dart';
import 'package:ishari/features/update/presentation/pages/force_update_page.dart';

/// Application router powered by [GoRouter].
///
/// [initialLocation] is determined by [AppLoader] after auth is resolved,
/// so no splash route is needed — GoRouter starts directly at the right page.
///
/// Redirect logic:
/// - Unauthenticated / non-guest users are sent to [IntroductionPage].
/// - Authenticated or guest users trying to visit introduction are redirected
///   to [HomePage].
GoRouter createRouter(
  AuthBloc authBloc,
  AnalyticsService analytics, {
  String initialLocation = HomePage.routePath,
}) {
  return GoRouter(
    initialLocation: initialLocation,
    observers: [analytics.observer],
    refreshListenable: Listenable.merge([
      GoRouterAuthRefreshStream(authBloc.stream),
      AppState.isGuestMode,
    ]),
    redirect: (context, state) {
      // Force-update manages its own navigation — never redirect away.
      if (state.matchedLocation == ForceUpdatePage.routePath) return null;

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
      GoRoute(
        path: TatananDetailPage.routePath,
        name: 'tatanan-detail',
        builder: (context, state) => TatananDetailPage(
          tatananId: state.pathParameters['tatananId']!,
        ),
      ),
      GoRoute(
        path: ForceUpdatePage.routePath,
        name: 'force-update',
        builder: (context, state) {
          final extra = state.extra as Map<String, String>?;
          return ForceUpdatePage(
            storeUrl: extra?['storeUrl'] ?? '',
            releaseNotes: extra?['releaseNotes'] ?? '',
          );
        },
      ),
      GoRoute(
        path: NotificationsPage.routePath,
        name: 'notifications',
        builder: (context, state) => const NotificationsPage(),
        routes: [
          GoRoute(
            path: ':id',
            name: 'notification-detail',
            builder: (context, state) {
              final notification = state.extra! as NotificationEntity;
              return NotificationDetailPage(notification: notification);
            },
          ),
        ],
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
