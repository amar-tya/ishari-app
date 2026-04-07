import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/features/kitab/domain/entities/book_entity.dart';
import 'package:ishari/features/kitab/presentation/bloc/kitab_bloc.dart';

// ── Design tokens ──────────────────────────────────────────────────────────
const _kBg = Color(0xFFF0F5EE);
const _kSurface = Color(0xFFFFFFFF);
const _kDark = Color(0xFF111111);
const _kLime = Color(0xFFCAFF00);
const _kMuted = Color(0xFF777777);
const _kBgAlt = Color(0xFFE8F0E6);
const _kBorder = Color(0xFFE2E8DF);

enum _CardVariant { light, dark, lime }

class KitabPage extends StatelessWidget {
  const KitabPage({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return BlocBuilder<KitabBloc, KitabState>(
      builder: (context, state) {
        return ColoredBox(
          color: _kBg,
          child: state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(
              child: CircularProgressIndicator(color: _kLime),
            ),
            error: (message) => _ErrorBody(message: message),
            loaded: (books) => ListView(
              padding: EdgeInsets.only(
                top: topPadding + 20,
                bottom: MediaQuery.of(context).padding.bottom + 8,
              ),
              children: [
                _PageHeader(count: books.length),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      for (var i = 0; i < books.length; i++) ...[
                        _BookCard(
                          book: books[i],
                          variant: _CardVariant.values[i % 3],
                        ),
                        if (i < books.length - 1) const SizedBox(height: 10),
                      ],
                    ],
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

// ── Page header ──────────────────────────────────────────────────────────────
class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'KOLEKSI',
            style: GoogleFonts.dmSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: _kMuted,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: GoogleFonts.dmSans(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: _kDark,
                letterSpacing: -0.6,
                height: 1.2,
              ),
              children: [
                const TextSpan(text: 'Kitab yang '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _kLime,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      'tersedia',
                      style: GoogleFonts.dmSans(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: _kDark,
                        letterSpacing: -0.6,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$count kitab tersedia',
            style: GoogleFonts.dmSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _kMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Book card ────────────────────────────────────────────────────────────────
class _BookCard extends StatelessWidget {
  const _BookCard({required this.book, required this.variant});

  final BookEntity book;
  final _CardVariant variant;

  @override
  Widget build(BuildContext context) {
    final isDark = variant == _CardVariant.dark;
    final isLime = variant == _CardVariant.lime;

    final cardBg = isDark ? _kDark : (isLime ? _kLime : _kSurface);
    final labelBg = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : (isLime ? Colors.black.withValues(alpha: 0.08) : _kBgAlt);
    final labelBorder = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : (isLime ? Colors.black.withValues(alpha: 0.10) : _kBorder);
    final labelColor = isDark
        ? Colors.white.withValues(alpha: 0.5)
        : (isLime ? Colors.black.withValues(alpha: 0.5) : _kMuted);
    final arrowBg = isDark ? _kLime : _kDark;
    final arrowColor = isDark ? _kDark : Colors.white;
    final titleColor = isDark ? _kLime : _kDark;
    final subtitleColor = isDark
        ? Colors.white.withValues(alpha: 0.45)
        : (isLime ? Colors.black.withValues(alpha: 0.55) : _kMuted);

    final titleShadows = isDark
        ? [
            Shadow(
              color: _kLime.withValues(alpha: 0.2),
              offset: const Offset(3, 3),
            ),
          ]
        : isLime
        ? [const Shadow(color: Color(0x1A000000), offset: Offset(3, 3))]
        : [
            const Shadow(color: _kLime, offset: Offset(3, 3)),
            Shadow(
              color: _kLime.withValues(alpha: 0.18),
              offset: const Offset(6, 6),
            ),
          ];

    return GestureDetector(
      onTap: () => _showUnderDevelopmentSheet(context, book.title),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top row: label + arrow
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: labelBg,
                    border: Border.all(color: labelBorder),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  child: Text(
                    'Kitab',
                    style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: labelColor,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: arrowBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: arrowColor,
                    size: 18,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Title
            Text(
              book.description ?? '-',
              textDirection: TextDirection.rtl,
              style: GoogleFonts.scheherazadeNew(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: titleColor,
                height: 1.2,
                letterSpacing: -1,
                shadows: titleShadows,
              ),
            ),

            ...[
              const SizedBox(height: 4),
              Text(
                [
                  book.title,
                  if (book.author != null) book.author!,
                ].join(' — '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: subtitleColor,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showUnderDevelopmentSheet(BuildContext context, String title) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (_) => _UnderDevelopmentSheet(title: title),
      ),
    );
  }
}

// ── Under development sheet ──────────────────────────────────────────────────
class _UnderDevelopmentSheet extends StatelessWidget {
  const _UnderDevelopmentSheet({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _kLime,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.construction_rounded,
              color: _kDark,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Masih dalam Pengembangan',
            style: GoogleFonts.dmSans(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: _kDark,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Kitab "$title" sedang kami siapkan.\nNantikan pembaruan selanjutnya.',
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: _kMuted,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: _kDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'Mengerti',
                style: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Error body ───────────────────────────────────────────────────────────────
class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_outlined, size: 48, color: _kMuted),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(color: _kMuted),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () =>
                  context.read<KitabBloc>().add(const KitabEvent.refresh()),
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: FilledButton.styleFrom(backgroundColor: _kDark),
            ),
          ],
        ),
      ),
    );
  }
}
