import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ishari/core/app_state.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/auth/presentation/pages/home_page.dart';
import 'package:ishari/features/introduction/presentation/widgets/intro_illustrations.dart';

/// The onboarding / introduction flow.
///
/// Shows 5 slides (PageView) before the user signs in or continues as guest.
/// Design follows the Ishari Design System: Lime (#CAFF00) primary, DM Sans.
class IntroductionPage extends StatefulWidget {
  static const routePath = '/introduction';

  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

// ── Design System Tokens ───────────────────────────────────────────────────
const _clrPrimary    = Color(0xFFCAFF00);   // Lime / brand accent
const _clrDark       = Color(0xFF111111);   // Near-black
const _clrSurface    = Color(0xFFFFFFFF);   // White
const _clrBg         = Color(0xFFF0F5EE);   // App background (light sage)
const _clrMuted      = Color(0xFF777777);   // Secondary text
const _clrBorderDark = Color(0xFFD0D8CE);   // Stronger borders

// ── Title inline badge styles ──────────────────────────────────────────────
enum _BadgeStyle { dark, lime }

class _TitlePart {
  const _TitlePart(this.text, {this.badge});

  final String text;
  final _BadgeStyle? badge;
}

// ── Slide data ─────────────────────────────────────────────────────────────
class _SlideData {
  const _SlideData({
    required this.label,
    required this.titleParts,
    required this.description,
    required this.illustrationBg,
    required this.buildIllustration,
  });

  final String label;
  final List<_TitlePart> titleParts;
  final String description;
  final Color illustrationBg;
  final WidgetBuilder buildIllustration;
}

List<_SlideData> _buildSlides() => [
      _SlideData(
        label: 'QS Al-Ahzab: 56',
        titleParts: const [
          _TitlePart('Baca Shalawat '),
          _TitlePart('Mudah', badge: _BadgeStyle.dark),
          _TitlePart(' & Kapanpun'),
        ],
        description:
            'Ratusan bait dari kitab Diwan, Syaraful Anam,\nDiba\', dan lainnya — dalam genggamanmu.',
        illustrationBg: _clrBg,
        buildIllustration: (_) => const ShalawatCardsIllustration(),
      ),
      _SlideData(
        label: 'Pimpinan Shalawat',
        titleParts: const [
          _TitlePart('Dengarkan '),
          _TitlePart('dengan Khidmat', badge: _BadgeStyle.dark),
        ],
        description:
            'Nikmati bacaan shalawat dengan audio\nberkualitas dari Pimpinan Shalawat terpilih.',
        illustrationBg: _clrBg,
        buildIllustration: (_) => const AudioPlayerIllustration(),
      ),
      _SlideData(
        label: 'Koleksi Favoritmu',
        titleParts: const [
          _TitlePart('Simpan '),
          _TitlePart('Favoritmu', badge: _BadgeStyle.lime),
          _TitlePart(' Kapan Saja'),
        ],
        description:
            'Tandai shalawat kesukaan dan akses\nkembali kapan saja dengan mudah.',
        illustrationBg: _clrBg,
        buildIllustration: (_) => const BookmarkListIllustration(),
      ),
      _SlideData(
        label: 'Warisan Ulama Nusantara',
        titleParts: const [
          _TitlePart('Mari '),
          _TitlePart('Lestarikan', badge: _BadgeStyle.dark),
          _TitlePart(' Budaya Ulama'),
        ],
        description:
            'Mudah didengar, mudah disimpan,\ndan mudah diakses kapan saja.',
        illustrationBg: _clrBg,
        buildIllustration: (_) => const CultureGridIllustration(),
      ),
      _SlideData(
        label: 'Mulai Perjalananmu',
        titleParts: const [
          _TitlePart('Masuk & Mulai '),
          _TitlePart('Bershalawat', badge: _BadgeStyle.lime),
          _TitlePart(' Sekarang'),
        ],
        description:
            'Simpan progres, tandai bait favorit, dan\nakses riwayat bacaanmu di semua perangkat.',
        illustrationBg: _clrBg,
        buildIllustration: (_) => const SignInPreviewIllustration(),
      ),
    ];

// ── Page ───────────────────────────────────────────────────────────────────
class _IntroductionPageState extends State<IntroductionPage> {
  final _pageController = PageController();
  int _currentPage = 0;
  late final List<_SlideData> _slides;

  @override
  void initState() {
    super.initState();
    _slides = _buildSlides();
  }

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
              backgroundColor: const Color(0xFFFF4D4F),
            ),
          ),
          orElse: () {},
        );
      },
      child: Scaffold(
        backgroundColor: _clrBg,
        body: Stack(
          children: [
            // ── PageView ─────────────────────────────────────────────────
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _slides.length,
              itemBuilder: (context, index) =>
                  _IntroSlide(slide: _slides[index]),
            ),

            // ── Skip button (hidden on last slide) ───────────────────────
            if (_currentPage < _slides.length - 1)
              Positioned(
                top: MediaQuery.of(context).padding.top + 52,
                right: 24,
                child: _SkipButton(onTap: _skipToLast),
              ),

            // ── Bottom overlay (dots + CTA) ──────────────────────────────
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _IllustrationArea(
          bg: slide.illustrationBg,
          child: slide.buildIllustration(context),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  slide.label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _clrMuted,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 6),
                _TitleText(parts: slide.titleParts),
                const SizedBox(height: 8),
                Text(
                  slide.description,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _clrMuted,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Reserve space for bottom section overlay
        const SizedBox(height: 220),
      ],
    );
  }
}

// ── Illustration area ──────────────────────────────────────────────────────
class _IllustrationArea extends StatelessWidget {
  const _IllustrationArea({required this.bg, required this.child});

  final Color bg;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.50;
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      child: SafeArea(
        bottom: false,
        child: child,
      ),
    );
  }
}

// ── Title with inline badges ───────────────────────────────────────────────
class _TitleText extends StatelessWidget {
  const _TitleText({required this.parts});

  final List<_TitlePart> parts;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: parts.map((p) {
          if (p.badge == null) {
            return TextSpan(
              text: p.text,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: _clrDark,
                height: 1.2,
                letterSpacing: -0.5,
              ),
            );
          }
          final isDark = p.badge == _BadgeStyle.dark;
          return WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              padding: const EdgeInsets.fromLTRB(7, 2, 8, 3),
              decoration: BoxDecoration(
                color: isDark ? _clrDark : _clrPrimary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isDark)
                    Container(
                      width: 5,
                      height: 5,
                      margin: const EdgeInsets.only(right: 4),
                      decoration: const BoxDecoration(
                        color: _clrPrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  Text(
                    p.text,
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : _clrDark,
                      letterSpacing: -0.4,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
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
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: _clrBorderDark, width: 1.5),
        ),
        child: const Text(
          'Lewati',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: _clrMuted,
            letterSpacing: -0.1,
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
      color: _clrBg,
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPadding + 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PageDots(current: currentPage, total: totalPages),
          const SizedBox(height: 8),
          if (_isLastPage) ...[
            const _GoogleSignInButton(),
            const SizedBox(height: 8),
            const _GuestButton(),
          ] else ...[
            _NextButton(onTap: onNext),
            // Spacer matching two-button height on last slide
            const SizedBox(height: 52),
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
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 22 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? _clrDark : _clrBorderDark,
            borderRadius: BorderRadius.circular(100),
          ),
        );
      }),
    );
  }
}

// ── Next button — btn-primary (Lime) ──────────────────────────────────────
class _NextButton extends StatelessWidget {
  const _NextButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        padding: const EdgeInsets.fromLTRB(22, 0, 8, 0),
        decoration: BoxDecoration(
          color: _clrPrimary,
          borderRadius: BorderRadius.circular(100),
          boxShadow: const [
            BoxShadow(
              color: Color(0x44CAFF00),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'Selanjutnya',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: _clrDark,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: _clrDark,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: _clrPrimary,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Google Sign-In button — outlined ──────────────────────────────────────
class _GoogleSignInButton extends StatelessWidget {
  const _GoogleSignInButton();

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
              : () => context
                  .read<AuthBloc>()
                  .add(const AuthEvent.signInWithGoogle()),
          child: Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              color: _clrSurface,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: _clrBorderDark, width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
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
                        valueColor: AlwaysStoppedAnimation(_clrDark),
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CustomPaint(painter: _GoogleGPainter()),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Masuk dengan Google',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _clrDark,
                          letterSpacing: -0.1,
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

// ── Guest button — ghost ───────────────────────────────────────────────────
class _GuestButton extends StatelessWidget {
  const _GuestButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppState.isGuestMode.value = true;
        context.go(HomePage.routePath);
      },
      child: Container(
        width: double.infinity,
        height: 44,
        alignment: Alignment.center,
        child: const Text(
          'Lanjutkan sebagai tamu →',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _clrMuted,
          ),
        ),
      ),
    );
  }
}

// ── Google G logo painter ──────────────────────────────────────────────────
class _GoogleGPainter extends CustomPainter {
  static const _blue   = Color(0xFF4285F4);
  static const _green  = Color(0xFF34A853);
  static const _yellow = Color(0xFFFBBC05);
  static const _red    = Color(0xFFEA4335);

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

    canvas
      ..drawArc(rect, 195 * deg, 105 * deg, false, paint..color = _red)
      ..drawArc(rect, 135 * deg,  60 * deg, false, paint..color = _yellow)
      ..drawArc(rect,  45 * deg,  90 * deg, false, paint..color = _green)
      ..drawArc(rect, -45 * deg,  90 * deg, false, paint..color = _blue);

    canvas.drawRect(
      Rect.fromLTWH(
        center.dx,
        center.dy - (strokeW / 2),
        radius + (strokeW / 2),
        strokeW,
      ),
      Paint()
        ..color = _blue
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
