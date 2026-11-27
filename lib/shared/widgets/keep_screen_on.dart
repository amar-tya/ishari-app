import 'package:flutter/widgets.dart';
import 'package:ishari/core/router/app_router.dart';
import 'package:ishari/core/wakelock/screen_wakelock.dart';

/// Keeps the screen on while [child] is being read.
///
/// The wakelock is given up while the app is backgrounded, while another full
/// page covers this one, and when this widget is disposed. Bottom sheets and
/// dialogs do not count as covering the page.
class KeepScreenOn extends StatefulWidget {
  const KeepScreenOn({
    required this.child,
    this.wakelock,
    this.routeObserver,
    super.key,
  });

  final Widget child;

  /// Defaults to [ScreenWakelock.instance].
  final ScreenWakelock? wakelock;

  /// Defaults to [appRouteObserver].
  final RouteObserver<PageRoute<void>>? routeObserver;

  @override
  State<KeepScreenOn> createState() => _KeepScreenOnState();
}

class _KeepScreenOnState extends State<KeepScreenOn>
    with WidgetsBindingObserver, RouteAware {
  late final ScreenWakelock _wakelock =
      widget.wakelock ?? ScreenWakelock.instance;
  late final RouteObserver<PageRoute<void>> _routeObserver =
      widget.routeObserver ?? appRouteObserver;

  PageRoute<void>? _route;
  bool _covered = false;
  bool _backgrounded = false;
  bool _holding = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    _backgrounded = lifecycle != null && _isBackground(lifecycle);
    _sync();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute<void> && route != _route) {
      _routeObserver.unsubscribe(this);
      _route = route;
      _routeObserver.subscribe(this, route);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // `inactive` is still on screen (notification shade, system dialog).
    if (state == AppLifecycleState.inactive) return;
    _backgrounded = _isBackground(state);
    _sync();
  }

  @override
  void didPushNext() {
    _covered = true;
    _sync();
  }

  @override
  void didPopNext() {
    _covered = false;
    _sync();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _routeObserver.unsubscribe(this);
    if (_holding) _wakelock.release();
    super.dispose();
  }

  bool _isBackground(AppLifecycleState state) =>
      state == AppLifecycleState.hidden ||
      state == AppLifecycleState.paused ||
      state == AppLifecycleState.detached;

  void _sync() {
    final shouldHold = !_covered && !_backgrounded;
    if (shouldHold == _holding) return;
    _holding = shouldHold;
    if (shouldHold) {
      _wakelock.acquire();
    } else {
      _wakelock.release();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
