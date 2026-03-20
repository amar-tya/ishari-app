import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/core/app_state.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/auth/presentation/pages/home_page.dart';
import 'package:ishari/features/introduction/presentation/pages/introduction_page.dart';
import 'package:ishari/features/splash/presentation/widgets/book_logo_painter.dart';
import 'package:ishari/features/splash/presentation/widgets/loading_dots.dart';

const _primary = Color(0xFF51C878);
const _primaryDark = Color(0xFF3DA85F);
const _onSurface = Color(0xFF1C1B1F);
const _hint = Color(0xFF79747E);

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
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Decorative radial gradient circles
            const Positioned(
              top: -80,
              right: -80,
              child: _BgCircle(size: 320, opacity: 0.08),
            ),
            const Positioned(
              bottom: -60,
              left: -60,
              child: _BgCircle(size: 280, opacity: 0.06),
            ),

            // Top accent bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_primary, _primaryDark],
                  ),
                ),
              ),
            ),

            // Center: logo + name + tagline
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const BookLogoWidget(),
                  const SizedBox(height: 32),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'ISHA',
                          style: GoogleFonts.poppins(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            color: _onSurface,
                            letterSpacing: 8,
                          ),
                        ),
                        TextSpan(
                          text: 'RI',
                          style: GoogleFonts.poppins(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            color: _primary,
                            letterSpacing: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 2,
                    decoration: BoxDecoration(
                      color: _primary.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'membaca dan mendengarkan shalawat ISHARI',
                    style: TextStyle(
                      fontSize: 12,
                      color: _hint,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Bottom loading dots
            const Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: Center(child: LoadingDotsWidget()),
            ),
          ],
        ),
      ),
    );
  }
}

class _BgCircle extends StatelessWidget {
  const _BgCircle({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            _primary.withValues(alpha: opacity),
            Colors.transparent,
          ],
          stops: const [0, 0.7],
        ),
      ),
    );
  }
}
