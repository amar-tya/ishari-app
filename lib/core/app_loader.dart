import 'dart:async';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' hide AppState;
import 'package:ishari/app.dart';
import 'package:ishari/core/ads/interstitial_ad_manager.dart';
import 'package:ishari/core/app_state.dart';
import 'package:ishari/core/env/app_env.dart';
import 'package:ishari/core/wizard/wizard_cubit.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/auth/presentation/pages/home_page.dart';
import 'package:ishari/features/introduction/presentation/pages/introduction_page.dart';
import 'package:ishari/features/splash/presentation/widgets/book_logo_painter.dart';
import 'package:ishari/features/splash/presentation/widgets/loading_bar.dart';
import 'package:ishari/features/update/presentation/cubit/update_cubit.dart';
import 'package:ishari/features/update/presentation/pages/force_update_page.dart';
import 'package:ishari/features/update/presentation/widgets/soft_update_dialog.dart';
import 'package:ishari/firebase_options.dart';
import 'package:ishari/injection_container.dart';
// Hide conflicting names exported by third-party packages.
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:wakelock_plus/wakelock_plus.dart';

const _bg = Color(0xFFF0F5EE);
const _dark = Color(0xFF111111);
const _muted = Color(0xFF777777);

/// Shown immediately on launch. Handles all heavy initialization while
/// displaying the branded splash UI, then swaps to [IshariApp] once ready.
class AppLoader extends StatefulWidget {
  const AppLoader({super.key});

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  bool _minTimerElapsed = false;
  bool _initDone = false;
  bool _authResolved = false;
  bool _updateResolved = false;
  bool _navigating = false;

  late AuthBloc _authBloc;
  late UpdateCubit _updateCubit;
  StreamSubscription<AuthState>? _authSub;
  StreamSubscription<UpdateState>? _updateSub;

  Widget? _app;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      _minTimerElapsed = true;
      _tryNavigate();
    });
    unawaited(_initialize());
  }

  Future<void> _initialize() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    AppEnv.validate();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
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
    await Supabase.initialize(
      url: AppEnv.supabaseUrl,
      anonKey: AppEnv.supabaseAnonKey,
    );
    await configureDependencies();
    sl.registerSingleton<WizardCubit>(WizardCubit(sl<FlutterSecureStorage>()));

    // Non-critical — don't block splash
    unawaited(
      MobileAds.instance.initialize().then((_) async {
        if (AppEnv.isDevelopment) {
          final testIds = AppEnv.admobTestDeviceIds;
          if (testIds.isNotEmpty) {
            await MobileAds.instance.updateRequestConfiguration(
              RequestConfiguration(testDeviceIds: testIds),
            );
          }
        }
        InterstitialAdManager.instance.preload();
      }),
    );
    unawaited(WakelockPlus.enable());

    // Auth check — use same instance passed to IshariApp later
    _authBloc = sl<AuthBloc>();
    _authSub = _authBloc.stream.listen((state) {
      if (!mounted) return;
      final resolved = state.maybeWhen(
        initial: () => false,
        loading: () => false,
        orElse: () => true,
      );
      if (resolved) {
        _authResolved = true;
        _tryNavigate();
      }
    });
    _authBloc.add(const AuthEvent.checkAuthStatus());

    // Update check
    _updateCubit = sl<UpdateCubit>();
    _updateSub = _updateCubit.stream.listen((state) {
      if (!mounted) return;
      final resolved = state.maybeWhen(
        initial: () => false,
        checking: () => false,
        orElse: () => true,
      );
      if (resolved) {
        _updateResolved = true;
        _tryNavigate();
      }
    });
    unawaited(_updateCubit.check());

    // Catch already-resolved states (fast response / cached)
    _authResolved = _authBloc.state.maybeWhen(
      initial: () => false,
      loading: () => false,
      orElse: () => true,
    );
    _updateResolved = _updateCubit.state.maybeWhen(
      initial: () => false,
      checking: () => false,
      orElse: () => true,
    );

    _initDone = true;
    _tryNavigate();
  }

  void _tryNavigate() {
    if (_navigating) return;
    if (!_minTimerElapsed) return;
    if (!_initDone) return;
    if (!_authResolved) return;
    if (!_updateResolved) return;
    if (!mounted) return;
    _navigating = true;
    unawaited(_doNavigate());
  }

  Future<void> _doNavigate() async {
    final updateState = _updateCubit.state;

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
        _authBloc.state.maybeWhen(
          authenticated: (_) => true,
          orElse: () => false,
        ) ||
        AppState.isGuestMode.value;

    setState(() {
      _app = IshariApp(
        authBloc: _authBloc,
        initialLocation:
            hasAccess ? HomePage.routePath : IntroductionPage.routePath,
      );
    });
  }

  @override
  void dispose() {
    unawaited(_authSub?.cancel());
    unawaited(_updateSub?.cancel());
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
      home: const _SplashBody(),
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
            bottom: 56,
            left: 0,
            right: 0,
            child: Center(child: LoadingBarWidget()),
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
