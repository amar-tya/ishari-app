import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/features/muhud/presentation/widgets/paired_chapter_view.dart';
import 'package:ishari/features/tatanan/presentation/bloc/tatanan_settings_cubit.dart';
import 'package:ishari/shared/widgets/reader/reader_colors.dart';

const _kDividerHeight = 10.0;

/// The tatanan on top and the paired chapter below, with a draggable divider.
class TatananSplitView extends StatelessWidget {
  const TatananSplitView({
    required this.splitRatio,
    required this.onDividerDrag,
    required this.top,
    super.key,
  });

  final double splitRatio;

  /// Called with the drag distance as a fraction of the two panes' height.
  final ValueChanged<double> onDividerDrag;
  final Widget top;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalHeight = constraints.maxHeight - _kDividerHeight;
        final topHeight = totalHeight * splitRatio;
        final bottomHeight = totalHeight * (1 - splitRatio);

        return Column(
          children: [
            SizedBox(height: topHeight, child: top),
            _SplitDivider(
              onDrag: (delta) => onDividerDrag(delta / totalHeight),
            ),
            SizedBox(height: bottomHeight, child: const _PairedPane()),
          ],
        );
      },
    );
  }
}

/// The full paired chapter, without translations.
class _PairedPane extends StatelessWidget {
  const _PairedPane();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TatananSettingsCubit, TatananSettingsState>(
      builder: (context, settings) => PairedChapterView(
        loadedBuilder: (state) => PairedVerseList(
          verses: state.verses,
          showTranslation: false,
          showArabic: settings.showArabic,
          showTransliteration: settings.showTransliteration,
          arabFontSize: settings.arabFontSize,
          transliterationFontSize: settings.transliterationFontSize,
          translationFontSize: 13,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        ),
        errorBuilder: (message) => Center(
          child: Text(
            message,
            style: GoogleFonts.poppins(fontSize: 12, color: kReaderMuted),
          ),
        ),
      ),
    );
  }
}

class _SplitDivider extends StatelessWidget {
  const _SplitDivider({required this.onDrag});

  final ValueChanged<double> onDrag;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: (d) => onDrag(d.delta.dy),
      child: Container(
        height: _kDividerHeight,
        color: kReaderBorder,
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 32,
                child: Divider(color: Color(0xFFAAAAAA), thickness: 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
