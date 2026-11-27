import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/features/tatanan/domain/entities/tatanan_entity.dart';
import 'package:ishari/shared/widgets/reader/reader_colors.dart';

class TatananAppBar extends StatelessWidget {
  const TatananAppBar({
    required this.topPad,
    required this.tatanan,
    required this.isEditMode,
    required this.isSplitView,
    required this.showSplitButton,
    required this.verseCount,
    required this.onToggleEdit,
    required this.onToggleSplit,
    required this.onOpenQuickTools,
    this.editBtnKey,
    this.splitBtnKey,
    super.key,
  });

  final double topPad;
  final TatananEntity tatanan;
  final bool isEditMode;
  final bool isSplitView;
  final bool showSplitButton;
  final int verseCount;
  final VoidCallback onToggleEdit;
  final VoidCallback onToggleSplit;
  final VoidCallback onOpenQuickTools;
  final GlobalKey? editBtnKey;
  final GlobalKey? splitBtnKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, topPad + 4, 8, 4),
      child: Row(
        children: [
          const BackButton(color: kReaderDark),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tatanan.name,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: kReaderDark,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${tatanan.chapterTitle} · $verseCount ayat',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: kReaderMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (showSplitButton)
            _IconBtn(
              key: splitBtnKey,
              icon: isSplitView
                  ? Icons.fullscreen_rounded
                  : Icons.vertical_split_rounded,
              isActive: isSplitView,
              onTap: onToggleSplit,
              label: isSplitView ? 'Tutup Diba' : 'Buka Diba',
            ),
          _IconBtn(
            key: editBtnKey,
            icon: isEditMode ? Icons.check_rounded : Icons.edit_outlined,
            isActive: isEditMode,
            onTap: onToggleEdit,
          ),
          _IconBtn(
            icon: Icons.tune_rounded,
            isActive: false,
            onTap: onOpenQuickTools,
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({
    required this.icon,
    required this.isActive,
    required this.onTap,
    this.label,
    super.key,
  });

  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: label != null
            ? const EdgeInsets.symmetric(horizontal: 10)
            : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: isActive ? kReaderDark : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: kReaderBorder, width: 1.5),
        ),
        child: label == null
            ? SizedBox(
                width: 36,
                child: Icon(
                  icon,
                  size: 18,
                  color: isActive ? kReaderLime : kReaderDark,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: isActive ? kReaderLime : kReaderDark,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label!,
                    style: TextStyle(
                      fontSize: 11,
                      color: isActive ? kReaderLime : kReaderDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
