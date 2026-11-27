import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/core/wizard/wizard_cubit.dart';
import 'package:ishari/core/wizard/wizard_state.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/muhud/presentation/bloc/split_panel_cubit.dart';
import 'package:ishari/features/tatanan/domain/entities/tatanan_entity.dart';
import 'package:ishari/features/tatanan/domain/entities/tatanan_verse_entity.dart';
import 'package:ishari/features/tatanan/presentation/bloc/tatanan_detail/tatanan_detail_bloc.dart';
import 'package:ishari/features/tatanan/presentation/bloc/tatanan_settings_cubit.dart';
import 'package:ishari/features/tatanan/presentation/widgets/add_verses_sheet.dart';
import 'package:ishari/features/tatanan/presentation/widgets/tatanan_app_bar.dart';
import 'package:ishari/features/tatanan/presentation/widgets/tatanan_empty_verses.dart';
import 'package:ishari/features/tatanan/presentation/widgets/tatanan_error_view.dart';
import 'package:ishari/features/tatanan/presentation/widgets/tatanan_quick_tools_panel.dart';
import 'package:ishari/features/tatanan/presentation/widgets/tatanan_split_view.dart';
import 'package:ishari/features/tatanan/presentation/widgets/tatanan_verse_list.dart';
import 'package:ishari/shared/widgets/banner_ad_widget.dart';
import 'package:ishari/shared/widgets/reader/reader_coach_mark.dart';
import 'package:ishari/shared/widgets/reader/reader_colors.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

ChapterEntity _tatananToChapterEntity(TatananEntity t) => ChapterEntity(
  id: t.chapterId.toString(),
  title: t.chapterTitle,
  category: t.category,
  description: '',
  number: t.chapterNumber,
);

class TatananReaderBody extends StatefulWidget {
  const TatananReaderBody({
    required this.tatananId,
    super.key,
  });

  final String tatananId;

  @override
  State<TatananReaderBody> createState() => _TatananReaderBodyState();
}

class _TatananReaderBodyState extends State<TatananReaderBody>
    with WizardCoachTrigger<TatananReaderBody> {
  bool _isSplitView = false;
  bool _showQuickTools = false;
  double _splitRatio = 0.5;

  // Wizard
  final GlobalKey _editBtnKey = GlobalKey();
  final GlobalKey _splitBtnKey = GlobalKey();

  @override
  WizardStep get coachStep => WizardStep.tatananDetail;

  @override
  void showCoach() {
    if (!mounted) return;
    final wizard = context.read<WizardCubit>();
    showReaderCoachMark(
      context,
      wizard: wizard,
      targets: [
        readerCoachTarget(
          identify: 'edit_btn',
          keyTarget: _editBtnKey,
          shape: ShapeLightFocus.Circle,
          step: '4/4',
          title: 'Susun Urutan',
          body:
              'Aktifkan mode edit, lalu tahan dan geser item untuk mengubah '
              'urutan ayat dalam tatanan.',
          hint: 'Tap ikon edit untuk masuk ke mode susun',
        ),
        readerCoachTarget(
          identify: 'split_btn',
          keyTarget: _splitBtnKey,
          shape: ShapeLightFocus.RRect,
          radius: 18,
          step: '4/4',
          title: "Buka Diba'",
          body:
              'Tap "Buka Diba\'" untuk membuka split screen — baca tatananmu '
              "berdampingan dengan teks Diba'.",
          hint: 'Tap untuk membuka split screen',
        ),
      ],
      onFinish: () {
        if (!mounted) return;
        wizard.advance(); // tatananDetail → null → _complete()
      },
    );
  }

  void _toggleSplitView(TatananEntity tatanan) {
    setState(() => _isSplitView = !_isSplitView);
    if (_isSplitView) {
      unawaited(
        context.read<SplitPanelCubit>().loadPairedChapter(
          _tatananToChapterEntity(tatanan),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TatananDetailBloc, TatananDetailState>(
      builder: (context, state) {
        return state.when(
          initial: () => const Scaffold(
            backgroundColor: kReaderBackground,
            body: SizedBox.shrink(),
          ),
          loading: () => const Scaffold(
            backgroundColor: kReaderBackground,
            body: Center(
              child: CircularProgressIndicator(color: kReaderLime),
            ),
          ),
          loaded: (tatanan, verses, isEditMode) => _buildLoaded(
            tatanan: tatanan,
            verses: verses,
            isEditMode: isEditMode,
          ),
          error: (message) => TatananErrorView(
            message: message,
            onRetry: () => context.read<TatananDetailBloc>().add(
              TatananDetailEvent.load(tatananId: widget.tatananId),
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
    final showSplitButton = kSplitViewCategories.contains(tatanan.category);
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: kReaderBackground,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Column(
              children: [
                // App bar
                BlocListener<WizardCubit, WizardState>(
                  listener: onWizardState,
                  child: TatananAppBar(
                    topPad: topPad,
                    tatanan: tatanan,
                    isEditMode: isEditMode,
                    isSplitView: _isSplitView,
                    showSplitButton: showSplitButton,
                    verseCount: verses.length,
                    editBtnKey: _editBtnKey,
                    splitBtnKey: _splitBtnKey,
                    onToggleEdit: () => context.read<TatananDetailBloc>().add(
                      const TatananDetailEvent.toggleEditMode(),
                    ),
                    onToggleSplit: () => _toggleSplitView(tatanan),
                    onOpenQuickTools: () =>
                        setState(() => _showQuickTools = true),
                  ),
                ),
                // Body
                Expanded(
                  child: _isSplitView
                      ? TatananSplitView(
                          splitRatio: _splitRatio,
                          onDividerDrag: (fraction) => setState(() {
                            _splitRatio = (_splitRatio + fraction).clamp(
                              0.2,
                              0.8,
                            );
                          }),
                          top: _buildSplitTop(tatanan, verses),
                        )
                      : _buildNormalView(tatanan, verses, isEditMode),
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
              onPressed: () => _openAddVersesSheet(tatanan, verses),
              backgroundColor: kReaderDark,
              child: const Icon(Icons.add, color: kReaderLime),
            )
          : null,
    );
  }

  Widget _buildNormalView(
    TatananEntity tatanan,
    List<TatananVerseEntity> verses,
    bool isEditMode,
  ) {
    if (verses.isEmpty) return _emptyVerses(tatanan, verses);

    return BlocBuilder<TatananSettingsCubit, TatananSettingsState>(
      builder: (context, settings) {
        if (!isEditMode) {
          return TatananVerseList(
            verses: verses,
            settings: settings,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          );
        }
        return TatananReorderableVerseList(
          verses: verses,
          settings: settings,
          onReorder: (updates) => context.read<TatananDetailBloc>().add(
            TatananDetailEvent.reorder(
              tatananId: tatanan.id,
              updates: updates,
            ),
          ),
          onRemove: (verse) => context.read<TatananDetailBloc>().add(
            TatananDetailEvent.removeVerse(
              tatananId: tatanan.id,
              verseId: verse.verseId,
            ),
          ),
        );
      },
    );
  }

  /// The tatanan pane of the split view is read-only, even in edit mode.
  Widget _buildSplitTop(
    TatananEntity tatanan,
    List<TatananVerseEntity> verses,
  ) {
    if (verses.isEmpty) return _emptyVerses(tatanan, verses);

    return BlocBuilder<TatananSettingsCubit, TatananSettingsState>(
      builder: (context, settings) => TatananVerseList(
        verses: verses,
        settings: settings,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      ),
    );
  }

  Widget _emptyVerses(
    TatananEntity tatanan,
    List<TatananVerseEntity> verses,
  ) {
    return TatananEmptyVerses(
      onAdd: () => _openAddVersesSheet(tatanan, verses),
    );
  }

  void _openAddVersesSheet(
    TatananEntity tatanan,
    List<TatananVerseEntity> verses,
  ) {
    final addedIds = verses.map((v) => v.verseId).toSet();
    unawaited(
      showModalBottomSheet<void>(
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
      ),
    );
  }
}
