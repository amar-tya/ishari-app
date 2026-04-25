import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/core/wizard/wizard_cubit.dart';
import 'package:ishari/core/wizard/wizard_state.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/muhud/domain/entities/verse_with_details_entity.dart';
import 'package:ishari/features/muhud/presentation/bloc/split_panel_cubit.dart';
import 'package:ishari/features/muhud/presentation/widgets/chapter_app_bar.dart';
import 'package:ishari/features/muhud/presentation/widgets/quick_tools_panel.dart';
import 'package:ishari/features/muhud/presentation/widgets/verse_card.dart';
import 'package:ishari/features/muhud/presentation/widgets/verse_list.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

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

  // Wizard keys
  final GlobalKey _splitBtnKey = GlobalKey();
  final GlobalKey _firstCardKey = GlobalKey();
  bool _stepAShown = false;
  bool _stepBShown = false;

  static const double _appBarHeight = 52;
  static const double _chapterHeaderHeight = 170;
  static const double _splitDividerHeight = 10;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeStartWizard());
  }

  void _maybeStartWizard() {
    if (!mounted) return;
    final state = context.read<WizardCubit>().state;
    if (state is WizardActive && state.step == WizardStep.muhudSplit && !_stepAShown) {
      _stepAShown = true;
      _showStepACoach();
    }
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

  // ── Wizard coach marks ──────────────────────────────────────────────────────

  void _showStepACoach() {
    if (!mounted) return;
    final wizard = context.read<WizardCubit>();
    TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: 'split_btn',
          keyTarget: _splitBtnKey,
          shape: ShapeLightFocus.Circle,
          // enableTargetTab: true agar tap diteruskan ke tombol Split aslinya.
          // onClickTarget TIDAK memanggil _toggleSplitView() untuk menghindari
          // double-toggle (tombol asli sudah menanganinya sendiri).
          enableOverlayTab: false,
          enableTargetTab: true,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (_, __) => _WizardTooltip(
                step: '1/4',
                title: 'Split Screen',
                body:
                    'Buka split screen untuk membaca teks Arab dan terjemahan secara berdampingan.',
                hint: 'Tap tombol "Diba / Diwan" untuk membuka',
              ),
            ),
          ],
        ),
      ],
      colorShadow: const Color(0xFF111111),
      opacityShadow: 0.88,
      onFinish: () {
        if (!mounted) return;
        wizard.advance(); // muhudSplit → muhudAudio
        // Poll setiap frame hingga _firstCardKey terpasang di render tree
        // sebelum memunculkan coach mark Step B. Menggantikan
        // Future.delayed(300ms) yang tidak deterministik — pada perangkat
        // lambat SliverList bisa belum selesai layout dalam 300ms.
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _waitForFirstCard(60),
        );
      },
      onSkip: () {
        wizard.skip();
        return true;
      },
    ).show(context: context);
  }

  /// Poll setiap frame hingga split view terbuka DAN [_firstCardKey] memiliki
  /// RenderObject yang valid, lalu tampilkan Step B coach mark.
  ///
  /// Guard [_isSplitView] wajib: [_firstCardKey] juga di-assign ke
  /// [_WhiteVerseSheet] di normal mode, sehingga key sudah ada sebelum split
  /// view dibuka. Tanpa guard ini Step B muncul otomatis tanpa user membuka
  /// split view terlebih dahulu.
  void _waitForFirstCard(int retriesLeft) {
    if (!mounted || _stepBShown) return;
    if (!_isSplitView) {
      // Tunggu user tap split button (dari Step A coach mark).
      // Jika retries habis, berhenti — split view tidak pernah dibuka.
      if (retriesLeft <= 0) return;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _waitForFirstCard(retriesLeft - 1),
      );
      return;
    }
    if (_firstCardKey.currentContext != null || retriesLeft <= 0) {
      _stepBShown = true;
      _showStepBCoach();
    } else {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _waitForFirstCard(retriesLeft - 1),
      );
    }
  }

  void _showStepBCoach() {
    if (!mounted) return;
    final wizard = context.read<WizardCubit>();
    TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: 'play_btn',
          keyTarget: _firstCardKey,
          shape: ShapeLightFocus.RRect,
          radius: 12,
          enableOverlayTab: false,
          enableTargetTab: true,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (_, __) => _WizardTooltip(
                step: '2/4',
                title: 'Putar Audio',
                body:
                    'Dengarkan shalawat sambil membaca. Tap tombol ▶ di bait ini untuk memulai.',
                hint: 'Tap bait untuk memilih audio',
              ),
            ),
          ],
        ),
      ],
      colorShadow: const Color(0xFF111111),
      opacityShadow: 0.88,
      onFinish: () {
        if (!mounted) return;
        final w = context.read<WizardCubit>();

        // Pop chapter reader kembali ke MainScaffold.
        context.pop();

        // Tunggu animasi pop GoRouter selesai sebelum advance wizard.
        // ModalRoute.of(context).isActive tidak reliable dengan GoRouter
        // (page-based routing) — route object tidak di-update setelah pop,
        // sehingga polling loop tidak pernah keluar → w.advance() tidak
        // pernah dipanggil → tab tour di MainScaffold tidak pernah dimulai.
        // 400ms > durasi animasi MaterialPage default (~300ms).
        // w di-capture sebelum widget unmount — aman dipanggil dari Future.
        Future.delayed(const Duration(milliseconds: 400), w.advance); // muhudAudio → tabBeranda
      },
      onSkip: () {
        wizard.skip();
        return true;
      },
    ).show(context: context);
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final totalAppBarTop = topPadding + _appBarHeight;
    final showSplitButton = _kSplitCategories.contains(widget.chapter.category);

    return BlocListener<WizardCubit, WizardState>(
      listener: (ctx, state) {
        if (state is WizardActive &&
            state.step == WizardStep.muhudSplit &&
            !_stepAShown) {
          _stepAShown = true;
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _showStepACoach());
        }
      },
      child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                // Layer 1: Background
                const Positioned.fill(
                  child: ColoredBox(color: Color(0xFFF0F5EE)),
                ),

                if (_isSplitView) ...[
                  // ── SPLIT MODE ──
                  Positioned(
                    top: totalAppBarTop,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: LayoutBuilder(
                      builder: (ctx, constraints) {
                        final totalH = constraints.maxHeight;
                        final topH =
                            (totalH * _splitRatio - _splitDividerHeight / 2)
                                .clamp(80.0, totalH - 80.0 - _splitDividerHeight);
                        final bottomH = totalH - topH - _splitDividerHeight;

                        return Column(
                          children: [
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
                                      bookmarkedVerseIds:
                                          widget.bookmarkedVerseIds,
                                      showTranslation: widget.showTranslation,
                                      showArabic: widget.showArabic,
                                      showTransliteration:
                                          widget.showTransliteration,
                                      arabFontSize: widget.arabFontSize,
                                      transliterationFontSize:
                                          widget.transliterationFontSize,
                                      translationFontSize:
                                          widget.translationFontSize,
                                      playingVerseId: widget.playingVerseId,
                                      firstCardKey: _firstCardKey,
                                    ),
                                    const SliverToBoxAdapter(
                                      child: SizedBox(height: 24),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                            SizedBox(
                              height: bottomH,
                              child: BlocBuilder<SplitPanelCubit,
                                  SplitPanelState>(
                                builder: (_, state) => switch (state) {
                                  SplitPanelInitial() =>
                                    const SizedBox.shrink(),
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
                  Positioned(
                    top: totalAppBarTop,
                    left: 0,
                    right: 0,
                    child: _ChapterHeader(chapter: widget.chapter),
                  ),
                  Positioned(
                    top: totalAppBarTop + _chapterHeaderHeight - _headerOffset,
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
                      firstCardKey: _firstCardKey,
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
                      splitBtnKey: _splitBtnKey,
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
          ),
    );
  }
}

// ─────────────────────────────────────────
// Wizard UI widgets
// ─────────────────────────────────────────

class _WizardTooltip extends StatelessWidget {
  const _WizardTooltip({
    required this.step,
    required this.title,
    required this.body,
    required this.hint,
  });

  final String step;
  final String title;
  final String body;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFCAFF00),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  step,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111111),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111111),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF444444),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            hint,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF777777),
              fontStyle: FontStyle.italic,
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
    this.firstCardKey,
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
  final GlobalKey? firstCardKey;

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
              firstCardKey: firstCardKey,
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
