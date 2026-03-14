import 'package:flutter/material.dart';
import 'package:ishari/features/muhud/domain/entities/verse_with_details_entity.dart';

class VerseCard extends StatefulWidget {
  const VerseCard({
    required this.verse,
    required this.isBookmarked,
    required this.isPlaying,
    required this.showTranslation,
    required this.onBookmarkToggle,
    required this.onPlayTap,
    super.key,
  });

  final VerseWithDetailsEntity verse;
  final bool isBookmarked;
  final bool isPlaying;
  final bool showTranslation;
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: widget.isPlaying ? const Color(0xFFE8F5E9) : Colors.white,
        border: Border.all(
          color: widget.isPlaying
              ? const Color(0xFF51C878)
              : const Color(0xFFE8EAE9),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _VerseNumberBadge(
                number: widget.verse.verse.verseNumber,
                isPlaying: widget.isPlaying,
                pulseAnim: _pulseAnim,
              ),
              const SizedBox(width: 10),
              _PlayPauseButton(
                isPlaying: widget.isPlaying,
                onTap: widget.onPlayTap,
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  widget.isBookmarked
                      ? Icons.bookmark
                      : Icons.bookmark_outline,
                  color: widget.isBookmarked
                      ? const Color(0xFF51C878)
                      : const Color(0xFF79747E),
                  size: 22,
                ),
                onPressed: widget.onBookmarkToggle,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            widget.verse.verse.arabicText,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1B1F),
              height: 2.0,
              fontFamily: 'Amiri',
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
          if (widget.verse.verse.transliteration.isNotEmpty) ...[
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
          if (widget.showTranslation && translation != null) ...[
            const SizedBox(height: 10),
            const Text(
              'TERJEMAHAN',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF79747E),
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
      width: 40,
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isPlaying)
            AnimatedBuilder(
              animation: pulseAnim,
              builder: (_, __) => Transform.scale(
                scale: pulseAnim.value,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF51C878).withValues(alpha: 0.25),
                  ),
                ),
              ),
            ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isPlaying ? const Color(0xFF51C878) : const Color(0xFFF0F0F0),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              number.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isPlaying ? Colors.white : const Color(0xFF1C1B1F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  const _PlayPauseButton({required this.isPlaying, required this.onTap});

  final bool isPlaying;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFF51C878).withValues(alpha: 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: const Color(0xFF51C878),
          size: 20,
        ),
      ),
    );
  }
}
