import 'package:flutter/material.dart';
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
                style: const TextStyle(
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
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1C1B1F),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${chapter.verseCount} Bait | ${chapter.category}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF79747E),
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
                style: const TextStyle(
                  fontFamily: 'Scheherazade',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF51C878),
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
