import 'package:flutter/material.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/home/presentation/widgets/chapter_card.dart';
import 'package:ishari/shared/widgets/native_ad_card.dart';

/// True 2-column masonry grid.
///
/// Chapters are split into sections of [_chaptersPerAd]. Each section is laid
/// out as its own masonry (even index → left column, odd → right). When ads
/// are enabled, a full-width native ad sits between sections — never as a
/// tile inside the grid, so it can't be mistaken for a chapter card (AdMob
/// "ads disguised as content" policy).
class ChapterMasonryGrid extends StatelessWidget {
  const ChapterMasonryGrid({
    required this.chapters,
    super.key,
    this.onChapterTap,
  });

  final List<ChapterEntity> chapters;
  final void Function(ChapterEntity)? onChapterTap;

  static const int _chaptersPerAd = 8;

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

    final withAds =
        chapters.length > _chaptersPerAd && NativeAdCard.isEnabled;
    final sectionSize = withAds ? _chaptersPerAd : chapters.length;

    final children = <Widget>[];
    for (var start = 0; start < chapters.length; start += sectionSize) {
      final end = (start + sectionSize).clamp(0, chapters.length);
      children.add(
        _MasonrySection(
          chapters: chapters,
          start: start,
          end: end,
          onTap: onChapterTap,
          variant: _variant,
        ),
      );
      // Ads only go between sections, never after the last one, so they
      // don't stack next to the banner below the grid.
      if (withAds && end < chapters.length) {
        children.add(
          const Padding(
            padding: EdgeInsets.only(top: 6, bottom: 16),
            child: NativeAdCard(),
          ),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section — a 2-column masonry of chapters[start, end)
// ─────────────────────────────────────────────────────────────────────────────

class _MasonrySection extends StatelessWidget {
  const _MasonrySection({
    required this.chapters,
    required this.start,
    required this.end,
    required this.variant,
    this.onTap,
  });

  final List<ChapterEntity> chapters;
  final int start;
  final int end;
  final ChapterCardVariant Function(int chapterIndex) variant;
  final void Function(ChapterEntity)? onTap;

  Widget _column(int parity) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = start; i < end; i++)
          if ((i - start) % 2 == parity) ...[
            ChapterCard(
              chapter: chapters[i],
              variant: variant(i),
              onTap: () => onTap?.call(chapters[i]),
            ),
            const SizedBox(height: 10),
          ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _column(0)),
        const SizedBox(width: 10),
        Expanded(child: _column(1)),
      ],
    );
  }
}
