import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ishari/core/app_state.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/auth/presentation/pages/home_page.dart';
import 'package:ishari/features/introduction/presentation/widgets/illustrations/audio_illustration.dart';
import 'package:ishari/features/introduction/presentation/widgets/illustrations/book_illustration.dart';
import 'package:ishari/features/introduction/presentation/widgets/illustrations/bookmark_illustration.dart';
import 'package:ishari/features/introduction/presentation/widgets/illustrations/key_illustration.dart';
import 'package:ishari/features/introduction/presentation/widgets/illustrations/night_mode_illustration.dart';

/// The onboarding / introduction flow.
///
/// Shows 5 slides (PageView) before the user signs in or continues as guest.
/// Design follows the Material Design 3 mockup with primary color #51C878.
class IntroductionPage extends StatefulWidget {
  static const routePath = '/introduction';

  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

// ── Color palette from mockup ──────────────────────────────────────────────
const _primary = Color(0xFF51C878);
const _illustrationBg = Color(0xFFF0FAF4);
const _onSurface = Color(0xFF1C1B1F);
const _onSurfaceVariant = Color(0xFF49454F);
const _dotInactive = Color(0xFFC8E6C9);

// ── Slide data model ───────────────────────────────────────────────────────
enum _IllustrationType { book, audio, bookmark, nightMode, key }

class _SlideData {
  const _SlideData({
    required this.title,
    required this.description,
    required this.illustration,
  });

  final String title;
  final String description;
  final _IllustrationType illustration;
}

const _slides = [
  _SlideData(
    title: 'Baca Shalawat Mudah & Kapanpun',
    description:
        'Ratusan bait shalawat dari kitab Diwan,\nSyaraful Anam, Diba\', dan lainnya',
    illustration: _IllustrationType.book,
  ),
  _SlideData(
    title: 'Dengarkan dengan Khidmat',
    description:
        'Nikmati bacaan shalawat dengan audio\nberkualitas dari Pimpinan Shalawat terpilih',
    illustration: _IllustrationType.audio,
  ),
  _SlideData(
    title: 'Simpan Favoritmu',
    description:
        'Tandai shalawat kesukaan dan akses\nkembali kapan saja dengan mudah',
    illustration: _IllustrationType.bookmark,
  ),
  _SlideData(
    title: 'Mari Lestarikan Budaya Ulama Nusantara',
    description: 'Mudah didengar, mudah disimpan, dan mudah diakses kapan saja',
    illustration: _IllustrationType.nightMode,
  ),
  _SlideData(
    title: 'Masuk untuk Mulai',
    description:
        'Aktifkan fitur bookmark dan personalisasi\ndengan masuk ke akun Anda',
    illustration: _IllustrationType.key,
  ),
];

// ── Page ───────────────────────────────────────────────────────────────────
class _IntroductionPageState extends State<IntroductionPage> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goNext() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeInOut,
    );
  }

  void _skipToLast() {
    _pageController.animateToPage(
      _slides.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int page) => setState(() => _currentPage = page);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          authenticated: (_) => context.go(HomePage.routePath),
          error: (message) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: const Color(0xFFB3261E),
            ),
          ),
          orElse: () {},
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // ── PageView ────────────────────────────────────────────────
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _slides.length,
              itemBuilder: (context, index) =>
                  _IntroSlide(slide: _slides[index]),
            ),

            // ── Skip button (hidden on last slide) ──────────────────────
            if (_currentPage < _slides.length - 1)
              Positioned(
                top: MediaQuery.of(context).padding.top + 52,
                right: 24,
                child: _SkipButton(onTap: _skipToLast),
              ),

            // ── Bottom overlay (dots + CTA buttons) ─────────────────────
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _BottomSection(
                currentPage: _currentPage,
                totalPages: _slides.length,
                onNext: _goNext,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Slide ──────────────────────────────────────────────────────────────────
class _IntroSlide extends StatelessWidget {
  const _IntroSlide({required this.slide});

  final _SlideData slide;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Illustration area — top 55%
        _IllustrationArea(type: slide.illustration),

        // Text content — remaining space
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Column(
              children: [
                Text(
                  slide.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: _onSurface,
                    height: 1.3,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  slide.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: _onSurfaceVariant,
                    height: 1.65,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Reserve space for the bottom section overlay
        const SizedBox(height: 220),
      ],
    );
  }
}

// ── Illustration area ──────────────────────────────────────────────────────
class _IllustrationArea extends StatelessWidget {
  const _IllustrationArea({required this.type});

  final _IllustrationType type;

  Widget _illustration() {
    return switch (type) {
      _IllustrationType.book => const BookIllustration(),
      _IllustrationType.audio => const AudioIllustration(),
      _IllustrationType.bookmark => const BookmarkIllustration(),
      _IllustrationType.nightMode => const NightModeIllustration(),
      _IllustrationType.key => const KeyIllustration(),
    };
  }

  @override
  Widget build(BuildContext context) {
    // 55% of screen height
    final illustrationHeight = MediaQuery.of(context).size.height * 0.55;
    return SizedBox(
      width: double.infinity,
      height: illustrationHeight,
      child: ClipPath(
        clipper: _WaveClipper(),
        child: Container(
          color: _illustrationBg,
          child: SafeArea(
            bottom: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 48),
                child: _illustration(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Clips a subtle curved wave at the bottom of the illustration area.
class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height - 32)
      ..quadraticBezierTo(
        size.width / 2,
        size.height + 16,
        size.width,
        size.height - 32,
      )
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// ── Skip button ────────────────────────────────────────────────────────────
class _SkipButton extends StatelessWidget {
  const _SkipButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.72),
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Text(
          'Lewati',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: _primary,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }
}

// ── Bottom section ─────────────────────────────────────────────────────────
class _BottomSection extends StatelessWidget {
  const _BottomSection({
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
  });

  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;

  bool get _isLastPage => currentPage == totalPages - 1;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(24, 16, 24, bottomPadding + 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Page indicator dots
          _PageDots(current: currentPage, total: totalPages),
          const SizedBox(height: 12),

          if (_isLastPage) ...[
            // Google Sign-In button
            _GoogleSignInButton(),
            const SizedBox(height: 12),
            // Guest button
            _GuestButton(),
            const SizedBox(height: 8),
            const Text(
              'Mode tamu tidak dapat menyimpan bookmark',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF79747E),
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
          ] else ...[
            // Next button
            _FilledButton(
              label: 'Selanjutnya →',
              onTap: onNext,
            ),
            // Spacer matching the two-button height of the last slide
            const SizedBox(height: 90),
          ],
        ],
      ),
    );
  }
}

// ── Page dots ──────────────────────────────────────────────────────────────
class _PageDots extends StatelessWidget {
  const _PageDots({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? _primary : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            border: isActive ? null : Border.all(color: _dotInactive, width: 2),
          ),
        );
      }),
    );
  }
}

// ── Filled button (Next) ───────────────────────────────────────────────────
class _FilledButton extends StatelessWidget {
  const _FilledButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: _primary,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: _primary.withOpacity(0.30),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
            const BoxShadow(
              color: Color(0x24000000),
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }
}

// ── Google Sign-In button ──────────────────────────────────────────────────
class _GoogleSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        return GestureDetector(
          onTap: isLoading
              ? null
              : () => context.read<AuthBloc>().add(
                  const AuthEvent.signInWithGoogle(),
                ),
          child: Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              color: _primary,
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: _primary.withOpacity(0.30),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
                const BoxShadow(
                  color: Color(0x24000000),
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: isLoading
                ? const Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Google "G" badge
                      Container(
                        width: 24,
                        height: 24,
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CustomPaint(painter: _GoogleGPainter()),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Masuk dengan Google',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

// ── Guest button ───────────────────────────────────────────────────────────
class _GuestButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppState.isGuestMode.value = true;
        context.go(HomePage.routePath);
      },
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: _primary, width: 1.5),
        ),
        alignment: Alignment.center,
        child: const Text(
          'Lanjutkan sebagai Tamu',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: _primary,
            letterSpacing: 0.1,
          ),
        ),
      ),
    );
  }
}

// ── Google G logo painter ──────────────────────────────────────────────────
/// Paints a simplified Google "G" using the four brand colors as arc segments.
class _GoogleGPainter extends CustomPainter {
  static const _blue = Color(0xFF4285F4);
  static const _green = Color(0xFF34A853);
  static const _yellow = Color(0xFFFBBC05);
  static const _red = Color(0xFFEA4335);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);
    final radius = w * 0.42;
    final strokeW = w * 0.22;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.butt;

    final rect = Rect.fromCircle(center: center, radius: radius);
    const deg = 3.14159265 / 180;

    // Draw the arcs (colored segments)
    // Red (top)
    canvas.drawArc(rect, 195 * deg, 105 * deg, false, paint..color = _red);
    // Yellow (left)
    canvas.drawArc(rect, 135 * deg, 60 * deg, false, paint..color = _yellow);
    // Green (bottom)
    canvas.drawArc(rect, 45 * deg, 90 * deg, false, paint..color = _green);
    // Blue (right)
    canvas.drawArc(rect, -45 * deg, 90 * deg, false, paint..color = _blue);

    // Draw the horizontal bar of the "G"
    final barPaint = Paint()
      ..color = _blue
      ..style = PaintingStyle.fill;

    // The bar starts from the center and goes slightly past the arc edge
    canvas.drawRect(
      Rect.fromLTWH(
        center.dx,
        center.dy - (strokeW / 2),
        radius + (strokeW / 2),
        strokeW,
      ),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
