import 'package:flutter/material.dart';

/// Screenshot-based illustrations for the onboarding flow.
///
/// Each class wraps a PNG screenshot taken from the project's mockup HTML
/// files, giving users a realistic preview of the actual app screens.

// ── Shared screenshot widget ────────────────────────────────────────────────
class _ScreenshotIllustration extends StatelessWidget {
  const _ScreenshotIllustration({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      fit: BoxFit.fitWidth,
      alignment: Alignment.topCenter,
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════
// Slide 1 — Chapter list (homepage)
// ══════════════════════════════════════════════════════════════════════════
class ShalawatCardsIllustration extends StatelessWidget {
  const ShalawatCardsIllustration({super.key});

  @override
  Widget build(BuildContext context) => const _ScreenshotIllustration(
    assetPath: 'assets/images/intro/slide_1_chapters.png',
  );
}

// ══════════════════════════════════════════════════════════════════════════
// Slide 2 — Chapter reader
// ══════════════════════════════════════════════════════════════════════════
class AudioPlayerIllustration extends StatelessWidget {
  const AudioPlayerIllustration({super.key});

  @override
  Widget build(BuildContext context) => const _ScreenshotIllustration(
    assetPath: 'assets/images/intro/slide_2_reader.png',
  );
}

// ══════════════════════════════════════════════════════════════════════════
// Slide 3 — Bookmarks
// ══════════════════════════════════════════════════════════════════════════
class BookmarkListIllustration extends StatelessWidget {
  const BookmarkListIllustration({super.key});

  @override
  Widget build(BuildContext context) => const _ScreenshotIllustration(
    assetPath: 'assets/images/intro/slide_3_bookmark.png',
  );
}

// ══════════════════════════════════════════════════════════════════════════
// Slide 4 — Kitab library
// ══════════════════════════════════════════════════════════════════════════
class CultureGridIllustration extends StatelessWidget {
  const CultureGridIllustration({super.key});

  @override
  Widget build(BuildContext context) => const _ScreenshotIllustration(
    assetPath: 'assets/images/intro/slide_4_kitab.png',
  );
}

// ══════════════════════════════════════════════════════════════════════════
// Slide 5 — Sign-in (search/discover preview)
// ══════════════════════════════════════════════════════════════════════════
class SignInPreviewIllustration extends StatelessWidget {
  const SignInPreviewIllustration({super.key});

  @override
  Widget build(BuildContext context) => const _ScreenshotIllustration(
    assetPath: 'assets/images/intro/slide_5_search.png',
  );
}
