import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/muhud/domain/entities/verse_with_details_entity.dart';
import 'package:ishari/features/muhud/presentation/bloc/split_panel_cubit.dart';
import 'package:ishari/features/muhud/presentation/widgets/chapter_app_bar.dart';
import 'package:ishari/features/muhud/presentation/widgets/quick_tools_panel.dart';
import 'package:ishari/features/muhud/presentation/widgets/verse_card.dart';
import 'package:ishari/features/muhud/presentation/widgets/verse_list.dart';

// Categories that support the paired split view
const _kSplitCategories = {'Diwan', 'Diba'};

class ChapterReaderBody extends StatefulWidget {
  const ChapterReaderBody({
    required this.chapter,
    required this.verses,
    required this.bookmarkedVerseIds,
    required this.showTranslation,
    required this.showArabic,
    required this.showTransliteration,
    required this.arabFontSize,
    required this.transliterationFontSize,
    required this.translationFontSize,
    this.playingVerseId,
    this.isEmbeddedInTab = false,
    super.key,
  });

  final ChapterEntity chapter;
  final List<VerseWithDetailsEntity> verses;
  final Set<int> bookmarkedVerseIds;
  final bool showTranslation;
  final bool showArabic;
  final bool showTransliteration;
  final double arabFontSize;
  final double transliterationFontSize;
  final double translationFontSize;
  final int? playingVerseId;
  final bool isEmbeddedInTab;

  @override
  State<ChapterReaderBody> createState() => _ChapterReaderBodyState();
}

class _ChapterReaderBodyState extends State<ChapterReaderBody> {
  bool _showQuickTools = false;
  bool _showTitle = false;
  double _headerOffset = 0;
  bool _isSplitView = false;
  double _splitRatio = 0.5;

  final ScrollController _scrollController = ScrollController();

  static const double _appBarHeight = 52;
  static const double _chapterHeaderHeight = 170;
  static const double _splitDividerHeight = 10;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isSplitView) return;
    final offset = _scrollController.offset.clamp(0.0, _chapterHeaderHeight);
    final showTitle = _scrollController.offset >= _chapterHeaderHeight;
    if (offset != _headerOffset || showTitle != _showTitle) {
      setState(() {
        _headerOffset = offset;
        _showTitle = showTitle;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleSplitView() {
    setState(() => _isSplitView = !_isSplitView);
    if (_isSplitView) {
      unawaited(
        context.read<SplitPanelCubit>().loadPairedChapter(widget.chapter),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final totalAppBarTop = topPadding + _appBarHeight;
    final showSplitButton = _kSplitCategories.contains(widget.chapter.category);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Layer 1: Light sage background
          const Positioned.fill(
            child: ColoredBox(color: Color(0xFFF0F5EE)),
          ),

          if (_isSplitView) ...[
            // ── SPLIT MODE ──
            // Layer 3: Split pane body (no header)
            Positioned(
              top: totalAppBarTop,
              bottom: 0,
              left: 0,
              right: 0,
              child: LayoutBuilder(
                builder: (ctx, constraints) {
                  final totalH = constraints.maxHeight;
                  final topH = (totalH * _splitRatio - _splitDividerHeight / 2)
                      .clamp(80.0, totalH - 80.0 - _splitDividerHeight);
                  final bottomH =
                      totalH - topH - _splitDividerHeight;

                  return Column(
                    children: [
                      // Top pane — main chapter
                      SizedBox(
                        height: topH,
                        child: _SplitPane(
                          label: widget.chapter.category,
                          count: widget.chapter.verseCount,
                          child: CustomScrollView(
                            controller: _scrollController,
                            physics: const ClampingScrollPhysics(),
                            slivers: [
                              VerseList(
                                verses: widget.verses,
                                bookmarkedVerseIds: widget.bookmarkedVerseIds,
                                showTranslation: widget.showTranslation,
                                showArabic: widget.showArabic,
                                showTransliteration: widget.showTransliteration,
                                arabFontSize: widget.arabFontSize,
                                transliterationFontSize:
                                    widget.transliterationFontSize,
                                translationFontSize: widget.translationFontSize,
                                playingVerseId: widget.playingVerseId,
                              ),
                              const SliverToBoxAdapter(
                                child: SizedBox(height: 24),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Drag divider
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onPanUpdate: (details) {
                          setState(() {
                            _splitRatio = (_splitRatio +
                                    details.delta.dy / totalH)
                                .clamp(0.15, 0.85);
                          });
                        },
                        child: const _SplitDivider(),
                      ),

                      // Bottom pane — paired chapter (read-only)
                      SizedBox(
                        height: bottomH,
                        child: BlocBuilder<SplitPanelCubit, SplitPanelState>(
                          builder: (_, state) => switch (state) {
                            SplitPanelInitial() => const SizedBox.shrink(),
                            SplitPanelLoading() => const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFCAFF00),
                                strokeWidth: 2,
                              ),
                            ),
                            SplitPanelLoaded(
                              chapter: final c,
                              verses: final v,
                            ) =>
                              _SplitPane(
                                label: c.category,
                                count: c.verseCount,
                                isBottom: true,
                                child: ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: v.length,
                                  itemBuilder: (_, i) => VerseCard(
                                    verse: v[i],
                                    isBookmarked: false,
                                    isPlaying: false,
                                    showTranslation: widget.showTranslation,
                                    showArabic: widget.showArabic,
                                    showTransliteration:
                                        widget.showTransliteration,
                                    arabFontSize: widget.arabFontSize,
                                    transliterationFontSize:
                                        widget.transliterationFontSize,
                                    translationFontSize:
                                        widget.translationFontSize,
                                    onBookmarkToggle: () {},
                                    onPlayTap: () {},
                                  ),
                                ),
                              ),
                            SplitPanelError(message: final m) => Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  m,
                                  style: const TextStyle(
                                    color: Color(0xFF777777),
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ] else ...[
            // ── NORMAL MODE ──
            // Layer 2: Chapter header
            Positioned(
              top: totalAppBarTop,
              left: 0,
              right: 0,
              child: _ChapterHeader(chapter: widget.chapter),
            ),

            // Layer 3: White scrollable verse sheet
            Positioned(
              top: totalAppBarTop +
                  _chapterHeaderHeight -
                  _headerOffset,
              bottom: 0,
              left: 0,
              right: 0,
              child: _WhiteVerseSheet(
                rounded: _showTitle,
                scrollController: _scrollController,
                verses: widget.verses,
                bookmarkedVerseIds: widget.bookmarkedVerseIds,
                showTranslation: widget.showTranslation,
                showArabic: widget.showArabic,
                showTransliteration: widget.showTransliteration,
                arabFontSize: widget.arabFontSize,
                transliterationFontSize: widget.transliterationFontSize,
                translationFontSize: widget.translationFontSize,
                playingVerseId: widget.playingVerseId,
              ),
            ),
          ],

          // Layer 4: App bar — always on top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: ChapterAppBar(
                isEmbeddedInTab: widget.isEmbeddedInTab,
                onOpenQuickTools: () =>
                    setState(() => _showQuickTools = true),
                title: widget.chapter.title,
                showTitle: _isSplitView || _showTitle,
                showSplitButton: showSplitButton,
                isSplitView: _isSplitView,
                onToggleSplitView: _toggleSplitView,
              ),
            ),
          ),

          // Layer 5: Quick tools overlay
          if (_showQuickTools)
            Positioned.fill(
              child: QuickToolsPanel(
                onClose: () => setState(() => _showQuickTools = false),
                showArabic: widget.showArabic,
                showTransliteration: widget.showTransliteration,
                showTranslation: widget.showTranslation,
                arabFontSize: widget.arabFontSize,
                transliterationFontSize: widget.transliterationFontSize,
                translationFontSize: widget.translationFontSize,
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Normal mode widgets (unchanged behaviour)
// ─────────────────────────────────────────

class _ChapterHeader extends StatelessWidget {
  const _ChapterHeader({required this.chapter});

  final ChapterEntity chapter;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF0F5EE),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 4, 22, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'DIWAN \u2022 ${chapter.verseCount} BAIT',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: Color(0xFF777777),
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              chapter.description,
              textAlign: TextAlign.right,
              maxLines: 2,
              style: GoogleFonts.scheherazadeNew(
                fontSize: 44,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF111111),
                height: 1.2,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 5, 16, 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFCAFF00),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  chapter.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111111),
                    height: 1,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Kitab ${chapter.category}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF777777),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WhiteVerseSheet extends StatelessWidget {
  const _WhiteVerseSheet({
    required this.rounded,
    required this.scrollController,
    required this.verses,
    required this.bookmarkedVerseIds,
    required this.showTranslation,
    required this.showArabic,
    required this.showTransliteration,
    required this.arabFontSize,
    required this.transliterationFontSize,
    required this.translationFontSize,
    this.playingVerseId,
  });

  final bool rounded;
  final ScrollController scrollController;
  final List<VerseWithDetailsEntity> verses;
  final Set<int> bookmarkedVerseIds;
  final bool showTranslation;
  final bool showArabic;
  final bool showTransliteration;
  final double arabFontSize;
  final double transliterationFontSize;
  final double translationFontSize;
  final int? playingVerseId;

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
          slivers: [
            VerseList(
              verses: verses,
              bookmarkedVerseIds: bookmarkedVerseIds,
              showTranslation: showTranslation,
              showArabic: showArabic,
              showTransliteration: showTransliteration,
              arabFontSize: arabFontSize,
              transliterationFontSize: transliterationFontSize,
              translationFontSize: translationFontSize,
              playingVerseId: playingVerseId,
            ),
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

// ─────────────────────────────────────────
// Split mode widgets
// ─────────────────────────────────────────

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
        // Pane header
        Container(
          height: 32,
          color: const Color(0xFFF0F5EE),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF777777),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '$count bait',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF777777),
                ),
              ),
            ],
          ),
        ),
        // Verse scroll area
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
      height: 10,
      color: const Color(0xFFF0F5EE),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          7,
          (_) => Container(
            width: 3,
            height: 3,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: const BoxDecoration(
              color: Color(0xFF777777),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
