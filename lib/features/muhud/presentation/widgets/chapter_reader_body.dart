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

  static const double _appBarHeight = 56.0;
  static const double _chapterHeaderHeight = 120.0;

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
          // Layer 1: Green gradient background (full screen)
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF51C878), Color(0xFF45B868)],
                ),
              ),
            ),
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
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF51C878), Color(0xFF45B868)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 6, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 5,
          children: [
            Text(
              chapter.title,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.3,
              ),
            ),
            Text(
              chapter.description,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.scheherazadeNew(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.white,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Kitab ${chapter.category} • ${chapter.verseCount} Ayat',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.8),
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
          ? const BorderRadius.vertical(top: Radius.circular(40))
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
