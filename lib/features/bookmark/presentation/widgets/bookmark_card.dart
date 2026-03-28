import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/features/muhud/domain/entities/bookmarked_verse_entity.dart';

const _kMonths = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
];

String _formatDate(DateTime dt) =>
    '${dt.day} ${_kMonths[dt.month - 1]} ${dt.year}';

/// Color pair (background, foreground) for a category badge.
class _BadgeColors {
  const _BadgeColors(this.bg, this.fg);
  final Color bg;
  final Color fg;
}

_BadgeColors _badgeForCategory(String category) {
  switch (category.toLowerCase()) {
    case 'muhud':
      return const _BadgeColors(Color(0xFFEDE9FE), Color(0xFF6D28D9));
    case 'diba':
      return const _BadgeColors(Color(0xFFFEF3C7), Color(0xFF92400E));
    case 'diwan':
      return const _BadgeColors(Color(0xFFD1FAE5), Color(0xFF065F46));
    case 'syaraful anam':
      return const _BadgeColors(Color(0xFFFEE2E2), Color(0xFF991B1B));
    case 'rowi':
      return const _BadgeColors(Color(0xFFDBEAFE), Color(0xFF1E40AF));
    case 'muradah':
      return const _BadgeColors(Color(0xFFEDFFC0), Color(0xFF3A5C00));
    default:
      return const _BadgeColors(Color(0xFFF3F4F6), Color(0xFF374151));
  }
}

class BookmarkCard extends StatelessWidget {
  const BookmarkCard({
    required this.bookmark,
    required this.onTap,
    required this.onRemove,
    super.key,
  });

  final BookmarkedVerseEntity bookmark;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final badge = _badgeForCategory(bookmark.chapterCategory);
    final dateStr = _formatDate(bookmark.bookmarkedAt);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE2E8DF), width: 1.5),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Top row ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 10, 8),
              child: Row(
                children: [
                  // Category badge
                  Container(
                    height: 22,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: badge.bg,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      bookmark.chapterCategory,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: badge.fg,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Chapter name
                  Expanded(
                    child: Text(
                      bookmark.chapterTitle,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF777777),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // More / remove button
                  GestureDetector(
                    onTap: () => _showRemoveSheet(context),
                    child: const Padding(
                      padding: EdgeInsets.all(6),
                      child: Icon(
                        Icons.more_horiz_rounded,
                        size: 18,
                        color: Color(0xFFAAAAAA),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Arabic text ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                bookmark.arabicText,
                style: GoogleFonts.scheherazadeNew(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF111111),
                  height: 1.7,
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 6),

            // ── Transliteration ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                bookmark.transliteration,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF777777),
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 10),

            // ── Footer ───────────────────────────────────────────────
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFE2E8DF)),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
              child: Row(
                children: [
                  // Verse number badge
                  Container(
                    height: 22,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F5EE),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: const Color(0xFFE2E8DF)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Bait ${bookmark.verseNumber}',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF777777),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Date
                  Text(
                    dateStr,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFAAAAAA),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Read button
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F5EE),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE2E8DF)),
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        size: 14,
                        color: Color(0xFF777777),
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

  void _showRemoveSheet(BuildContext context) {
    unawaited(showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _RemoveSheet(
        chapterTitle: bookmark.chapterTitle,
        verseNumber: bookmark.verseNumber,
        onConfirm: () {
          Navigator.of(context).pop();
          onRemove();
        },
      ),
    ));
  }
}

class _RemoveSheet extends StatelessWidget {
  const _RemoveSheet({
    required this.chapterTitle,
    required this.verseNumber,
    required this.onConfirm,
  });

  final String chapterTitle;
  final int verseNumber;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFD0D8CE),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Hapus Bookmark?',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF111111),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$chapterTitle · Bait $verseNumber\nakan dihapus dari bookmark kamu.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0xFF777777),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: onConfirm,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFF4D4F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: Text(
                'Hapus',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Batal',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF777777),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
