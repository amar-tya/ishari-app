import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/features/tatanan/domain/entities/tatanan_verse_entity.dart';

const _kDark = Color(0xFF111111);
const _kMuted = Color(0xFF777777);
const _kBorder = Color(0xFFE2E8DF);

class TatananVerseItem extends StatelessWidget {
  const TatananVerseItem({
    required this.verse,
    required this.isEditMode,
    this.onRemove,
    this.showArabic = true,
    this.showTransliteration = true,
    this.arabFontSize = 20.0,
    this.transliterationFontSize = 12.0,
    super.key,
  });

  final TatananVerseEntity verse;
  final bool isEditMode;
  final VoidCallback? onRemove;
  final bool showArabic;
  final bool showTransliteration;
  final double arabFontSize;
  final double transliterationFontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kBorder, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Position badge
          Container(
            width: 40,
            padding: const EdgeInsets.only(top: 14, left: 12),
            child: Text(
              '${verse.position}',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _kMuted,
              ),
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Arabic text
                  if (showArabic)
                    Text(
                      verse.arabicText,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: GoogleFonts.scheherazadeNew(
                        fontSize: arabFontSize,
                        color: _kDark,
                        height: 1.8,
                      ),
                    ),
                  if (showTransliteration &&
                      verse.transliteration.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      verse.transliteration,
                      style: GoogleFonts.poppins(
                        fontSize: transliterationFontSize,
                        fontStyle: FontStyle.italic,
                        color: _kMuted,
                        height: 1.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // Edit mode controls
          if (isEditMode) ...[
            Column(
              children: [
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    size: 20,
                    color: Colors.red,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(
                    Icons.drag_handle_rounded,
                    size: 20,
                    color: _kMuted,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
