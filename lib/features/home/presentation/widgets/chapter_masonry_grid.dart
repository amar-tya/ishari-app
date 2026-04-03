import 'package:flutter/material.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/home/presentation/widgets/chapter_card.dart';
import 'package:ishari/shared/widgets/native_ad_card.dart';

/// True 2-column masonry grid.
///
/// Builds a flat list of [_GridItem]s — chapters interspersed with ad slots
/// every 4 chapters — then distributes them across left and right columns
/// (even flat-index → left, odd → right). Native ads appear as single-column
/// items matching the visual size of a chapter card.
class ChapterMasonryGrid extends StatelessWidget {
  const ChapterMasonryGrid({
    required this.chapters,
    super.key,
    this.onChapterTap,
  });

  final List<ChapterEntity> chapters;
  final void Function(ChapterEntity)? onChapterTap;

  static const List<ChapterCardVariant> _variants = [
    ChapterCardVariant.light,
    ChapterCardVariant.dark,
    ChapterCardVariant.lime,
  ];

  ChapterCardVariant _variant(int chapterIndex) =>
      _variants[chapterIndex % _variants.length];

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

    // Build flat list: insert an ad marker after every 4 chapters.
    final items = <_GridItem>[];
    for (var i = 0; i < chapters.length; i++) {
      items.add(_ChapterItem(chapters[i], i));
      if ((i + 1) % 4 == 0) items.add(const _AdItem());
    }

    // Distribute to columns: even flat-index → left, odd → right.
    final left = <_GridItem>[];
    final right = <_GridItem>[];
    for (var i = 0; i < items.length; i++) {
      if (i.isEven) {
        left.add(items[i]);
      } else {
        right.add(items[i]);
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _MasonryColumn(
              items: left,
              onTap: onChapterTap,
              variant: _variant,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _MasonryColumn(
              items: right,
              onTap: onChapterTap,
              variant: _variant,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Grid item types
// ─────────────────────────────────────────────────────────────────────────────

sealed class _GridItem {
  const _GridItem();
}

class _ChapterItem extends _GridItem {
  const _ChapterItem(this.chapter, this.index);
  final ChapterEntity chapter;
  final int index;
}

class _AdItem extends _GridItem {
  const _AdItem();
}

// ─────────────────────────────────────────────────────────────────────────────
// Column
// ─────────────────────────────────────────────────────────────────────────────

class _MasonryColumn extends StatelessWidget {
  const _MasonryColumn({
    required this.items,
    required this.variant,
    this.onTap,
  });

  final List<_GridItem> items;
  final ChapterCardVariant Function(int chapterIndex) variant;
  final void Function(ChapterEntity)? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final item in items) ...[
          switch (item) {
            _ChapterItem(:final chapter, :final index) => ChapterCard(
                chapter: chapter,
                variant: variant(index),
                onTap: () => onTap?.call(chapter),
              ),
            _AdItem() => const NativeAdCard(),
          },
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
