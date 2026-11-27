import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/analytics/analytics_service.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/usecases/usecase.dart';
import 'package:ishari/core/utils/app_logger.dart';
import 'package:ishari/features/auth/domain/entities/user_entity.dart';
import 'package:ishari/features/auth/domain/usecases/get_current_user.dart';
import 'package:ishari/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:ishari/features/auth/domain/usecases/sign_out.dart';
import 'package:ishari/features/auth/domain/usecases/watch_auth_state.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    this._signInWithGoogle,
    this._signOut,
    this._getCurrentUser,
    this._analytics,
    WatchAuthState watchAuthState,
  ) : super(const AuthState.initial()) {
    on<_CheckAuthStatus>(_onCheckAuthStatus);
    on<_SignInWithGoogle>(_onSignInWithGoogle);
    on<_SignOut>(_onSignOut);
    on<_AuthUserChanged>(_onAuthUserChanged);
    _authSubscription = watchAuthState().listen(
      (user) => add(AuthEvent.authUserChanged(user)),
      // E.g. a token refresh without a network: the SDK keeps the session and
      // retries. Losing the session arrives as a null user, not as an error.
      onError: (Object error, StackTrace stackTrace) => appLogger.w(
        '[Auth] Auth stream error',
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }

  late final StreamSubscription<UserEntity?> _authSubscription;

  /// Whether a session was seen since the user last signed in or out on
  /// purpose. Tells a lost session apart from never having had one.
  bool _sawSession = false;

  /// Whether the latest value from the SDK stream was "no session".
  bool _streamSignedOut = false;

  bool _sessionExpiredNotice = false;

  /// True once after the session ended without the user asking for it, so the
  /// UI can explain why they were signed out.
  bool takeSessionExpiredNotice() {
    final pending = _sessionExpiredNotice;
    _sessionExpiredNotice = false;
    return pending;
  }

  final SignInWithGoogle _signInWithGoogle;
  final SignOut _signOut;
  final GetCurrentUser _getCurrentUser;
  final AnalyticsService _analytics;

  Future<void> _onCheckAuthStatus(
    _CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _getCurrentUser(const NoParams());
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (user) {
        if (user != null) _sawSession = true;
        // The session may have ended while the check was pending: its result
        // is then out of date.
        if (user != null && !_streamSignedOut) {
          emit(AuthState.authenticated(user));
          return;
        }
        if (_streamSignedOut && _sawSession) _raiseSessionExpiredNotice();
        emit(const AuthState.unauthenticated());
      },
    );
  }

  /// Only an authenticated state follows the SDK. The other states belong to a
  /// startup check, sign-in or sign-out that reports its own result.
  void _onAuthUserChanged(
    _AuthUserChanged event,
    Emitter<AuthState> emit,
  ) {
    final user = event.user;
    _streamSignedOut = user == null;
    if (user != null) _sawSession = true;

    final current = state.maybeWhen(
      authenticated: (user) => user,
      orElse: () => null,
    );
    if (current == null) return;

    if (user == null) {
      _raiseSessionExpiredNotice();
      emit(const AuthState.unauthenticated());
    } else if (user != current) {
      emit(AuthState.authenticated(user));
    }
  }

  void _raiseSessionExpiredNotice() {
    _sawSession = false;
    _sessionExpiredNotice = true;
  }

  /// The user is signing in or out on purpose: nothing before this is news.
  void _forgetSession() {
    _sawSession = false;
    _sessionExpiredNotice = false;
  }

  Future<void> _onSignInWithGoogle(
    _SignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    _forgetSession();
    emit(const AuthState.loading());
    final result = await _signInWithGoogle(const NoParams());
    result.fold(
      (failure) => failure is CanceledFailure
          ? emit(const AuthState.unauthenticated())
          : emit(AuthState.error(failure.message)),
      (user) {
        emit(AuthState.authenticated(user));
        unawaited(_analytics.logLogin());
      },
    );
  }

  Future<void> _onSignOut(
    _SignOut event,
    Emitter<AuthState> emit,
  ) async {
    _forgetSession();
    emit(const AuthState.loading());
    final result = await _signOut(const NoParams());
    result.fold(
      (failure) => emit(AuthState.error(failure.message)),
      (_) => emit(const AuthState.unauthenticated()),
    );
  }

  @override
  Future<void> close() {
    // No events arrive once cancel() is called. Closing must not also wait for
    // the source to finish: the startup retry relies on it to retire a bloc.
    unawaited(_authSubscription.cancel());
    return super.close();
  }
}
