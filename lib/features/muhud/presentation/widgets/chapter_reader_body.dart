import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/core/router/navigation_extensions.dart';
import 'package:ishari/core/wizard/wizard_cubit.dart';
import 'package:ishari/core/wizard/wizard_state.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/muhud/domain/entities/verse_with_details_entity.dart';
import 'package:ishari/features/muhud/presentation/bloc/split_panel_cubit.dart';
import 'package:ishari/features/muhud/presentation/widgets/chapter_app_bar.dart';
import 'package:ishari/features/muhud/presentation/widgets/chapter_header.dart';
import 'package:ishari/features/muhud/presentation/widgets/chapter_split_view.dart';
import 'package:ishari/features/muhud/presentation/widgets/chapter_verse_sheet.dart';
import 'package:ishari/features/muhud/presentation/widgets/paired_chapter_view.dart';
import 'package:ishari/features/muhud/presentation/widgets/quick_tools_panel.dart';
import 'package:ishari/features/muhud/presentation/widgets/verse_list.dart';
import 'package:ishari/shared/widgets/reader/reader_coach_mark.dart';
import 'package:ishari/shared/widgets/reader/reader_colors.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

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
    this.initialVerseId,
    this.isEmbeddedInTab = false,
    super.key,
  });

  final ChapterEntity chapter;
  final List<VerseWithDetailsEntity> verses;

  /// Set when opened via a push notification deep link — the reader scrolls
  /// to this verse once, on first build.
  final int? initialVerseId;
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

class _ChapterReaderBodyState extends State<ChapterReaderBody>
    with WizardCoachTrigger<ChapterReaderBody> {
  bool _showQuickTools = false;
  bool _showTitle = false;
  double _headerOffset = 0;
  bool _isSplitView = false;
  double _splitRatio = 0.5;

  final ScrollController _scrollController = ScrollController();

  // Wizard keys
  final GlobalKey _splitBtnKey = GlobalKey();
  final GlobalKey _firstCardKey = GlobalKey();
  bool _stepBShown = false;

  // Deep-link scroll target (push notification → specific verse)
  final GlobalKey _targetVerseKey = GlobalKey();
  bool _targetVerseScrolled = false;

  static const double _appBarHeight = 52;
  static const double _chapterHeaderHeight = 170;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    if (widget.initialVerseId != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _waitForTargetVerse(60),
      );
    }
  }

  /// Poll for [_targetVerseKey]'s context, then scroll it into view. The
  /// target card only mounts once [CustomScrollView.cacheExtent] (set large
  /// in [ChapterVerseSheet]) has laid out that far into the sliver list, so a
  /// single post-frame callback isn't reliable — retry like
  /// [_waitForFirstCard].
  void _waitForTargetVerse(int retriesLeft) {
    if (!mounted || _targetVerseScrolled || _isSplitView) return;
    final ctx = _targetVerseKey.currentContext;
    if (ctx != null) {
      _targetVerseScrolled = true;
      unawaited(
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          alignment: 0.15,
        ),
      );
    } else if (retriesLeft > 0) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _waitForTargetVerse(retriesLeft - 1),
      );
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

  @override
  WizardStep get coachStep => WizardStep.muhudSplit;

  /// Step A: the split button.
  @override
  void showCoach() {
    if (!mounted) return;
    final wizard = context.read<WizardCubit>();
    showReaderCoachMark(
      context,
      wizard: wizard,
      targets: [
        // The overlay keeps the tap to itself: the user taps the split button
        // again after the coach mark closes.
        readerCoachTarget(
          identify: 'split_btn',
          keyTarget: _splitBtnKey,
          shape: ShapeLightFocus.Circle,
          step: '1/4',
          title: 'Split Screen',
          body:
              'Buka split screen untuk membaca teks Arab dan terjemahan '
              'secara berdampingan.',
          hint: 'Tap tombol "Diba / Diwan" untuk membuka',
        ),
      ],
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
    );
  }

  /// Poll setiap frame hingga split view terbuka DAN [_firstCardKey] memiliki
  /// RenderObject yang valid, lalu tampilkan Step B coach mark.
  ///
  /// Guard [_isSplitView] wajib: [_firstCardKey] juga di-assign ke
  /// [ChapterVerseSheet] di normal mode, sehingga key sudah ada sebelum split
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
    showReaderCoachMark(
      context,
      wizard: context.read<WizardCubit>(),
      targets: [
        readerCoachTarget(
          identify: 'play_btn',
          keyTarget: _firstCardKey,
          shape: ShapeLightFocus.RRect,
          radius: 12,
          step: '2/4',
          title: 'Putar Audio',
          body:
              'Dengarkan shalawat sambil membaca. Tap tombol ▶ di bait ini '
              'untuk memulai.',
          hint: 'Tap bait untuk memilih audio',
        ),
      ],
      onFinish: () {
        if (!mounted) return;
        final w = context.read<WizardCubit>();

        // Pop chapter reader kembali ke MainScaffold.
        context.popOrHome();

        // Tunggu animasi pop GoRouter selesai sebelum advance wizard.
        // ModalRoute.of(context).isActive tidak reliable dengan GoRouter
        // (page-based routing) — route object tidak di-update setelah pop,
        // sehingga polling loop tidak pernah keluar → w.advance() tidak
        // pernah dipanggil → tab tour di MainScaffold tidak pernah dimulai.
        // 400ms > durasi animasi MaterialPage default (~300ms).
        // w di-capture sebelum widget unmount — aman dipanggil dari Future.
        Future.delayed(
          const Duration(milliseconds: 400),
          w.advance,
        ); // muhudAudio → tabBeranda
      },
    );
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  Widget _verseSliver({int? targetVerseId}) {
    return VerseList(
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
      targetVerseId: targetVerseId,
      targetVerseKey: _targetVerseKey,
    );
  }

  Widget _pairedVerses(List<VerseWithDetailsEntity> verses) {
    return PairedVerseList(
      verses: verses,
      showTranslation: widget.showTranslation,
      showArabic: widget.showArabic,
      showTransliteration: widget.showTransliteration,
      arabFontSize: widget.arabFontSize,
      transliterationFontSize: widget.transliterationFontSize,
      translationFontSize: widget.translationFontSize,
      physics: const ClampingScrollPhysics(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final totalAppBarTop = topPadding + _appBarHeight;
    final showSplitButton = kSplitViewCategories.contains(
      widget.chapter.category,
    );

    return BlocListener<WizardCubit, WizardState>(
      listener: onWizardState,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Layer 1: Background
            const Positioned.fill(
              child: ColoredBox(color: kReaderBackground),
            ),

            if (_isSplitView) ...[
              // ── SPLIT MODE ──
              Positioned(
                top: totalAppBarTop,
                bottom: 0,
                left: 0,
                right: 0,
                child: ChapterSplitView(
                  chapter: widget.chapter,
                  splitRatio: _splitRatio,
                  onDividerDrag: (fraction) => setState(() {
                    _splitRatio = (_splitRatio + fraction).clamp(0.15, 0.85);
                  }),
                  scrollController: _scrollController,
                  verseSliver: _verseSliver(),
                  pairedVersesBuilder: _pairedVerses,
                ),
              ),
            ] else ...[
              // ── NORMAL MODE ──
              Positioned(
                top: totalAppBarTop,
                left: 0,
                right: 0,
                child: ChapterHeader(chapter: widget.chapter),
              ),
              Positioned(
                top: totalAppBarTop + _chapterHeaderHeight - _headerOffset,
                bottom: 0,
                left: 0,
                right: 0,
                child: ChapterVerseSheet(
                  rounded: _showTitle,
                  scrollController: _scrollController,
                  verseSliver: _verseSliver(
                    targetVerseId: widget.initialVerseId,
                  ),
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
