import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';

/// Liquid-glass chapter card for the masonry grid.
///
/// [glassColor] is the base tint applied with low opacity.
/// [isTall] makes the card taller (used for the left "hero" card in the grid).
class ChapterCard extends StatelessWidget {
  const ChapterCard({
    super.key,
    required this.chapter,
    required this.glassColor,
    this.isTall = false,
    this.onTap,
  });

  final ChapterEntity chapter;
  final Color glassColor;
  final bool isTall;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final numLabel = chapter.number != null
        ? chapter.number!.toString().padLeft(2, '0')
        : '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 160),
        decoration: BoxDecoration(
          color: glassColor.withValues(alpha: 0.20),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: glassColor.withValues(alpha: 0.25),
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Stack(
          children: [
            // Arabic watermark in top-right corner
            Positioned(
              top: -4,
              right: 0,
              child: Opacity(
                opacity: 0.10,
                child: Text(
                  chapter.description,
                  style: GoogleFonts.scheherazadeNew(
                    fontSize: 45,
                    color: Colors.white,
                    height: 1,
                  ),
                  textDirection: TextDirection.rtl,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
              ),
            ),

            // Card content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Number
                if (numLabel.isNotEmpty)
                  Text(
                    numLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),

                const Spacer(),

                // Arabic text — tepat di atas footer
                Text(
                  chapter.description,
                  style: GoogleFonts.scheherazadeNew(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.65,
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Footer: name + bait count + bookmark icon
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chapter.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${chapter.verseCount} bait',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.bookmark_outline,
                      size: 16,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
