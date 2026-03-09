part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  /// Check if a user session already exists (app startup).
  const factory AuthEvent.checkAuthStatus() = _CheckAuthStatus;

  /// User tapped "Sign in with Google".
  const factory AuthEvent.signInWithGoogle() = _SignInWithGoogle;

  /// User tapped "Sign out".
  const factory AuthEvent.signOut() = _SignOut;
}
