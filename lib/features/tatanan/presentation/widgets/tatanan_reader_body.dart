import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/core/wizard/wizard_cubit.dart';
import 'package:ishari/core/wizard/wizard_state.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/muhud/presentation/bloc/split_panel_cubit.dart';
import 'package:ishari/features/muhud/presentation/widgets/verse_card.dart';
import 'package:ishari/features/tatanan/domain/entities/tatanan_entity.dart';
import 'package:ishari/features/tatanan/domain/entities/tatanan_verse_entity.dart';
import 'package:ishari/features/tatanan/domain/repositories/tatanan_repository.dart';
import 'package:ishari/features/tatanan/presentation/bloc/tatanan_detail/tatanan_detail_bloc.dart';
import 'package:ishari/features/tatanan/presentation/bloc/tatanan_settings_cubit.dart';
import 'package:ishari/features/tatanan/presentation/widgets/add_verses_sheet.dart';
import 'package:ishari/features/tatanan/presentation/widgets/tatanan_quick_tools_panel.dart';
import 'package:ishari/features/tatanan/presentation/widgets/tatanan_verse_item.dart';
import 'package:ishari/shared/widgets/banner_ad_widget.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

ChapterEntity _tatananToChapterEntity(TatananEntity t) => ChapterEntity(
      id: t.chapterId.toString(),
      title: t.chapterTitle,
      category: t.category,
      description: '',
      number: t.chapterNumber,
    );

const _kBg = Color(0xFFF0F5EE);
const _kDark = Color(0xFF111111);
const _kLime = Color(0xFFCAFF00);
const _kBorder = Color(0xFFE2E8DF);
const _kMuted = Color(0xFF777777);
const _kSplitCategories = {'Diwan', 'Diba'};

class TatananReaderBody extends StatefulWidget {
  const TatananReaderBody({
    required this.tatananId,
    super.key,
  });

  final String tatananId;

  @override
  State<TatananReaderBody> createState() => _TatananReaderBodyState();
}

class _TatananReaderBodyState extends State<TatananReaderBody> {
  bool _isSplitView = false;
  bool _showQuickTools = false;
  double _splitRatio = 0.5;

  // Wizard
  final GlobalKey _editBtnKey = GlobalKey();
  final GlobalKey _splitBtnKey = GlobalKey();
  bool _wizardShown = false;

  static const double _splitDividerHeight = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeStartWizard());
  }

  void _maybeStartWizard() {
    if (!mounted) return;
    final state = context.read<WizardCubit>().state;
    if (state is WizardActive &&
        state.step == WizardStep.tatananDetail &&
        !_wizardShown) {
      _wizardShown = true;
      _showDetailCoach();
    }
  }

  void _showDetailCoach() {
    if (!mounted) return;
    final wizard = context.read<WizardCubit>();
    TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: 'edit_btn',
          keyTarget: _editBtnKey,
          shape: ShapeLightFocus.Circle,
          enableOverlayTab: false,
          enableTargetTab: true,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (_, __) => _DetailTooltip(
                step: '5/5',
                title: 'Susun Urutan',
                body:
                    'Aktifkan mode edit, lalu tahan dan geser item untuk mengubah urutan ayat dalam tatanan.',
                hint: 'Tap ikon edit untuk masuk ke mode susun',
              ),
            ),
          ],
        ),
        TargetFocus(
          identify: 'split_btn',
          keyTarget: _splitBtnKey,
          shape: ShapeLightFocus.RRect,
          radius: 18,
          enableOverlayTab: false,
          enableTargetTab: true,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (_, __) => _DetailTooltip(
                step: '5/5',
                title: 'Buka Diba\'',
                body:
                    'Tap "Buka Diba\'" untuk membuka split screen — baca tatananmu berdampingan dengan teks Diba\'.',
                hint: 'Tap untuk membuka split screen',
              ),
            ),
          ],
        ),
      ],
      colorShadow: const Color(0xFF111111),
      opacityShadow: 0.88,
      onFinish: () {
        if (!mounted) return;
        wizard.advance(); // tatananDetail → null → _complete()
      },
      onSkip: () {
        wizard.skip();
        return true;
      },
    ).show(context: context);
  }

  void _toggleSplitView(TatananEntity tatanan) {
    setState(() => _isSplitView = !_isSplitView);
    if (_isSplitView) {
      unawaited(
        context
          .read<SplitPanelCubit>()
          .loadPairedChapter(_tatananToChapterEntity(tatanan)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TatananDetailBloc, TatananDetailState>(
      builder: (context, state) {
        return state.when(
          initial: () => const Scaffold(
            backgroundColor: _kBg,
            body: SizedBox.shrink(),
          ),
          loading: () => const Scaffold(
            backgroundColor: _kBg,
            body: Center(
              child: CircularProgressIndicator(color: _kLime),
            ),
          ),
          loaded: (tatanan, verses, isEditMode) => _buildLoaded(
            tatanan: tatanan,
            verses: verses,
            isEditMode: isEditMode,
          ),
          error: (message) => Scaffold(
            backgroundColor: _kBg,
            appBar: AppBar(
              backgroundColor: _kBg,
              elevation: 0,
              leading: const BackButton(color: _kDark),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.wifi_off_outlined,
                      size: 48,
                      color: Color(0xFF79747E),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFF79747E)),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => context
                          .read<TatananDetailBloc>()
                          .add(
                            TatananDetailEvent.load(
                              tatananId: widget.tatananId,
                            ),
                          ),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                      style: FilledButton.styleFrom(
                        backgroundColor: _kDark,
                        foregroundColor: _kLime,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoaded({
    required TatananEntity tatanan,
    required List<TatananVerseEntity> verses,
    required bool isEditMode,
  }) {
    final showSplitButton = _kSplitCategories.contains(tatanan.category);
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Column(
              children: [
                // App bar
                BlocListener<WizardCubit, WizardState>(
                  listener: (ctx, state) {
                    if (state is WizardActive &&
                        state.step == WizardStep.tatananDetail &&
                        !_wizardShown) {
                      _wizardShown = true;
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => _showDetailCoach(),
                      );
                    }
                  },
                  child: _TatananAppBar(
                    topPad: topPad,
                    tatanan: tatanan,
                    isEditMode: isEditMode,
                    isSplitView: _isSplitView,
                    showSplitButton: showSplitButton,
                    verseCount: verses.length,
                    editBtnKey: _editBtnKey,
                    splitBtnKey: _splitBtnKey,
                    onToggleEdit: () => context
                        .read<TatananDetailBloc>()
                        .add(const TatananDetailEvent.toggleEditMode()),
                    onToggleSplit: () => _toggleSplitView(tatanan),
                    onOpenQuickTools: () =>
                        setState(() => _showQuickTools = true),
                  ),
                ),
                // Body
                Expanded(
                  child: _isSplitView
                      ? _buildSplitView(
                          context,
                          tatanan: tatanan,
                          verses: verses,
                          isEditMode: isEditMode,
                        )
                      : _buildNormalView(
                          context,
                          tatanan: tatanan,
                          verses: verses,
                          isEditMode: isEditMode,
                        ),
                ),
              ],
            ),
            // Quick tools overlay
            if (_showQuickTools)
              TatananQuickToolsPanel(
                onClose: () => setState(() => _showQuickTools = false),
              ),
          ],
        ),
      ),
      bottomNavigationBar: !isEditMode && !_isSplitView
          ? const BannerAdWidget()
          : null,
      floatingActionButton: !isEditMode
          ? FloatingActionButton(
              onPressed: () => _openAddVersesSheet(context, tatanan, verses),
              backgroundColor: _kDark,
              child: const Icon(Icons.add, color: _kLime),
            )
          : null,
    );
  }

  Widget _buildNormalView(
    BuildContext context, {
    required TatananEntity tatanan,
    required List<TatananVerseEntity> verses,
    required bool isEditMode,
  }) {
    if (verses.isEmpty) {
      return _EmptyVersesState(
        onAdd: () => _openAddVersesSheet(context, tatanan, verses),
      );
    }

    return BlocBuilder<TatananSettingsCubit, TatananSettingsState>(
      builder: (context, settings) {
        if (isEditMode) {
          return ReorderableListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            itemCount: verses.length,
            onReorder: (oldIndex, newIndex) {
              final adjustedIndex =
                  newIndex > oldIndex ? newIndex - 1 : newIndex;
              final reordered = List<TatananVerseEntity>.from(verses);
              final item = reordered.removeAt(oldIndex);
              reordered.insert(adjustedIndex, item);
              final updates = reordered
                  .asMap()
                  .entries
                  .map(
                    (e) => VersePositionUpdate(
                      verseId: e.value.verseId,
                      position: e.key + 1,
                    ),
                  )
                  .toList();
              context.read<TatananDetailBloc>().add(
                    TatananDetailEvent.reorder(
                      tatananId: tatanan.id,
                      updates: updates,
                    ),
                  );
            },
            itemBuilder: (context, i) {
              final verse = verses[i];
              return TatananVerseItem(
                key: ValueKey(verse.id),
                verse: verse,
                isEditMode: true,
                showArabic: settings.showArabic,
                showTransliteration: settings.showTransliteration,
                arabFontSize: settings.arabFontSize,
                transliterationFontSize: settings.transliterationFontSize,
                onRemove: () => context.read<TatananDetailBloc>().add(
                      TatananDetailEvent.removeVerse(
                        tatananId: tatanan.id,
                        verseId: verse.verseId,
                      ),
                    ),
              );
            },
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          itemCount: verses.length,
          itemBuilder: (context, i) {
            return TatananVerseItem(
              key: ValueKey(verses[i].id),
              verse: verses[i],
              isEditMode: false,
              showArabic: settings.showArabic,
              showTransliteration: settings.showTransliteration,
              arabFontSize: settings.arabFontSize,
              transliterationFontSize: settings.transliterationFontSize,
            );
          },
        );
      },
    );
  }

  Widget _buildSplitView(
    BuildContext context, {
    required TatananEntity tatanan,
    required List<TatananVerseEntity> verses,
    required bool isEditMode,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalHeight = constraints.maxHeight - _splitDividerHeight;
        final topHeight = totalHeight * _splitRatio;
        final bottomHeight = totalHeight * (1 - _splitRatio);

        return Column(
          children: [
            // Top pane: tatanan verses
            SizedBox(
              height: topHeight,
              child: verses.isEmpty
                  ? _EmptyVersesState(
                      onAdd: () =>
                          _openAddVersesSheet(context, tatanan, verses),
                    )
                  : BlocBuilder<TatananSettingsCubit, TatananSettingsState>(
                      builder: (context, settings) => ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        itemCount: verses.length,
                        itemBuilder: (context, i) => TatananVerseItem(
                          key: ValueKey(verses[i].id),
                          verse: verses[i],
                          isEditMode: false,
                          showArabic: settings.showArabic,
                          showTransliteration: settings.showTransliteration,
                          arabFontSize: settings.arabFontSize,
                          transliterationFontSize:
                              settings.transliterationFontSize,
                        ),
                      ),
                    ),
            ),
            // Divider
            _SplitDivider(
              onDrag: (delta) {
                setState(() {
                  _splitRatio = (_splitRatio +
                          delta / (constraints.maxHeight - _splitDividerHeight))
                      .clamp(0.2, 0.8);
                });
              },
            ),
            // Bottom pane: full paired chapter
            SizedBox(
              height: bottomHeight,
              child: BlocBuilder<TatananSettingsCubit, TatananSettingsState>(
                builder: (context, settings) =>
                    BlocBuilder<SplitPanelCubit, SplitPanelState>(
                  builder: (context, splitState) {
                    if (splitState is SplitPanelLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: _kLime),
                      );
                    }
                    if (splitState is SplitPanelError) {
                      return Center(
                        child: Text(
                          splitState.message,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: _kMuted,
                          ),
                        ),
                      );
                    }
                    if (splitState is SplitPanelLoaded) {
                      return ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        itemCount: splitState.verses.length,
                        itemBuilder: (context, i) {
                          final v = splitState.verses[i];
                          return VerseCard(
                            verse: v,
                            isBookmarked: false,
                            isPlaying: false,
                            showTranslation: false,
                            showArabic: settings.showArabic,
                            showTransliteration: settings.showTransliteration,
                            arabFontSize: settings.arabFontSize,
                            transliterationFontSize:
                                settings.transliterationFontSize,
                            translationFontSize: 13,
                            onBookmarkToggle: () {},
                            onPlayTap: () {},
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openAddVersesSheet(
    BuildContext context,
    TatananEntity tatanan,
    List<TatananVerseEntity> verses,
  ) {
    final addedIds = verses.map((v) => v.verseId).toSet();
    unawaited(showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => AddVersesSheet(
        chapterId: tatanan.chapterId,
        addedVerseIds: addedIds,
        onConfirm: (verseIds) {
          context.read<TatananDetailBloc>().add(
                TatananDetailEvent.addVerses(
                  tatananId: tatanan.id,
                  verseIds: verseIds,
                ),
              );
        },
      ),
    ));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// App bar
// ─────────────────────────────────────────────────────────────────────────────

class _TatananAppBar extends StatelessWidget {
  const _TatananAppBar({
    required this.topPad,
    required this.tatanan,
    required this.isEditMode,
    required this.isSplitView,
    required this.showSplitButton,
    required this.verseCount,
    required this.onToggleEdit,
    required this.onToggleSplit,
    required this.onOpenQuickTools,
    this.editBtnKey,
    this.splitBtnKey,
  });

  final double topPad;
  final TatananEntity tatanan;
  final bool isEditMode;
  final bool isSplitView;
  final bool showSplitButton;
  final int verseCount;
  final VoidCallback onToggleEdit;
  final VoidCallback onToggleSplit;
  final VoidCallback onOpenQuickTools;
  final GlobalKey? editBtnKey;
  final GlobalKey? splitBtnKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, topPad + 4, 8, 4),
      child: Row(
        children: [
          const BackButton(color: _kDark),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tatanan.name,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: _kDark,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${tatanan.chapterTitle} · $verseCount ayat',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: _kMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (showSplitButton)
            _IconBtn(
              key: splitBtnKey,
              icon: isSplitView
                  ? Icons.fullscreen_rounded
                  : Icons.vertical_split_rounded,
              isActive: isSplitView,
              onTap: onToggleSplit,
              label: isSplitView ? 'Tutup Diba' : 'Buka Diba',
            ),
          _IconBtn(
            key: editBtnKey,
            icon: isEditMode ? Icons.check_rounded : Icons.edit_outlined,
            isActive: isEditMode,
            onTap: onToggleEdit,
          ),
          _IconBtn(
            icon: Icons.tune_rounded,
            isActive: false,
            onTap: onOpenQuickTools,
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({
    required this.icon,
    required this.isActive,
    required this.onTap,
    this.label,
    super.key,
  });

  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: label != null
            ? const EdgeInsets.symmetric(horizontal: 10)
            : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: isActive ? _kDark : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _kBorder, width: 1.5),
        ),
        child: label == null
            ? SizedBox(
                width: 36,
                child: Icon(icon, size: 18, color: isActive ? _kLime : _kDark),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 18, color: isActive ? _kLime : _kDark),
                  const SizedBox(width: 6),
                  Text(
                    label!,
                    style: TextStyle(
                      fontSize: 11,
                      color: isActive ? _kLime : _kDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Split divider
// ─────────────────────────────────────────────────────────────────────────────

class _SplitDivider extends StatelessWidget {
  const _SplitDivider({required this.onDrag});

  final ValueChanged<double> onDrag;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: (d) => onDrag(d.delta.dy),
      child: Container(
        height: 10,
        color: const Color(0xFFE2E8DF),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 32,
                child: Divider(
                  color: Color(0xFFAAAAAA),
                  thickness: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Wizard tooltip
// ─────────────────────────────────────────────────────────────────────────────

class _DetailTooltip extends StatelessWidget {
  const _DetailTooltip({
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
                  color: _kLime,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  step,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: _kDark,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: _kDark,
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
              color: _kMuted,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyVersesState extends StatelessWidget {
  const _EmptyVersesState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F0E6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.format_list_numbered_rounded,
                size: 32,
                color: Color(0xFF777777),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tatanan masih kosong',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _kDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap tombol + untuk menambahkan ayat.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 13, color: _kMuted),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: onAdd,
              child: Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: _kDark,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, size: 16, color: _kLime),
                    const SizedBox(width: 7),
                    Text(
                      'Tambah Ayat',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
