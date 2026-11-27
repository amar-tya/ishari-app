import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_bloc.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_event.dart';
import 'package:ishari/shared/widgets/reader/reader_colors.dart';
import 'package:ishari/shared/widgets/reader/reader_display_settings.dart';
import 'package:ishari/shared/widgets/reader/reader_font_size_slider.dart';
import 'package:ishari/shared/widgets/reader/reader_quick_tools_frame.dart';
import 'package:ishari/shared/widgets/reader/reader_toggle_row.dart';

/// Side panel (slides from right) for display settings.
/// Shown as an overlay within [ChapterReaderBody].
class QuickToolsPanel extends StatelessWidget {
  const QuickToolsPanel({
    required this.onClose,
    required this.showArabic,
    required this.showTransliteration,
    required this.showTranslation,
    required this.arabFontSize,
    required this.transliterationFontSize,
    required this.translationFontSize,
    super.key,
  });

  final VoidCallback onClose;
  final bool showArabic;
  final bool showTransliteration;
  final bool showTranslation;
  final double arabFontSize;
  final double transliterationFontSize;
  final double translationFontSize;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MuhudBloc>();

    return ReaderQuickToolsFrame(
      onClose: onClose,
      child: ReaderDisplaySettings(
        showArabic: showArabic,
        showTransliteration: showTransliteration,
        onToggleArabic: () => bloc.add(const MuhudEvent.toggleArabic()),
        onToggleTransliteration: () =>
            bloc.add(const MuhudEvent.toggleTransliteration()),
        extraToggles: [
          ReaderToggleRow(
            label: 'Terjemahan',
            badge: 'ID',
            value: showTranslation,
            onChanged: (_) => bloc.add(const MuhudEvent.toggleTranslation()),
          ),
        ],
        fontSectionLeading: const _ArabFontRow(),
        sliders: [
          ReaderFontSizeSlider.arabic(
            value: arabFontSize,
            onChanged: (v) => bloc.add(MuhudEvent.setArabFontSize(v)),
          ),
          ReaderFontSizeSlider.transliteration(
            value: transliterationFontSize,
            onChanged: (v) =>
                bloc.add(MuhudEvent.setTransliterationFontSize(v)),
          ),
          ReaderFontSizeSlider.translation(
            value: translationFontSize,
            onChanged: (v) => bloc.add(MuhudEvent.setTranslationFontSize(v)),
          ),
        ],
        onResetFontSizes: () => bloc.add(const MuhudEvent.resetFontSizes()),
      ),
    );
  }
}

/// Names the Arabic typeface. The chevron does nothing yet.
class _ArabFontRow extends StatelessWidget {
  const _ArabFontRow();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Font Arab',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: kReaderDark,
            ),
          ),
          Row(
            children: [
              Text(
                'Scheherazade New',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: kReaderMuted,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: Color(0xFFAAAAAA),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
