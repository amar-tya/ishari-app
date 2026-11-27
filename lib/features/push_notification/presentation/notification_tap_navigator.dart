import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/router/app_router.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_list_bloc.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_list_event.dart';
import 'package:ishari/features/audio/presentation/pages/audio_list_page.dart';
import 'package:ishari/features/auth/presentation/pages/home_page.dart';
import 'package:ishari/features/introduction/presentation/pages/introduction_page.dart';
import 'package:ishari/features/update/presentation/pages/force_update_page.dart';

/// Opens the target of a tapped notification on top of whatever is on screen.
///
/// A tap can come before the app can show its target: the splash is still up,
/// or the user has to get past the introduction first. The latest such target
/// is held, in memory only, until the router is there.
@lazySingleton
class NotificationTapNavigator {
  NotificationTapNavigator(this._audioList);

  final AudioListBloc _audioList;
  String? _pending;

  /// The router delegate being watched while [_pending] cannot be opened yet.
  Listenable? _watched;
  bool _scheduled = false;
  bool _disposed = false;

  void open(String path) {
    if (_disposed) return;
    _pending = path;
    _schedule();
    // The app may be idle, with no frame on the way.
    if (rootNavigatorKey.currentContext != null) {
      WidgetsBinding.instance.ensureVisualUpdate();
    }
  }

  /// Delivery runs after a frame, never inside a router notification: whatever
  /// caused it (a redirect followed by `go('/home')`, say) may still be
  /// navigating and would throw the target away.
  void _schedule() {
    if (_scheduled || _disposed || _pending == null) return;
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      _deliver();
    });
  }

  void _deliver() {
    final path = _pending;
    if (_disposed || path == null) return;

    final context = rootNavigatorKey.currentContext;
    final router = context == null || !context.mounted
        ? null
        : GoRouter.maybeOf(context);
    if (router == null) {
      // Look again after the next frame, without asking for one: the frame
      // that mounts the router will come by itself.
      _schedule();
      return;
    }

    final configuration = router.routerDelegate.currentConfiguration;
    if (configuration.isEmpty) {
      _waitFor(router);
      return;
    }
    final last = configuration.matches.last;
    final top = last is ImperativeRouteMatch
        ? last.matches.uri
        : configuration.uri;

    if (top.path == IntroductionPage.routePath) {
      _waitFor(router);
      return;
    }

    // A dead end: nothing may be opened over it.
    if (top.path == ForceUpdatePage.routePath) {
      _forget();
      return;
    }

    final target = Uri.parse(path);
    final samePage = top.path == target.path;
    // The audio list is the exception: opening it again reloads it.
    if (samePage &&
        target.path != AudioListPage.routePath &&
        top.query == target.query) {
      _forget();
      return;
    }

    // Back from the target has to lead to home. `go` takes effect later, so the
    // target stays held until the router reports the new stack.
    if (configuration.matches.first.matchedLocation != HomePage.routePath) {
      _waitFor(router);
      router.go(HomePage.routePath);
      return;
    }

    _forget();
    // The list already loaded may predate the recording being announced. This
    // has to be added before the page asks for its own, cached, load.
    if (target.path == AudioListPage.routePath) {
      _audioList.add(
        const AudioListEvent.loadAll(
          forceRefresh: true,
          keepListOnFailure: true,
        ),
      );
    }
    // Apart from the reset above, no page below the top one is removed to reach
    // the target. The top page is replaced only for a newer version of itself.
    // That does not protect what it holds: its state, and any sheet or dialog
    // opened over it, go with it.
    if (samePage) {
      router.pushReplacement<void>(path).ignore();
    } else {
      router.push<void>(path).ignore();
    }
  }

  void _forget() {
    _pending = null;
    _stopWaiting();
  }

  void _waitFor(GoRouter router) {
    final delegate = router.routerDelegate;
    if (identical(_watched, delegate)) return;
    _stopWaiting();
    _watched = delegate..addListener(_schedule);
  }

  void _stopWaiting() {
    _watched?.removeListener(_schedule);
    _watched = null;
  }

  @disposeMethod
  void dispose() {
    _disposed = true;
    _pending = null;
    _stopWaiting();
  }
}
