import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:ishari/core/app_state.dart';
import 'package:ishari/core/utils/app_logger.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keeps "Continue as Guest" across app restarts.
///
/// [AppState.isGuestMode] stays the one flag the rest of the app reads and
/// sets. This store only loads it once at startup and then saves every change,
/// so the places that set it do not have to know about storage.
///
/// Storage trouble never blocks the app: an unreadable value means "not a
/// guest" (the introduction), and a write that fails is dropped.
class GuestModeStore {
  GuestModeStore(this._prefs, {ValueNotifier<bool>? flag})
    : _flag = flag ?? AppState.isGuestMode;

  /// Absent means "not a guest", which is also what installs from before this
  /// existed have.
  @visibleForTesting
  static const key = 'guest_mode';

  final SharedPreferences _prefs;
  final ValueNotifier<bool> _flag;
  bool _started = false;

  /// Loads the saved flag, then starts saving changes to it. Does nothing the
  /// second time, so a startup retry cannot add a second listener.
  void start() {
    if (_started) return;
    _started = true;
    _flag.value = _read();
    // After the load: loading a value must not write it back.
    _flag.addListener(_save);
  }

  /// A signed-in session wins over a leftover guest flag. The two can meet when
  /// the app stopped between a sign-in and the guest flag being cleared. Any
  /// other state leaves the flag alone: the check may not be done, or may have
  /// failed, and that says nothing about the guest.
  void settle(AuthState authState) {
    final signedIn = authState.maybeWhen(
      authenticated: (_) => true,
      orElse: () => false,
    );
    if (signedIn && _flag.value) _flag.value = false;
  }

  bool _read() {
    try {
      return _prefs.getBool(key) ?? false;
    } on Object catch (error, stackTrace) {
      // A value of another type throws; anything unreadable is "not a guest".
      appLogger.w(
        '[Guest] Could not read the guest flag',
        error: error,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  void _save() {
    final guest = _flag.value;
    unawaited(_write(guest));
  }

  Future<void> _write(bool guest) async {
    try {
      if (guest) {
        await _prefs.setBool(key, true);
      } else {
        await _prefs.remove(key);
      }
    } on Object catch (error, stackTrace) {
      appLogger.w(
        '[Guest] Could not save the guest flag',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
