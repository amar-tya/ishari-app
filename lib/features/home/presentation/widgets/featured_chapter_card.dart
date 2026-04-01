import 'package:flutter/material.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';

/// Full-width gradient card for the featured / last-read chapter.
class FeaturedChapterCard extends StatelessWidget {
  const FeaturedChapterCard({
    required this.chapter,
    required this.isGuest,
    super.key,
    this.onTap,
  });

  final ChapterEntity chapter;
  final bool isGuest;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final label = isGuest ? 'Mulai Baca' : 'Lanjutkan Membaca';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF51C878), Color(0xFF3DA85F)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x5951C878),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                top: -30,
                right: 60,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x14FFFFFF),
                  ),
                ),
              ),
              Positioned(
                bottom: -40,
                right: -20,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x0FFFFFFF),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            label.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xCCFFFFFF),
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            chapter.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${chapter.category}  ·  ${chapter.verseCount} bait',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xBFFFFFFF),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Play button
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0x40FFFFFF),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0x80FFFFFF),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
