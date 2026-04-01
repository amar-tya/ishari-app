import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:ishari/injection_container.config.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  InternetConnection get internetConnection => InternetConnection();

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage(
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  @preResolve
  @singleton
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
}
