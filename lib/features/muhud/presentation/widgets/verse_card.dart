import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  void _copyArabicText() {
    Clipboard.setData(
      ClipboardData(text: widget.verse.verse.arabicText),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Teks Arab disalin'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
      decoration: BoxDecoration(
        color: widget.isPlaying
            ? const Color(0xFFFAFFFE)
            : const Color(0xFFFAFAFA),
        border: Border(
          left: BorderSide(
            color: widget.isPlaying
                ? const Color(0xFF51C878)
                : Colors.transparent,
            width: 3,
          ),
          bottom: const BorderSide(color: Color(0xFFE8EAE9)),
        ),
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
              // Play/pause — only if verse has audio
              if (hasAudio) ...[
                _ActionButton(
                  icon: widget.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  isActive: widget.isPlaying,
                  onTap: widget.onPlayTap,
                ),
                const SizedBox(width: 4),
              ],
              // Copy Arabic text
              _ActionButton(
                icon: Icons.copy_outlined,
                isActive: false,
                onTap: _copyArabicText,
              ),
              const SizedBox(width: 4),
              // Bookmark
              _ActionButton(
                icon: widget.isBookmarked
                    ? Icons.bookmark
                    : Icons.bookmark_outline,
                isActive: widget.isBookmarked,
                onTap: widget.onBookmarkToggle,
              ),
              const SizedBox(width: 4),
              // More
              _ActionButton(
                icon: Icons.more_horiz_rounded,
                isActive: false,
                onTap: () {},
              ),
            ],
          ),

          // Arabic text
          if (widget.showArabic) ...[
            const SizedBox(height: 14),
            Text(
              widget.verse.verse.arabicText,
              style: GoogleFonts.amiri(
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
            const SizedBox(height: 8),
            Text(
              widget.verse.verse.transliteration,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF79747E),
                fontStyle: FontStyle.italic,
                height: 1.6,
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
                color: Color(0xFF51C878),
                letterSpacing: 0.8,
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
    return SizedBox(
      width: 36,
      height: 36,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isPlaying)
            AnimatedBuilder(
              animation: pulseAnim,
              builder: (_, __) => Transform.scale(
                scale: pulseAnim.value,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF51C878).withValues(alpha: 0.25),
                  ),
                ),
              ),
            ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isPlaying
                  ? const Color(0xFF51C878)
                  : const Color(0xFFEEEEEE),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              number.toString(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color:
                    isPlaying ? Colors.white : const Color(0xFF1C1B1F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF51C878).withValues(alpha: 0.12)
              : const Color(0xFFF5F5F5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isActive
              ? const Color(0xFF51C878)
              : const Color(0xFF79747E),
          size: 18,
        ),
      ),
    );
  }
}
