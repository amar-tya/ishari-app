import 'package:ishari/core/env/env.dart';

/// App environment configuration.
///
/// Values are injected at build time via `--dart-define-from-file`.
///
/// Run dev:  `flutter run --dart-define-from-file=env/dev.json`
/// Run prod: `flutter build apk --dart-define-from-file=env/prod.json`
abstract final class AppEnv {
  // ---------------------------------------------------------------------------
  // Environment identifier
  // ---------------------------------------------------------------------------

  static bool get isDevelopment => Env.appEnv == 'development';
  static bool get isProduction => Env.appEnv == 'production';

  // ---------------------------------------------------------------------------
  // Supabase
  // ---------------------------------------------------------------------------

  /// Supabase project URL.
  /// Example: https://xxxxxxxxxxxx.supabase.co
  static String get supabaseUrl => Env.supabaseUrl;

  /// Supabase anonymous/public key.
  static String get supabaseAnonKey => Env.supabaseAnonKey;

  // ---------------------------------------------------------------------------
  // Google Sign-In
  // ---------------------------------------------------------------------------

  /// Google OAuth Web Client ID for native sign-in.
  /// Used as serverClientId for GoogleSignIn to obtain idToken.
  static String get googleWebClientId => Env.googleWebClientId;

  // ---------------------------------------------------------------------------
  // AdMob
  // ---------------------------------------------------------------------------

  /// AdMob Android App ID.
  static String get admobAppId => Env.admobAppId;

  /// AdMob Banner Ad Unit ID.
  static String get admobBannerUnitId => Env.admobBannerUnitId;

  /// AdMob Native Ad Unit ID.
  static String get admobNativeUnitId => Env.admobNativeUnitId;

  /// AdMob Interstitial Ad Unit ID.
  static String get admobInterstitialUnitId => Env.admobInterstitialUnitId;

  /// Test device IDs for AdMob (dev only).
  /// Comma-separated list from ADMOB_TEST_DEVICE_IDS in dev.env.
  /// Get your device ID from logcat after first run.
  static List<String> get admobTestDeviceIds {
    final raw = Env.admobTestDeviceIds?.trim() ?? '';
    if (raw.isEmpty) return [];
    return raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  // ---------------------------------------------------------------------------
  // Validation
  // ---------------------------------------------------------------------------

  /// Throws [StateError] if any required env variable is missing.
  /// Call once at app startup before using any env values.
  static void validate() {
    final missing = <String>[];

    if (Env.supabaseUrl.isEmpty) missing.add('SUPABASE_URL');
    if (Env.supabaseAnonKey.isEmpty) missing.add('SUPABASE_ANON_KEY');
    if (Env.googleWebClientId.isEmpty) missing.add('GOOGLE_WEB_CLIENT_ID');

    if (missing.isNotEmpty) {
      throw StateError(
        'Missing required environment variables: ${missing.join(', ')}.\n'
        'Run with: flutter run --dart-define-from-file=env/dev.json',
      );
    }
  }
}
