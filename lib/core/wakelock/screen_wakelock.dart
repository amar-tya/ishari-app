import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

typedef WakelockToggle = Future<void> Function({required bool enable});

/// Reference-counted access to the device wakelock.
///
/// The platform wakelock is a single on/off switch, while several readers can
/// be alive at once (one pushed over another). It stays on while at least one
/// of them holds it. Widgets should use `KeepScreenOn` instead of this.
class ScreenWakelock {
  ScreenWakelock({WakelockToggle toggle = WakelockPlus.toggle})
    : _toggle = toggle;

  /// The instance shared by the whole app. Replaceable in tests.
  static ScreenWakelock instance = ScreenWakelock();

  final WakelockToggle _toggle;
  int _holders = 0;

  void acquire() {
    _holders++;
    if (_holders == 1) unawaited(_apply(enable: true));
  }

  void release() {
    if (_holders == 0) return;
    _holders--;
    if (_holders == 0) unawaited(_apply(enable: false));
  }

  Future<void> _apply({required bool enable}) async {
    try {
      await _toggle(enable: enable);
    } on Object catch (error) {
      // Keeping the screen on is a convenience; never break the reader.
      debugPrint('Wakelock toggle($enable) failed: $error');
    }
  }
}
