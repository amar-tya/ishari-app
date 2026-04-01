import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ishari/core/app_state.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/auth/presentation/pages/home_page.dart';
import 'package:ishari/features/introduction/presentation/pages/introduction_page.dart';
import 'package:ishari/features/splash/presentation/widgets/loading_bar.dart';

const _bg = Color(0xFFF0F5EE);
const _dark = Color(0xFF111111);
const _muted = Color(0xFF777777);

/// Splash screen shown on app launch while [AuthBloc] resolves auth status.
///
/// Navigation is deferred until both conditions are met:
/// - 1.5 s minimum display timer has elapsed.
/// - [AuthBloc] has transitioned out of [AuthState.initial] / [AuthState.loading].
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  static const routePath = '/splash';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _minTimerElapsed = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() => _minTimerElapsed = true);
      _tryNavigate();
    });
  }

  void _tryNavigate() {
    if (!_minTimerElapsed) return;
    if (!mounted) return;

    final authBloc = context.read<AuthBloc>();
    final authResolved = authBloc.state.maybeWhen(
      initial: () => false,
      loading: () => false,
      orElse: () => true,
    );
    if (!authResolved) return;

    final hasAccess =
        authBloc.state.maybeWhen(
          authenticated: (_) => true,
          orElse: () => false,
        ) ||
        AppState.isGuestMode.value;

    context.go(hasAccess ? HomePage.routePath : IntroductionPage.routePath);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) => _tryNavigate(),
      child: Scaffold(
        backgroundColor: _bg,
        body: Stack(
          children: [
            // Dot grid decoration — bottom right
            Positioned(
              bottom: 120,
              right: 24,
              child: _DotGrid(),
            ),

            // Center: wordmark + tagline
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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

            // Bottom loading bar
            const Positioned(
              bottom: 56,
              left: 0,
              right: 0,
              child: Center(child: LoadingBarWidget()),
            ),
          ],
        ),
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
