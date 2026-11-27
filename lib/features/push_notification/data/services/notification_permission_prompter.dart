import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/features/push_notification/data/services/push_messaging_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _countKey = 'notification_prompt_count';
const _lastShownKey = 'notification_prompt_last_shown_ms';
const _declinedKey = 'notification_prompt_declined';

/// Decides when the app may offer to turn on notifications, and remembers how
/// often it has. State is per device, shared by guests and signed-in users.
@lazySingleton
class NotificationPermissionPrompter {
  NotificationPermissionPrompter(this._messaging, this._prefs);

  /// Showings over the life of the install.
  static const maxPrompts = 2;

  /// Minimum time between two showings.
  static const minInterval = Duration(days: 14);

  final PushMessagingClient _messaging;
  final SharedPreferences _prefs;

  @visibleForTesting
  DateTime Function() clock = DateTime.now;

  bool _busy = false;

  /// Claims the single prompt slot, so that two screens cannot both show one.
  /// Every successful call needs a [release].
  bool tryAcquire() {
    if (_busy) return false;
    _busy = true;
    return true;
  }

  void release() => _busy = false;

  Future<bool> shouldPrompt() async {
    if (_prefs.getBool(_declinedKey) ?? false) return false;
    if ((_prefs.getInt(_countKey) ?? 0) >= maxPrompts) return false;

    final lastShown = _prefs.getInt(_lastShownKey);
    if (lastShown != null) {
      final since = clock().difference(
        DateTime.fromMillisecondsSinceEpoch(lastShown),
      );
      if (since < minInterval) return false;
    }

    // Read live: this covers installs that granted it before the app kept any
    // prompt state, and changes made in system settings.
    final status = await _messaging.permissionStatus();
    if (_isGranted(status)) return false;
    // Apple platforms ask only once. Android reports `denied` before the first
    // request too, so it cannot be used the same way there.
    final asksOnce =
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
    return !asksOnce || status == AuthorizationStatus.notDetermined;
  }

  Future<void> recordShown() async {
    await _prefs.setInt(_countKey, (_prefs.getInt(_countKey) ?? 0) + 1);
    await _prefs.setInt(_lastShownKey, clock().millisecondsSinceEpoch);
  }

  /// Runs the system request after the user accepted our explanation. Returns
  /// whether notifications are now allowed; if not, the user is not offered
  /// them again.
  Future<bool> requestPermission() async {
    final granted = _isGranted(await _messaging.requestPermission());
    if (!granted) await _prefs.setBool(_declinedKey, true);
    return granted;
  }

  bool _isGranted(AuthorizationStatus status) =>
      status == AuthorizationStatus.authorized ||
      status == AuthorizationStatus.provisional;
}
