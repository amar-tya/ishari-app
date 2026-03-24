import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';

/// Flat chapter card for the masonry grid.
///
/// [accentColor] is used for the number badge, left strip, and subtle tint.
/// [isTall] makes the card taller (used for the left "hero" card in the grid).
class ChapterCard extends StatelessWidget {
  const ChapterCard({
    super.key,
    required this.chapter,
    required this.accentColor,
    this.isTall = false,
    this.onTap,
  });

  final ChapterEntity chapter;
  final Color accentColor;
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
        constraints: const BoxConstraints(minHeight: 148),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left accent strip
              Container(
                width: 4,
                color: accentColor,
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
                  child: Stack(
                    children: [
                      // Arabic watermark
                      Positioned(
                        top: -2,
                        right: 0,
                        child: Opacity(
                          opacity: 0.07,
                          child: Text(
                            chapter.description,
                            style: GoogleFonts.scheherazadeNew(
                              fontSize: 44,
                              color: accentColor,
                              height: 1,
                            ),
                            textDirection: TextDirection.rtl,
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ),

                      // Card body
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Number badge
                          if (numLabel.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: accentColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                numLabel,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                  color: accentColor,
                                ),
                              ),
                            ),

                          const Spacer(),

                          // Arabic excerpt
                          Text(
                            chapter.description,
                            style: GoogleFonts.scheherazadeNew(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF222222),
                              height: 1.6,
                            ),
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),

                          // Title + verse count
                          Text(
                            chapter.title,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF111111),
                              letterSpacing: -0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${chapter.verseCount} bait',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFAAAAAA),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
