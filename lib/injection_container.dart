import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:ishari/core/env/app_env.dart';
import 'package:ishari/injection_container.config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Global service locator instance.
final GetIt sl = GetIt.instance;

@InjectableInit(
  initializerName: 'initDependencies',
  preferRelativeImports: true,
  asExtension: false,
)

/// Registers all dependencies.
/// Call this once from [main] after Supabase is initialized.
Future<void> configureDependencies() async => initDependencies(sl);

/// Manual registrations for third-party objects that cannot
/// be annotated (external packages).
@module
abstract class RegisterModule {
  @lazySingleton
  SupabaseClient get supabaseClient => Supabase.instance.client;

  @lazySingleton
  GoogleSignIn get googleSignIn => GoogleSignIn(
        clientId: AppEnv.googleWebClientId,
        scopes: ['email', 'profile'],
      );

  @lazySingleton
  InternetConnection get internetConnection => InternetConnection();

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
        iOptions: IOSOptions(
          accessibility: KeychainAccessibility.first_unlock_this_device,
        ),
      );
}
