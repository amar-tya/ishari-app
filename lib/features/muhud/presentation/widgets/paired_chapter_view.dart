import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/features/muhud/domain/entities/verse_with_details_entity.dart';
import 'package:ishari/features/muhud/presentation/bloc/split_panel_cubit.dart';
import 'package:ishari/features/muhud/presentation/widgets/verse_card.dart';
import 'package:ishari/shared/widgets/reader/reader_colors.dart';

/// Follows [SplitPanelCubit] for the paired pane of a split reader. Each reader
/// styles the pane its own way.
class PairedChapterView extends StatelessWidget {
  const PairedChapterView({
    required this.loadedBuilder,
    required this.errorBuilder,
    this.spinnerStrokeWidth,
    super.key,
  });

  final Widget Function(SplitPanelLoaded state) loadedBuilder;
  final Widget Function(String message) errorBuilder;

  /// Null keeps the [CircularProgressIndicator] default.
  final double? spinnerStrokeWidth;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SplitPanelCubit, SplitPanelState>(
      builder: (_, state) => switch (state) {
        SplitPanelInitial() => const SizedBox.shrink(),
        SplitPanelLoading() => Center(
          child: CircularProgressIndicator(
            color: kReaderLime,
            strokeWidth: spinnerStrokeWidth,
          ),
        ),
        SplitPanelLoaded() => loadedBuilder(state),
        SplitPanelError(:final message) => errorBuilder(message),
      },
    );
  }
}

/// Read-only verses of the paired chapter: the bookmark and play buttons on
/// each card do nothing.
class PairedVerseList extends StatelessWidget {
  const PairedVerseList({
    required this.verses,
    required this.showTranslation,
    required this.showArabic,
    required this.showTransliteration,
    required this.arabFontSize,
    required this.transliterationFontSize,
    required this.translationFontSize,
    this.padding,
    this.physics,
    super.key,
  });

  final List<VerseWithDetailsEntity> verses;
  final bool showTranslation;
  final bool showArabic;
  final bool showTransliteration;
  final double arabFontSize;
  final double transliterationFontSize;
  final double translationFontSize;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      physics: physics,
      itemCount: verses.length,
      itemBuilder: (_, i) => VerseCard(
        verse: verses[i],
        isBookmarked: false,
        isPlaying: false,
        showTranslation: showTranslation,
        showArabic: showArabic,
        showTransliteration: showTransliteration,
        arabFontSize: arabFontSize,
        transliterationFontSize: transliterationFontSize,
        translationFontSize: translationFontSize,
        onBookmarkToggle: () {},
        onPlayTap: () {},
      ),
    );
  }
}
