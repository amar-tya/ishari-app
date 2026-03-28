import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/features/muhud/domain/entities/verse_with_details_entity.dart';

class VerseCard extends StatefulWidget {
  const VerseCard({
    required this.verse,
    required this.isBookmarked,
    required this.isPlaying,
    required this.showTranslation,
    required this.showArabic,
    required this.showTransliteration,
    required this.onBookmarkToggle,
    required this.onPlayTap,
    super.key,
  });

  final VerseWithDetailsEntity verse;
  final bool isBookmarked;
  final bool isPlaying;
  final bool showTranslation;
  final bool showArabic;
  final bool showTransliteration;
  final VoidCallback onBookmarkToggle;
  final VoidCallback onPlayTap;

  @override
  State<VerseCard> createState() => _VerseCardState();
}

class _VerseCardState extends State<VerseCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseAnim = Tween<double>(begin: 1, end: 1.4).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );
    if (widget.isPlaying) _pulseController.repeat(reverse: true).ignore();
  }

  @override
  void didUpdateWidget(VerseCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _pulseController.repeat(reverse: true).ignore();
    } else if (!widget.isPlaying && oldWidget.isPlaying) {
      _pulseController
        ..stop()
        ..reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final translation = widget.verse.translations.isNotEmpty
        ? widget.verse.translations.firstWhere(
            (t) => t.languageCode == 'id',
            orElse: () => widget.verse.translations.first,
          )
        : null;

    final hasAudio = widget.verse.mediaList.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: widget.isPlaying
          ? const EdgeInsets.symmetric(horizontal: 8, vertical: 2)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: widget.isPlaying
            ? const Color(0xFFEDFFC0)
            : Colors.white,
        borderRadius: widget.isPlaying ? BorderRadius.circular(16) : null,
        border: widget.isPlaying
            ? const Border(
                left: BorderSide(color: Color(0xFFCAFF00), width: 3),
              )
            : const Border(
                bottom: BorderSide(color: Color(0xFFE2E8DF)),
              ),
        boxShadow: widget.isPlaying
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Verse header row: number badge + action buttons
          Row(
            children: [
              _VerseNumberBadge(
                number: widget.verse.verse.verseNumber,
                isPlaying: widget.isPlaying,
                pulseAnim: _pulseAnim,
              ),
              const Spacer(),
              // Bookmark
              _ActionButton(
                icon: widget.isBookmarked
                    ? Icons.bookmark
                    : Icons.bookmark_outline,
                isActive: widget.isBookmarked,
                onTap: widget.onBookmarkToggle,
              ),
              const SizedBox(width: 2),
              // More
              _ActionButton(
                icon: Icons.more_horiz_rounded,
                isActive: false,
                onTap: () {},
              ),
              const SizedBox(width: 4),
              // Play/pause — only if verse has audio
              if (hasAudio)
                _ActionButton(
                  icon: widget.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  isActive: widget.isPlaying,
                  variant: _ActionButtonVariant.play,
                  onTap: widget.onPlayTap,
                ),
            ],
          ),

          // Arabic text
          if (widget.showArabic) ...[
            const SizedBox(height: 14),
            Text(
              widget.verse.verse.arabicText,
              style: GoogleFonts.scheherazadeNew(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1C1B1F),
                height: 2.2,
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
          ],

          // Transliteration
          if (widget.showTransliteration &&
              widget.verse.verse.transliteration.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              widget.verse.verse.transliteration,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF777777),
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
          ],

          // Translation
          if (widget.showTranslation && translation != null) ...[
            const SizedBox(height: 10),
            const Text(
              'TERJEMAHAN',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFFAAAAAA),
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              translation.translationText,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1C1B1F),
                height: 1.6,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _VerseNumberBadge extends StatelessWidget {
  const _VerseNumberBadge({
    required this.number,
    required this.isPlaying,
    required this.pulseAnim,
  });

  final int number;
  final bool isPlaying;
  final Animation<double> pulseAnim;

  @override
  Widget build(BuildContext context) {
    final label = number.toString().padLeft(2, '0');
    return SizedBox(
      height: 28,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isPlaying)
            AnimatedBuilder(
              animation: pulseAnim,
              builder: (_, __) => Transform.scale(
                scale: pulseAnim.value,
                child: Container(
                  height: 22,
                  width: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color(0xFFCAFF00).withValues(alpha: 0.35),
                  ),
                ),
              ),
            ),
          Container(
            height: 22,
            constraints: const BoxConstraints(minWidth: 28),
            padding: const EdgeInsets.symmetric(horizontal: 7),
            decoration: BoxDecoration(
              color: isPlaying
                  ? const Color(0xFF111111)
                  : const Color(0xFFE8F0E6),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: const Color(0xFFE2E8DF),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: isPlaying
                    ? const Color(0xFFCAFF00)
                    : const Color(0xFF777777),
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _ActionButtonVariant { play, ghost }

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
    this.variant = _ActionButtonVariant.ghost,
  });

  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final _ActionButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final Color bgColor;
    final Color iconColor;

    if (variant == _ActionButtonVariant.play) {
      bgColor = isActive ? const Color(0xFFCAFF00) : const Color(0xFF111111);
      iconColor = isActive ? const Color(0xFF111111) : Colors.white;
    } else {
      bgColor = Colors.transparent;
      iconColor = isActive ? const Color(0xFF111111) : const Color(0xFFAAAAAA);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: variant == _ActionButtonVariant.play ? 14 : 15,
        ),
      ),
    );
  }
}
