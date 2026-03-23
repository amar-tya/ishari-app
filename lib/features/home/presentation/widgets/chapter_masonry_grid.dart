import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/home/presentation/widgets/chapter_card.dart';

/// 2-column masonry grid for chapter cards on the dark glass section.
///
/// First row: tall card on the left, two stacked cards on the right.
/// Subsequent rows: two equal cards side-by-side.
class ChapterMasonryGrid extends StatelessWidget {
  const ChapterMasonryGrid({
    super.key,
    required this.chapters,
    this.onChapterTap,
  });

  final List<ChapterEntity> chapters;
  final void Function(ChapterEntity)? onChapterTap;

  // Card glass tints cycling through the list
  static const _tints = [
    Color(0xFF22C55E), // green
    Color(0xFF6366F1), // indigo
    Color(0xFFA855F7), // violet
    Color(0xFFFBBF24), // amber
    Color(0xFFF43F5E), // rose
    Color(0xFF38BDF8), // sky
  ];

  Color _tint(int index) => _tints[index % _tints.length];

  @override
  Widget build(BuildContext context) {
    if (chapters.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Text(
          'Belum ada chapter untuk kategori ini.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 14,
          ),
        ),
      );
    }

    final widgets = <Widget>[];

    // First row: tall card (index 0) + 2 stacked cards (index 1 & 2)
    final firstRow = _buildFirstRow(chapters);
    widgets.add(firstRow);

    // Additional rows: pairs starting at index 3
    for (var i = 3; i < chapters.length; i += 2) {
      final left = chapters[i];
      final right = i + 1 < chapters.length ? chapters[i + 1] : null;
      widgets.add(const SizedBox(height: 10));
      widgets.add(_buildEqualRow(left, i, right, i + 1));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: widgets),
    );
  }

  Widget _buildFirstRow(List<ChapterEntity> list) {
    final tall = list[0];
    final topRight = list.length > 1 ? list[1] : null;
    final botRight = list.length > 2 ? list[2] : null;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tall left card
          Expanded(
            child: ChapterCard(
              chapter: tall,
              glassColor: _tint(0),
              isTall: true,
              onTap: () => onChapterTap?.call(tall),
            ),
          ),
          const SizedBox(width: 10),
          // Right column
          Expanded(
            child: Column(
              children: [
                if (topRight != null)
                  Expanded(
                    child: ChapterCard(
                      chapter: topRight,
                      glassColor: _tint(1),
                      onTap: () => onChapterTap?.call(topRight),
                    ),
                  ),
                if (topRight != null && botRight != null)
                  const SizedBox(height: 10),
                if (botRight != null)
                  Expanded(
                    child: ChapterCard(
                      chapter: botRight,
                      glassColor: _tint(2),
                      onTap: () => onChapterTap?.call(botRight),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEqualRow(
    ChapterEntity left,
    int li,
    ChapterEntity? right,
    int ri,
  ) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ChapterCard(
              chapter: left,
              glassColor: _tint(li),
              onTap: () => onChapterTap?.call(left),
            ),
          ),
          if (right != null) ...[
            const SizedBox(width: 10),
            Expanded(
              child: ChapterCard(
                chapter: right,
                glassColor: _tint(ri),
                onTap: () => onChapterTap?.call(right),
              ),
            ),
          ] else
            const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
