part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  /// Initial state before any auth check.
  const factory AuthState.initial() = _Initial;

  /// Auth check / sign-in / sign-out in progress.
  const factory AuthState.loading() = _Loading;

  /// User is authenticated.
  const factory AuthState.authenticated(UserEntity user) = _Authenticated;

  /// No active session.
  const factory AuthState.unauthenticated() = _Unauthenticated;

  /// An error occurred.
  const factory AuthState.error(String message) = _Error;
}
