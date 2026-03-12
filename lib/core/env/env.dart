import 'package:envied/envied.dart';

part 'env.g.dart';

/// Environment configuration loaded from [env/current.json] at code-gen time.
///
/// Switch environment:
///   scripts\use_dev.bat    → copies env/dev.json  → env/current.json + runs build_runner
///   scripts\use_prod.bat   → copies env/prod.json → env/current.json + runs build_runner
///
/// After switching, just run `flutter run` — no --dart-define-from-file needed.
@Envied(path: 'env/current.env', obfuscate: true, useConstantCase: true)
abstract class Env {
  @EnviedField(defaultValue: 'development')
  static final String appEnv = _Env.appEnv;

  @EnviedField()
  static final String supabaseUrl = _Env.supabaseUrl;

  @EnviedField()
  static final String supabaseAnonKey = _Env.supabaseAnonKey;

  @EnviedField()
  static final String googleWebClientId = _Env.googleWebClientId;
}
