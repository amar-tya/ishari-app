import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/muhud/domain/entities/verse_with_details_entity.dart';
import 'package:ishari/features/muhud/presentation/widgets/chapter_app_bar.dart';
import 'package:ishari/features/muhud/presentation/widgets/quick_tools_panel.dart';
import 'package:ishari/features/muhud/presentation/widgets/verse_list.dart';

class ChapterReaderBody extends StatefulWidget {
  const ChapterReaderBody({
    required this.chapter,
    required this.verses,
    required this.bookmarkedVerseIds,
    required this.showTranslation,
    required this.showArabic,
    required this.showTransliteration,
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
  final int? playingVerseId;
  final bool isEmbeddedInTab;

  @override
  State<ChapterReaderBody> createState() => _ChapterReaderBodyState();
}

class _ChapterReaderBodyState extends State<ChapterReaderBody> {
  bool _showQuickTools = false;
  bool _showTitle = false;
  double _headerOffset = 0;
  final ScrollController _scrollController = ScrollController();

  static const double _appBarHeight = 52.0;
  static const double _chapterHeaderHeight = 170.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
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

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final totalAppBarTop = topPadding + _appBarHeight;
    final whiteSheetTop = totalAppBarTop + _chapterHeaderHeight - _headerOffset;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Layer 1: Light sage background (full screen)
          const Positioned.fill(
            child: ColoredBox(color: Color(0xFFF0F5EE)),
          ),

          // Layer 2: Chapter header — fixed below app bar
          Positioned(
            top: totalAppBarTop,
            left: 0,
            right: 0,
            child: _ChapterHeader(chapter: widget.chapter),
          ),

          // Layer 3: White scrollable verse sheet — slides up as user scrolls
          Positioned(
            top: whiteSheetTop,
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
              playingVerseId: widget.playingVerseId,
            ),
          ),

          // Layer 4: App bar — always on top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: ChapterAppBar(
                isEmbeddedInTab: widget.isEmbeddedInTab,
                onOpenQuickTools: () => setState(() => _showQuickTools = true),
                title: widget.chapter.title,
                showTitle: _showTitle,
              ),
            ),
          ),

          // Layer 5: Quick tools overlay (conditional)
          if (_showQuickTools)
            Positioned.fill(
              child: QuickToolsPanel(
                onClose: () => setState(() => _showQuickTools = false),
                showArabic: widget.showArabic,
                showTransliteration: widget.showTransliteration,
                showTranslation: widget.showTranslation,
              ),
            ),
        ],
      ),
    );
  }
}

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
            // Label row
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
            // Arabic title
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
            // Transliteration pill
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
            // Subtitle
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
    this.playingVerseId,
  });

  final bool rounded;
  final ScrollController scrollController;
  final List<VerseWithDetailsEntity> verses;
  final Set<int> bookmarkedVerseIds;
  final bool showTranslation;
  final bool showArabic;
  final bool showTransliteration;
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
