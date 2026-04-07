import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';

class ChapterListItem extends StatelessWidget {
  const ChapterListItem({
    required this.chapter,
    required this.onTap,
    super.key,
  });

  final ChapterEntity chapter;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final number = chapter.number ?? 0;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            // Number badge — simple green circle
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFF51C878),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                number.toString(),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Title + meta
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chapter.title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                      color: const Color(0xFF1C1B1F),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${chapter.verseCount} Bait | ${chapter.category}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: const Color(0xFF79747E),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            // Arabic text (description)
            if (chapter.description.isNotEmpty)
              Text(
                chapter.description,
                style: GoogleFonts.scheherazadeNew(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  color: const Color(0x8051C878),
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
          ],
        ),
      ),
    );
  }
}
