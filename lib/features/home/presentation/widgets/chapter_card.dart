import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';

enum ChapterCardVariant { light, dark, lime }

/// Chapter card for the masonry grid.
///
/// Three visual variants: [light] (white), [dark] (#111111), [lime] (#CAFF00).
/// Arabic title is displayed large with a graffiti-style text shadow.
class ChapterCard extends StatelessWidget {
  const ChapterCard({
    required this.chapter,
    super.key,
    this.variant = ChapterCardVariant.light,
    this.onTap,
  });

  final ChapterEntity chapter;
  final ChapterCardVariant variant;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = _ColorsForVariant(variant);
    final numLabel = chapter.number != null
        ? chapter.number!.toString().padLeft(2, '0')
        : '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.cardBg,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 1),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Number badge
              if (numLabel.isNotEmpty)
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: colors.badgeBg,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.badgeBorder),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      numLabel,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: colors.badgeText,
                      ),
                    ),
                  ),
                ),

              // Arabic title
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 6),
                child: Text(
                  chapter.description,
                  style: GoogleFonts.scheherazadeNew(
                    fontSize: colors.arabicFontSize,
                    fontWeight: FontWeight.w900,
                    color: colors.arabicText,
                    height: 1.6,
                    letterSpacing: -1,
                    shadows: colors.arabicShadows,
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                ),
              ),

              const SizedBox(height: 5),

              // Latin translation
              Text(
                chapter.title,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: colors.latinText,
                  letterSpacing: 0.2,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Footer: source + arrow button
              Row(
                children: [
                  Text(
                    '${chapter.category} · ${chapter.verseCount} bait',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: colors.sourceText,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: colors.arrowBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: colors.arrowIcon,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorsForVariant {
  _ColorsForVariant(ChapterCardVariant variant) {
    switch (variant) {
      case ChapterCardVariant.light:
        cardBg = Colors.white;
        badgeBg = const Color(0xFFE8F0E6);
        badgeBorder = const Color(0xFFE2E8DF);
        badgeText = const Color(0xFF777777);
        arabicText = const Color(0xFF111111);
        arabicShadows = const [
          Shadow(
            color: Color(0xFFCAFF00),
            offset: Offset(3, 3),
          ),
          Shadow(
            color: Color(0x2DCAFF00),
            offset: Offset(6, 6),
          ),
        ];
        arabicFontSize = 48;
        latinText = const Color(0xFF777777);
        sourceText = const Color(0xFF777777);
        arrowBg = const Color(0xFF111111);
        arrowIcon = Colors.white;

      case ChapterCardVariant.dark:
        cardBg = const Color(0xFF111111);
        badgeBg = const Color(0x14FFFFFF);
        badgeBorder = const Color(0x1FFFFFFF);
        badgeText = const Color(0x80FFFFFF);
        arabicText = const Color(0xFFCAFF00);
        arabicShadows = const [
          Shadow(
            color: Color(0x33CAFF00),
            offset: Offset(3, 3),
          ),
        ];
        arabicFontSize = 36;
        latinText = const Color(0x73FFFFFF);
        sourceText = const Color(0x59FFFFFF);
        arrowBg = const Color(0xFFCAFF00);
        arrowIcon = const Color(0xFF111111);

      case ChapterCardVariant.lime:
        cardBg = const Color(0xFFCAFF00);
        badgeBg = const Color(0x14000000);
        badgeBorder = const Color(0x1A000000);
        badgeText = const Color(0x80000000);
        arabicText = const Color(0xFF111111);
        arabicShadows = const [
          Shadow(
            color: Color(0x1A000000),
            offset: Offset(3, 3),
          ),
        ];
        arabicFontSize = 36;
        latinText = const Color(0x8C000000);
        sourceText = const Color(0x73000000);
        arrowBg = const Color(0xFF111111);
        arrowIcon = Colors.white;
    }
  }

  late Color cardBg;
  late Color badgeBg;
  late Color badgeBorder;
  late Color badgeText;
  late Color arabicText;
  late List<Shadow> arabicShadows;
  late double arabicFontSize;
  late Color latinText;
  late Color sourceText;
  late Color arrowBg;
  late Color arrowIcon;
}
