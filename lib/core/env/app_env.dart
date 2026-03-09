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

  static const String _env = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  static bool get isDevelopment => _env == 'development';
  static bool get isProduction => _env == 'production';

  // ---------------------------------------------------------------------------
  // Supabase
  // ---------------------------------------------------------------------------

  /// Supabase project URL.
  /// Example: https://xxxxxxxxxxxx.supabase.co
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');

  /// Supabase anonymous/public key.
  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');

  // ---------------------------------------------------------------------------
  // Google Sign-In
  // ---------------------------------------------------------------------------

  /// Google OAuth Web Client ID for native sign-in.
  /// Used as serverClientId for GoogleSignIn to obtain idToken.
  static const String googleWebClientId =
      String.fromEnvironment('GOOGLE_WEB_CLIENT_ID');

  // ---------------------------------------------------------------------------
  // Validation
  // ---------------------------------------------------------------------------

  /// Throws [StateError] if any required env variable is missing.
  /// Call once at app startup before using any env values.
  static void validate() {
    final missing = <String>[];

    if (supabaseUrl.isEmpty) missing.add('SUPABASE_URL');
    if (supabaseAnonKey.isEmpty) missing.add('SUPABASE_ANON_KEY');
    if (googleWebClientId.isEmpty) missing.add('GOOGLE_WEB_CLIENT_ID');

    if (missing.isNotEmpty) {
      throw StateError(
        'Missing required environment variables: ${missing.join(', ')}.\n'
        'Run with: flutter run --dart-define-from-file=env/dev.json',
      );
    }
  }
}
