import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';

/// Title block above the verse sheet; the sheet slides over it while scrolling.
class ChapterHeader extends StatelessWidget {
  const ChapterHeader({required this.chapter, super.key});

  final ChapterEntity chapter;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF0F5EE),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 4, 22, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'DIWAN \u2022 ${chapter.verseCount} BAIT',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Color(0xFF777777),
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              chapter.description,
              textAlign: TextAlign.right,
              maxLines: 2,
              style: GoogleFonts.scheherazadeNew(
                fontSize: 44,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF111111),
                height: 1.2,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 5, 16, 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFCAFF00),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  chapter.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111111),
                    height: 1,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Kitab ${chapter.category}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF777777),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
