import 'package:flutter/foundation.dart';

/// Lightweight app-level state that lives outside the auth BLoC.
///
/// [isGuestMode] is used by the router to allow unauthenticated users who
/// explicitly chose "Continue as Guest" to access the home page.
class AppState {
  AppState._();

  static final ValueNotifier<bool> isGuestMode = ValueNotifier(false);
}
