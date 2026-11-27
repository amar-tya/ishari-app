import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' hide AppState;
import 'package:ishari/app.dart';
import 'package:ishari/core/ads/interstitial_ad_manager.dart';
import 'package:ishari/core/app_state.dart';
import 'package:ishari/core/env/app_env.dart';
import 'package:ishari/core/feature_flags/feature_flags_service.dart';
import 'package:ishari/core/router/app_router.dart';
import 'package:ishari/core/wizard/wizard_cubit.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/auth/presentation/pages/home_page.dart';
import 'package:ishari/features/introduction/presentation/pages/introduction_page.dart';
import 'package:ishari/features/push_notification/data/services/fcm_service.dart';
import 'package:ishari/features/splash/presentation/widgets/book_logo_painter.dart';
import 'package:ishari/features/splash/presentation/widgets/loading_bar.dart';
import 'package:ishari/features/splash/presentation/widgets/startup_error_view.dart';
import 'package:ishari/features/splash/startup/startup_controller.dart';
import 'package:ishari/features/splash/startup/startup_steps.dart';
import 'package:ishari/features/update/presentation/cubit/update_cubit.dart';
import 'package:ishari/features/update/presentation/pages/force_update_page.dart';
import 'package:ishari/features/update/presentation/widgets/soft_update_dialog.dart';
import 'package:ishari/firebase_options.dart';
import 'package:ishari/injection_container.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
// Hide conflicting names exported by third-party packages.
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

const _bg = Color(0xFFF0F5EE);
const _dark = Color(0xFF111111);
const _muted = Color(0xFF777777);

/// Shown immediately on launch. Handles all heavy initialization while
/// displaying the branded splash UI, then swaps to [IshariApp] once ready.
/// If startup fails or takes too long it shows [StartupErrorView] instead.
class AppLoader extends StatefulWidget {
  const AppLoader({super.key, @visibleForTesting this.controller});

  /// Replaces the real startup sequence in tests.
  final StartupController? controller;

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  bool _minTimerElapsed = false;
  bool _navigating = false;

  late final StartupController _startup;

  Widget? _app;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      _minTimerElapsed = true;
      _tryNavigate();
    });
    _startup = widget.controller ?? _createStartupController();
    _startup.addListener(_tryNavigate);
    unawaited(_startup.start());
  }

  StartupController _createStartupController() => StartupController(
    initialize: _initialize,
    createAuthBloc: sl.get<AuthBloc>,
    resolveUpdateCubit: sl.get<UpdateCubit>,
    // Non-critical and never awaited — don't block splash. FCM init waits on
    // the notification permission dialog.
    backgroundTasks: {
      'ads': _initAds,
      'fcm': () => sl<FcmService>().init(),
      'feature_flags': () => sl<FeatureFlagsService>().initialize(),
    },
    reportError: _reportStartupError,
  );

  /// The critical part of startup. Safe to run again after a failure.
  Future<void> _initialize(StartupSteps steps) async {
    // FlutterError.onError (below) already reports to Crashlytics/Sentry
    // before this builder runs — it only supplies the replacement widget, so
    // users get a recoverable screen instead of Flutter's blank/grey
    // release-mode default on any uncaught build exception.
    ErrorWidget.builder = (details) {
      return Scaffold(
        backgroundColor: _bg,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Color(0xFF79747E),
                ),
                const SizedBox(height: 16),
                const Text('Terjadi kesalahan. Coba lagi.'),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    final ctx = rootNavigatorKey.currentContext;
                    if (ctx != null && ctx.mounted) {
                      GoRouter.of(ctx).go(HomePage.routePath);
                    }
                  },
                  child: const Text('Kembali ke Beranda'),
                ),
              ],
            ),
          ),
        ),
      );
    };

    GoogleFonts.config.allowRuntimeFetching = false;
    AppEnv.validate();

    await steps.runOnce(
      'firebase',
      () => Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
    );
    // Once only: a second pass would wrap the handlers again and report every
    // error twice.
    await steps.runOnce('crash_handlers', _installCrashHandlers);
    await steps.runOnce(
      'supabase',
      () => Supabase.initialize(
        url: AppEnv.supabaseUrl,
        anonKey: AppEnv.supabaseAnonKey,
      ),
    );
    await steps.runOnce(
      'dependencies',
      () => registerWithRollback(sl, () async {
        await configureDependencies();
        sl.registerSingleton<WizardCubit>(
          WizardCubit(sl<FlutterSecureStorage>()),
        );
      }),
    );
  }

  Future<void> _installCrashHandlers() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await FirebaseCrashlytics.instance
        .setCrashlyticsCollectionEnabled(!AppEnv.isDevelopment);
    final sentryFlutterErrorHandler = FlutterError.onError;
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      sentryFlutterErrorHandler?.call(errorDetails);
    };
    final sentryPlatformErrorHandler = PlatformDispatcher.instance.onError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      sentryPlatformErrorHandler?.call(error, stack);
      return true;
    };
  }

  Future<void> _initAds() async {
    await MobileAds.instance.initialize();
    if (AppEnv.isDevelopment) {
      final testIds = AppEnv.admobTestDeviceIds;
      if (testIds.isNotEmpty) {
        await MobileAds.instance.updateRequestConfiguration(
          RequestConfiguration(testDeviceIds: testIds),
        );
      }
    }
    InterstitialAdManager.instance.preload();
  }

  /// Sentry is set up in `main()`, so it is always available. Crashlytics only
  /// is once Firebase initialized.
  void _reportStartupError(Object error, StackTrace stack) {
    debugPrint('Startup error: $error');
    debugPrintStack(stackTrace: stack);
    unawaited(
      _ignoringFailure(
        () => Sentry.captureException(error, stackTrace: stack),
      ),
    );
    unawaited(
      _ignoringFailure(() async {
        if (Firebase.apps.isEmpty) return;
        await FirebaseCrashlytics.instance.recordError(
          error,
          stack,
          reason: 'startup',
        );
      }),
    );
  }

  Future<void> _ignoringFailure(Future<void> Function() report) async {
    try {
      await report();
    } on Object catch (_) {
      // There is nowhere left to report a failing reporter to.
    }
  }

  void _tryNavigate() {
    if (_navigating) return;
    if (!_minTimerElapsed) return;
    if (_startup.status != StartupStatus.ready) return;
    if (!mounted) return;
    _navigating = true;
    unawaited(_doNavigate());
  }

  Future<void> _doNavigate() async {
    final authBloc = _startup.authBloc!;
    final updateState = _startup.updateCubit!.state;

    // Force update — dead-end screen, shown outside IshariApp router
    final isForceUpdate = updateState.maybeWhen(
      forceUpdate: (storeUrl, releaseNotes) {
        setState(() {
          _app = MaterialApp(
            debugShowCheckedModeBanner: AppEnv.isDevelopment,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF51C878),
              ),
              useMaterial3: true,
            ),
            home: ForceUpdatePage(
              storeUrl: storeUrl,
              releaseNotes: releaseNotes,
            ),
          );
        });
        return true;
      },
      orElse: () => false,
    );
    if (isForceUpdate) return;

    // Soft update — show dialog while still on splash, before swapping
    await updateState.maybeWhen(
      softUpdate: (latestVersion, storeUrl, releaseNotes) async {
        await Future<void>.delayed(const Duration(milliseconds: 300));
        if (!mounted) return;
        final ctx = _navigatorKey.currentContext;
        if (ctx == null || !ctx.mounted) return;
        await SoftUpdateDialog.show(
          ctx,
          latestVersion: latestVersion,
          storeUrl: storeUrl,
          releaseNotes: releaseNotes,
        );
      },
      orElse: () async {},
    );

    if (!mounted) return;

    final hasAccess =
        authBloc.state.maybeWhen(
          authenticated: (_) => true,
          orElse: () => false,
        ) ||
        AppState.isGuestMode.value;

    setState(() {
      _app = IshariApp(
        authBloc: authBloc,
        initialLocation:
            hasAccess ? HomePage.routePath : IntroductionPage.routePath,
      );
    });
  }

  @override
  void dispose() {
    _startup
      ..removeListener(_tryNavigate)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_app != null) return _app!;
    return MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: AppEnv.isDevelopment,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF51C878),
        ),
        useMaterial3: true,
      ),
      home: ListenableBuilder(
        listenable: _startup,
        builder: (context, _) => _startup.status == StartupStatus.failed
            ? StartupErrorView(onRetry: () => unawaited(_startup.start()))
            : const _SplashBody(),
      ),
    );
  }
}

class _SplashBody extends StatelessWidget {
  const _SplashBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          Positioned(
            bottom: 120,
            right: 24,
            child: _DotGrid(),
          ),
          const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BookLogoWidget(size: 96),
                SizedBox(height: 28),
                IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'ISHARI',
                        style: TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 58,
                          fontWeight: FontWeight.w900,
                          color: _dark,
                          letterSpacing: -2,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Membaca & Mendengarkan shalawat',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _muted,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              top: false,
              minimum: EdgeInsets.only(bottom: 56),
              child: Center(child: LoadingBarWidget()),
            ),
          ),
        ],
      ),
    );
  }
}

class _DotGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const dotColor = Color(0xFF111111);
    const dotSize = 5.0;
    const gap = 5.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (_) {
        return Padding(
          padding: const EdgeInsets.only(bottom: gap),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(4, (col) {
              return Padding(
                padding: EdgeInsets.only(right: col < 3 ? gap : 0),
                child: Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    color: dotColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}
