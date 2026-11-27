import 'package:flutter/material.dart';
import 'package:ishari/shared/widgets/reader/reader_colors.dart';
import 'package:ishari/shared/widgets/reader/reader_font_size_slider.dart';
import 'package:ishari/shared/widgets/reader/reader_toggle_row.dart';

/// Content toggles, font size sliders and reset button of a reader.
///
/// The readers keep their settings in different places, so values and
/// callbacks come from the caller.
class ReaderDisplaySettings extends StatelessWidget {
  const ReaderDisplaySettings({
    required this.showArabic,
    required this.showTransliteration,
    required this.onToggleArabic,
    required this.onToggleTransliteration,
    required this.sliders,
    required this.onResetFontSizes,
    this.extraToggles = const [],
    this.fontSectionLeading,
    super.key,
  });

  final bool showArabic;
  final bool showTransliteration;
  final VoidCallback onToggleArabic;
  final VoidCallback onToggleTransliteration;

  /// Toggles listed after the Arabic and transliteration ones.
  final List<Widget> extraToggles;

  /// Shown between the font section title and the first slider.
  final Widget? fontSectionLeading;

  /// Each slider gets a divider above it.
  final List<ReaderFontSizeSlider> sliders;
  final VoidCallback onResetFontSizes;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      children: [
        const SizedBox(height: 16),
        const _SectionTitle('Konten'),
        ReaderToggleRow(
          label: 'Arab',
          subtitle: 'Tampilkan teks Arab',
          value: showArabic,
          onChanged: (_) => onToggleArabic(),
        ),
        ReaderToggleRow(
          label: 'Transliterasi',
          subtitle: 'Tampilkan latin',
          value: showTransliteration,
          onChanged: (_) => onToggleTransliteration(),
        ),
        ...extraToggles,
        const SizedBox(height: 16),
        const _SectionTitle('Pengaturan Font'),
        const SizedBox(height: 4),
        ?fontSectionLeading,
        for (final slider in sliders) ...[
          const Divider(height: 1, color: kReaderBorder),
          slider,
        ],
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: onResetFontSizes,
          icon: const Icon(Icons.refresh_rounded, size: 16),
          label: const Text('Reset ke Default'),
          style: OutlinedButton.styleFrom(
            foregroundColor: kReaderMuted,
            side: const BorderSide(color: kReaderBorder),
            textStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: kReaderDark,
        letterSpacing: -0.2,
      ),
    );
  }
}
