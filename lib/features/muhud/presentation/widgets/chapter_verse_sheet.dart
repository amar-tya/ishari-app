import 'package:flutter/material.dart';

/// White sheet holding the chapter's verses below the header.
class ChapterVerseSheet extends StatelessWidget {
  const ChapterVerseSheet({
    required this.rounded,
    required this.scrollController,
    required this.verseSliver,
    super.key,
  });

  final bool rounded;
  final ScrollController scrollController;
  final Widget verseSliver;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: !rounded
          ? const BorderRadius.vertical(top: Radius.circular(20))
          : BorderRadius.zero,
      child: ColoredBox(
        color: Colors.white,
        child: CustomScrollView(
          controller: scrollController,
          physics: const ClampingScrollPhysics(),
          // Chapters are short (verses ~single digits to low tens), so it's
          // cheap to force the whole list to lay out up front — otherwise
          // SliverList only builds near the viewport and the deep-link target
          // verse's context never attaches when it starts off-screen.
          cacheExtent: 20000,
          slivers: [
            verseSliver,
            const SliverToBoxAdapter(
              child: ColoredBox(
                color: Colors.white,
                child: SizedBox(height: 40, width: double.infinity),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
