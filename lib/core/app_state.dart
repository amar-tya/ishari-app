import 'package:flutter/foundation.dart';

/// Lightweight app-level state that lives outside the auth BLoC.
///
/// [isGuestMode] is used by the router to allow unauthenticated users who
/// explicitly chose "Continue as Guest" to access the home page.
class AppState {
  AppState._();

  static final ValueNotifier<bool> isGuestMode = ValueNotifier(false);

  /// True while `MainScaffold` (the 6-tab shell, mounted only at the
  /// `/home` route) is on screen — every other route pushes its own
  /// `Scaffold` with no floating pill nav bar. The global mini player reads
  /// this to know whether it needs extra bottom clearance to sit above that
  /// pill nav bar instead of overlapping it.
  static final ValueNotifier<bool> isMainScaffoldVisible = ValueNotifier(
    false,
  );
}
