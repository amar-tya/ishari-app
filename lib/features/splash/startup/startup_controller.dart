import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/splash/startup/startup_steps.dart';
import 'package:ishari/features/update/presentation/cubit/update_cubit.dart';

enum StartupStatus {
  /// Still working: keep showing the splash.
  loading,

  /// An error, or the deadline passed: show the retry screen. A run that is
  /// still in flight can move on to [ready] from here.
  failed,

  /// Init, auth check and update check are done. Final.
  ready,
}

typedef StartupErrorReporter = void Function(Object error, StackTrace stack);

/// Drives everything the splash waits for.
///
/// [start] may be called again to retry. Only the newest call can change
/// [status]; work it shares with older calls is joined through
/// [StartupSteps].
class StartupController extends ChangeNotifier {
  StartupController({
    required Future<void> Function(StartupSteps steps) initialize,
    required AuthBloc Function() createAuthBloc,
    required UpdateCubit Function() resolveUpdateCubit,
    required Map<String, Future<void> Function()> backgroundTasks,
    required StartupErrorReporter reportError,
    this.deadline = const Duration(seconds: 20),
  }) : _initialize = initialize,
       _createAuthBloc = createAuthBloc,
       _resolveUpdateCubit = resolveUpdateCubit,
       _backgroundTasks = backgroundTasks,
       _reportError = reportError;

  final Future<void> Function(StartupSteps steps) _initialize;
  final AuthBloc Function() _createAuthBloc;
  final UpdateCubit Function() _resolveUpdateCubit;
  final Map<String, Future<void> Function()> _backgroundTasks;
  final StartupErrorReporter _reportError;

  /// How long the splash may stay before the retry screen is offered. It only
  /// covers machine work: [backgroundTasks] (which may open system dialogs)
  /// are never awaited, and the timer stops once [status] is
  /// [StartupStatus.ready].
  final Duration deadline;

  final _steps = StartupSteps();
  final Set<String> _startedTasks = {};

  StartupStatus _status = StartupStatus.loading;
  StartupStatus get status => _status;

  AuthBloc? _authBloc;

  /// Non-null once [status] is [StartupStatus.ready].
  AuthBloc? get authBloc => _authBloc;

  UpdateCubit? _updateCubit;

  /// Non-null once [status] is [StartupStatus.ready].
  UpdateCubit? get updateCubit => _updateCubit;

  int _run = 0;
  bool _disposed = false;
  Timer? _deadlineTimer;
  StreamSubscription<AuthState>? _authSub;
  StreamSubscription<UpdateState>? _updateSub;

  bool _isStale(int run) => _disposed || run != _run;

  Future<void> start() async {
    if (_disposed || _status == StartupStatus.ready) return;
    final run = ++_run;
    _discardPreviousRun();
    _setStatus(StartupStatus.loading);
    _deadlineTimer = Timer(deadline, () => _onDeadline(run));

    try {
      await _initialize(_steps);
      if (_isStale(run)) return;
      _watchAuthAndUpdate(run);
      _startBackgroundTasks();
    } on Object catch (error, stack) {
      if (_isStale(run)) return;
      _deadlineTimer?.cancel();
      _report(error, stack);
      _setStatus(StartupStatus.failed);
    }
  }

  void _watchAuthAndUpdate(int run) {
    final authBloc = _authBloc = _createAuthBloc();
    _authSub = authBloc.stream.listen((_) => _checkReady(run));
    authBloc.add(const AuthEvent.checkAuthStatus());

    final updateCubit = _updateCubit = _resolveUpdateCubit();
    _updateSub = updateCubit.stream.listen((_) => _checkReady(run));
    final notStarted = updateCubit.state.maybeWhen(
      initial: () => true,
      orElse: () => false,
    );
    if (notStarted) unawaited(updateCubit.check());

    // Catch states that were already resolved before we listened.
    _checkReady(run);
  }

  void _checkReady(int run) {
    if (_isStale(run) || _status == StartupStatus.ready) return;
    final authResolved = _authBloc!.state.maybeWhen(
      initial: () => false,
      loading: () => false,
      orElse: () => true,
    );
    final updateResolved = _updateCubit!.state.maybeWhen(
      initial: () => false,
      checking: () => false,
      orElse: () => true,
    );
    if (!authResolved || !updateResolved) return;
    _deadlineTimer?.cancel();
    _cancelSubscriptions();
    _setStatus(StartupStatus.ready);
  }

  /// Each task is attempted once per app launch, even if it failed: running
  /// one again could register its listeners twice.
  void _startBackgroundTasks() {
    for (final MapEntry(key: name, value: task) in _backgroundTasks.entries) {
      if (!_startedTasks.add(name)) continue;
      unawaited(_runBackgroundTask(task));
    }
  }

  Future<void> _runBackgroundTask(Future<void> Function() task) async {
    try {
      await task();
    } on Object catch (error, stack) {
      _report(error, stack);
    }
  }

  void _onDeadline(int run) {
    if (_isStale(run) || _status != StartupStatus.loading) return;
    // The run stays current: if it finishes late, it still gets to the app.
    _report(
      TimeoutException(
        _authBloc == null
            ? 'Startup deadline passed during initialization'
            : 'Startup deadline passed waiting for auth/update check '
                  '(auth: ${_authBloc!.state.runtimeType}, '
                  'update: ${_updateCubit?.state.runtimeType})',
        deadline,
      ),
      StackTrace.current,
    );
    _setStatus(StartupStatus.failed);
  }

  void _discardPreviousRun() {
    _deadlineTimer?.cancel();
    _cancelSubscriptions();
    // A stuck AuthBloc would stay in `loading`, so each run builds its own.
    final previous = _authBloc;
    _authBloc = null;
    if (previous != null) unawaited(previous.close());
  }

  void _cancelSubscriptions() {
    unawaited(_authSub?.cancel());
    unawaited(_updateSub?.cancel());
    _authSub = null;
    _updateSub = null;
  }

  void _report(Object error, StackTrace stack) {
    try {
      _reportError(error, stack);
    } on Object catch (_) {
      // Reporting must never keep the user from the retry screen.
    }
  }

  void _setStatus(StartupStatus status) {
    if (_status == status) return;
    _status = status;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _deadlineTimer?.cancel();
    _cancelSubscriptions();
    super.dispose();
  }
}
