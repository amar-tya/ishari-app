import 'package:flutter/material.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/home/presentation/widgets/chapter_card.dart';

/// True 2-column masonry grid: odd-indexed chapters go in the left column,
/// even-indexed in the right. Each card takes its natural height.
///
/// Cards cycle through [light → dark → lime → light …] variants.
class ChapterMasonryGrid extends StatelessWidget {
  const ChapterMasonryGrid({
    required this.chapters,
    super.key,
    this.onChapterTap,
  });

  final List<ChapterEntity> chapters;
  final void Function(ChapterEntity)? onChapterTap;

  @override
  Widget build(BuildContext context) {
    if (chapters.isEmpty) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(16, 14, 16, 0),
        child: Text(
          'Belum ada chapter untuk kategori ini.',
          style: TextStyle(color: Color(0xFF777777), fontSize: 14),
        ),
      );
    }

    // Distribute: index 0,2,4… → left column; 1,3,5… → right column
    final left = <(int, ChapterEntity)>[];
    final right = <(int, ChapterEntity)>[];
    for (var i = 0; i < chapters.length; i++) {
      if (i.isEven) {
        left.add((i, chapters[i]));
      } else {
        right.add((i, chapters[i]));
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _MasonryColumn(items: left, onTap: onChapterTap),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _MasonryColumn(items: right, onTap: onChapterTap),
          ),
        ],
      ),
    );
  }
}

class _MasonryColumn extends StatelessWidget {
  const _MasonryColumn({required this.items, this.onTap});

  final List<(int, ChapterEntity)> items;
  final void Function(ChapterEntity)? onTap;

  static const List<ChapterCardVariant> _variants = [
    ChapterCardVariant.light,
    ChapterCardVariant.dark,
    ChapterCardVariant.lime,
  ];

  ChapterCardVariant _variant(int index) => _variants[index % _variants.length];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (index, chapter) in items) ...[
          ChapterCard(
            chapter: chapter,
            variant: _variant(index),
            onTap: () => onTap?.call(chapter),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
