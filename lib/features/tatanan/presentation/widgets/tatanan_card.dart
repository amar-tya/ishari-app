import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/features/tatanan/domain/entities/tatanan_entity.dart';

const _kDark = Color(0xFF111111);
const _kMuted = Color(0xFF777777);
const _kBorder = Color(0xFFE2E8DF);

class TatananCard extends StatelessWidget {
  const TatananCard({
    required this.tatanan,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  final TatananEntity tatanan;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  static const _categoryColors = {
    'Diwan': Color(0xFFE8F5E9),
    'Diba': Color(0xFFFFF3E0),
    'Muradah': Color(0xFFF3E5F5),
    'Rowi': Color(0xFFE3F2FD),
  };

  static const _categoryTextColors = {
    'Diwan': Color(0xFF2E7D32),
    'Diba': Color(0xFFE65100),
    'Muradah': Color(0xFF6A1B9A),
    'Rowi': Color(0xFF0D47A1),
  };

  @override
  Widget build(BuildContext context) {
    final bgColor = _categoryColors[tatanan.category] ?? const Color(0xFFF5F5F5);
    final textColor =
        _categoryTextColors[tatanan.category] ?? const Color(0xFF424242);

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showOptions(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _kBorder, width: 1.5),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Category icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.format_list_numbered_rounded,
                size: 22,
                color: textColor,
              ),
            ),
            const SizedBox(width: 12),
            // Name + meta
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tatanan.name,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _kDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          tatanan.chapterTitle,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${tatanan.verseCount} ayat',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: _kMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Chevron
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: _kMuted,
            ),
          ],
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    unawaited(showModalBottomSheet<void>(
      context: context,
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: Text(
                  'Hapus Tatanan',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _confirmDelete(context);
                },
              ),
            ],
          ),
        ),
      ),
    ));
  }

  void _confirmDelete(BuildContext context) {
    unawaited(showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Hapus Tatanan?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Tatanan "${tatanan.name}" dan semua ayatnya akan dihapus.',
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Batal', style: GoogleFonts.poppins()),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onDelete();
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Hapus', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    ));
  }
}
