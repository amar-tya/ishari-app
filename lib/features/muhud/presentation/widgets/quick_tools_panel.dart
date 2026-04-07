import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_bloc.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_event.dart';

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
    return Stack(
      children: [
        // Dark scrim — tapping closes the panel
        GestureDetector(
          onTap: onClose,
          child: const ColoredBox(
            color: Color(0x80000000),
            child: SizedBox.expand(),
          ),
        ),
        // Panel — absorbs taps so they don't reach the scrim
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width * 0.82,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
              ),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
                      child: Row(
                        children: [
                          // Close button
                          GestureDetector(
                            onTap: onClose,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF0F5EE),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close_rounded,
                                size: 14,
                                color: Color(0xFF777777),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Quick Tools',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF111111),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Color(0xFFE2E8DF)),
                    Expanded(
                      child: _BaitTabContent(
                        showArabic: showArabic,
                        showTransliteration: showTransliteration,
                        showTranslation: showTranslation,
                        arabFontSize: arabFontSize,
                        transliterationFontSize: transliterationFontSize,
                        translationFontSize: translationFontSize,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BaitTabContent extends StatelessWidget {
  const _BaitTabContent({
    required this.showArabic,
    required this.showTransliteration,
    required this.showTranslation,
    required this.arabFontSize,
    required this.transliterationFontSize,
    required this.translationFontSize,
  });

  final bool showArabic;
  final bool showTransliteration;
  final bool showTranslation;
  final double arabFontSize;
  final double transliterationFontSize;
  final double translationFontSize;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MuhudBloc>();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      children: [
        const SizedBox(height: 16),
        const Text(
          'Konten',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111111),
            letterSpacing: -0.2,
          ),
        ),
        _ToggleRow(
          label: 'Arab',
          subtitle: 'Tampilkan teks Arab',
          value: showArabic,
          onChanged: (_) => bloc.add(const MuhudEvent.toggleArabic()),
        ),
        _ToggleRow(
          label: 'Transliterasi',
          subtitle: 'Tampilkan latin',
          value: showTransliteration,
          onChanged: (_) => bloc.add(const MuhudEvent.toggleTransliteration()),
        ),
        _ToggleRow(
          label: 'Terjemahan',
          badge: 'ID',
          value: showTranslation,
          onChanged: (_) => bloc.add(const MuhudEvent.toggleTranslation()),
        ),
        const SizedBox(height: 16),
        const Text(
          'Pengaturan Font',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111111),
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 4),
        // Font Arab row
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Font Arab',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111111),
                ),
              ),
              Row(
                children: [
                  Text(
                    'Scheherazade New',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF777777),
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
        ),
        const Divider(height: 1, color: Color(0xFFE2E8DF)),
        // Arab font size slider
        _FontSizeSlider(
          label: 'Ukuran Font Arab',
          value: arabFontSize,
          min: 16,
          max: 36,
          divisions: 20,
          onChanged: (v) => bloc.add(MuhudEvent.setArabFontSize(v)),
        ),
        const Divider(height: 1, color: Color(0xFFE2E8DF)),
        // Transliteration font size slider
        _FontSizeSlider(
          label: 'Ukuran Font Transliterasi',
          value: transliterationFontSize,
          min: 8,
          max: 18,
          divisions: 10,
          onChanged: (v) => bloc.add(MuhudEvent.setTransliterationFontSize(v)),
        ),
        const Divider(height: 1, color: Color(0xFFE2E8DF)),
        // Translation font size slider
        _FontSizeSlider(
          label: 'Ukuran Font Terjemahan',
          value: translationFontSize,
          min: 10,
          max: 22,
          divisions: 12,
          onChanged: (v) => bloc.add(MuhudEvent.setTranslationFontSize(v)),
        ),
        const SizedBox(height: 16),
        // Reset button
        OutlinedButton.icon(
          onPressed: () => bloc.add(const MuhudEvent.resetFontSizes()),
          icon: const Icon(Icons.refresh_rounded, size: 16),
          label: const Text('Reset ke Default'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF777777),
            side: const BorderSide(color: Color(0xFFE2E8DF)),
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

class _FontSizeSlider extends StatelessWidget {
  const _FontSizeSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

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
                  color: Color(0xFF111111),
                ),
              ),
              Text(
                value.round().toString(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111111),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF111111),
              thumbColor: const Color(0xFFCAFF00),
              inactiveTrackColor: const Color(0xFFE8F0E6),
              overlayColor: const Color(0xFFCAFF00).withValues(alpha: 0.20),
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

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.badge,
  });

  final String label;
  final String? subtitle;
  final String? badge;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8DF))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF111111),
                      ),
                    ),
                    if (badge != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCAFF00),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          badge!,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF111111),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 1),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF777777),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFF111111),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFD0D8CE),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
