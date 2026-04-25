import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ishari/core/ads/interstitial_ad_manager.dart';
import 'package:ishari/core/analytics/analytics_service.dart';
import 'package:ishari/core/env/app_env.dart';
import 'package:ishari/core/router/app_router.dart';
import 'package:ishari/core/wizard/wizard_cubit.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:ishari/features/update/presentation/cubit/update_cubit.dart';
import 'package:ishari/firebase_options.dart';
import 'package:ishari/injection_container.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final packageInfo = await PackageInfo.fromPlatform();

  await SentryFlutter.init(
    (options) {
      options
        ..dsn = AppEnv.sentryDsn
        ..release = '${packageInfo.version}+${packageInfo.buildNumber}'
        ..environment =
            AppEnv.isDevelopment ? 'development' : 'production'
        // Only send events in production to avoid noise during development
        ..tracesSampleRate = AppEnv.isProduction ? 0.2 : 0.0
        // Richer native crash reports (stack traces, thread info, registers)
        ..enableTombstone = true;
    },
    appRunner: _appRunner,
  );
}

Future<void> _appRunner() async {
  // Prevent runtime font downloads — fonts are bundled in assets/fonts/
  GoogleFonts.config.allowRuntimeFetching = false;

  // 1. Validate all required env variables are present.
  AppEnv.validate();

  // 2. Initialize Firebase before any service that uses Analytics (incl. AdMob).
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Initialize Supabase using env values
  await Supabase.initialize(
    url: AppEnv.supabaseUrl,
    anonKey: AppEnv.supabaseAnonKey,
  );

  // 4. Register all dependencies via get_it + injectable
  await configureDependencies();
  sl.registerSingleton<WizardCubit>(WizardCubit(sl<FlutterSecureStorage>()));

  // 5. Initialize AdMob
  await MobileAds.instance.initialize();

  // Register test device IDs in development so real ad clicks are not counted.
  // Get your device ID from logcat on first run, then add to ADMOB_TEST_DEVICE_IDS in dev.env.
  if (AppEnv.isDevelopment) {
    final testIds = AppEnv.admobTestDeviceIds;
    if (testIds.isNotEmpty) {
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(testDeviceIds: testIds),
      );
    }
  }

  // Preload first interstitial
  InterstitialAdManager.instance.preload();

  // 6. Keep screen awake while app is running
  await WakelockPlus.enable();

  runApp(const IshariApp());
}

class IshariApp extends StatelessWidget {
  const IshariApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) =>
              sl<AuthBloc>()..add(const AuthEvent.checkAuthStatus()),
        ),
        BlocProvider<NotificationsBloc>.value(
          value: sl<NotificationsBloc>(),
        ),
        BlocProvider<UpdateCubit>.value(
          value: sl<UpdateCubit>(),
        ),
        BlocProvider<WizardCubit>.value(
          value: sl<WizardCubit>(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final router = createRouter(
            context.read<AuthBloc>(),
            sl<AnalyticsService>(),
          );
          return MaterialApp.router(
            title: 'Ishari',
            debugShowCheckedModeBanner: AppEnv.isDevelopment,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF51C878),
              ),
              useMaterial3: true,
            ),
            routerConfig: router,
          );
        },
      ),
    );
  }
}
