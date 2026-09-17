import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';

/// Remote kill-switch for shipping features that need a fast off-switch
/// without a Shorebird patch or Play Store release. Keys are read as
/// booleans; unset/unfetched keys fall back to [defaultValue] so a flag
/// check never throws or blocks on network state.
@lazySingleton
class FeatureFlagsService {
  FeatureFlagsService() : _remoteConfig = FirebaseRemoteConfig.instance;

  final FirebaseRemoteConfig _remoteConfig;

  /// Fetches and activates the latest flag values. Safe to call without
  /// awaiting at startup — until it completes, [isEnabled] serves cached
  /// values from the previous fetch (or [defaultValue] on first-ever run).
  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    try {
      await _remoteConfig.fetchAndActivate();
    } catch (_) {
      // Network/quota failure — keep whatever was cached from a previous
      // fetch (or defaults on first run). A flag check must never crash.
    }
  }

  bool isEnabled(String key, {bool defaultValue = false}) {
    if (!_remoteConfig.getAll().containsKey(key)) return defaultValue;
    return _remoteConfig.getBool(key);
  }
}
