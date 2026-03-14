import 'package:flutter/material.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';

/// Individual chapter card used in the horizontal scroll list.
class ChapterCard extends StatelessWidget {
  const ChapterCard({super.key, required this.chapter, this.onTap});

  final ChapterEntity chapter;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final numberLabel = chapter.number != null
        ? chapter.number!.toString().padLeft(2, '0')
        : '';

    return GestureDetector(
      onTap:
          onTap ??
          () {
            // TODO: navigate to ChapterDetailPage
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${chapter.title} — coming soon'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
      child: Container(
        width: 120,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Stack(
          children: [
            // Number badge
            if (numberLabel.isNotEmpty)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF0FAF4),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    numberLabel,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF51C878),
                    ),
                  ),
                ),
              ),
            // Content anchored to bottom
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Arabic decorative char
                  Text(
                    chapter.description,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xFF51C878),
                      height: 1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    chapter.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1C1B1F),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${chapter.verseCount} bait',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF79747E),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Category tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FAF4),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      chapter.category,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF51C878),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
