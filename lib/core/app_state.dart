import 'package:flutter/foundation.dart';

/// Lightweight app-level state that lives outside the auth BLoC.
///
/// [isGuestMode] is used by the router to allow unauthenticated users who
/// explicitly chose "Continue as Guest" to access the home page.
class AppState {
  AppState._();

  static final ValueNotifier<bool> isGuestMode = ValueNotifier(false);

  /// Set to a chapter ID to request the Muhud tab to open that chapter.
  /// The Muhud tab resets this to null once handled.
  static final ValueNotifier<int?> muhudChapterRequest = ValueNotifier(null);
}
