import 'package:flutter/material.dart';
import 'package:ishari/shared/widgets/reader/reader_colors.dart';

/// Labelled font size slider. The named constructors hold the ranges both
/// readers use.
class ReaderFontSizeSlider extends StatelessWidget {
  const ReaderFontSizeSlider.arabic({
    required this.value,
    required this.onChanged,
    super.key,
  }) : label = 'Ukuran Font Arab',
       min = 16,
       max = 36,
       divisions = 20;

  const ReaderFontSizeSlider.transliteration({
    required this.value,
    required this.onChanged,
    super.key,
  }) : label = 'Ukuran Font Transliterasi',
       min = 8,
       max = 18,
       divisions = 10;

  const ReaderFontSizeSlider.translation({
    required this.value,
    required this.onChanged,
    super.key,
  }) : label = 'Ukuran Font Terjemahan',
       min = 10,
       max = 22,
       divisions = 12;

  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: kReaderDark,
                ),
              ),
              Text(
                value.round().toString(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: kReaderDark,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: kReaderDark,
              thumbColor: kReaderLime,
              inactiveTrackColor: const Color(0xFFE8F0E6),
              overlayColor: kReaderLime.withValues(alpha: 0.20),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
              trackHeight: 4,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
