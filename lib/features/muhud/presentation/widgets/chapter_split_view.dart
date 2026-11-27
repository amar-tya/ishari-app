import 'package:flutter/material.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/muhud/domain/entities/verse_with_details_entity.dart';
import 'package:ishari/features/muhud/presentation/widgets/paired_chapter_view.dart';
import 'package:ishari/shared/widgets/reader/reader_colors.dart';

const _kDividerHeight = 10.0;
const _kMinPaneHeight = 80.0;

/// The chapter on top and its paired chapter below, with a draggable divider.
class ChapterSplitView extends StatelessWidget {
  const ChapterSplitView({
    required this.chapter,
    required this.splitRatio,
    required this.onDividerDrag,
    required this.scrollController,
    required this.verseSliver,
    required this.pairedVersesBuilder,
    super.key,
  });

  final ChapterEntity chapter;
  final double splitRatio;

  /// Called with the drag distance as a fraction of the view height.
  final ValueChanged<double> onDividerDrag;
  final ScrollController scrollController;
  final Widget verseSliver;
  final Widget Function(List<VerseWithDetailsEntity> verses)
  pairedVersesBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final totalH = constraints.maxHeight;
        final topH = (totalH * splitRatio - _kDividerHeight / 2).clamp(
          _kMinPaneHeight,
          totalH - _kMinPaneHeight - _kDividerHeight,
        );
        final bottomH = totalH - topH - _kDividerHeight;

        return Column(
          children: [
            SizedBox(
              height: topH,
              child: _SplitPane(
                label: chapter.category,
                count: chapter.verseCount,
                child: CustomScrollView(
                  controller: scrollController,
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    verseSliver,
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanUpdate: (details) =>
                  onDividerDrag(details.delta.dy / totalH),
              child: const _SplitDivider(),
            ),
            SizedBox(
              height: bottomH,
              child: PairedChapterView(
                spinnerStrokeWidth: 2,
                loadedBuilder: (state) => _SplitPane(
                  label: state.chapter.category,
                  count: state.chapter.verseCount,
                  isBottom: true,
                  child: pairedVersesBuilder(state.verses),
                ),
                errorBuilder: (message) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: kReaderMuted,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SplitPane extends StatelessWidget {
  const _SplitPane({
    required this.label,
    required this.count,
    required this.child,
    this.isBottom = false,
  });

  final String label;
  final int count;
  final Widget child;
  final bool isBottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 32,
          color: kReaderBackground,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: kReaderMuted,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '$count bait',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: kReaderMuted,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: isBottom
                ? BorderRadius.zero
                : const BorderRadius.vertical(top: Radius.circular(14)),
            child: ColoredBox(
              color: Colors.white,
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

class _SplitDivider extends StatelessWidget {
  const _SplitDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _kDividerHeight,
      color: kReaderBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          7,
          (_) => Container(
            width: 3,
            height: 3,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: const BoxDecoration(
              color: kReaderMuted,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
