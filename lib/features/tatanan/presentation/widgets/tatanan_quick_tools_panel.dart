import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/features/tatanan/presentation/bloc/tatanan_settings_cubit.dart';

class TatananQuickToolsPanel extends StatelessWidget {
  const TatananQuickToolsPanel({required this.onClose, super.key});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Scrim
        GestureDetector(
          onTap: onClose,
          child: const ColoredBox(
            color: Color(0x80000000),
            child: SizedBox.expand(),
          ),
        ),
        // Panel
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
                    Expanded(child: _PanelContent(onClose: onClose)),
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

class _PanelContent extends StatelessWidget {
  const _PanelContent({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TatananSettingsCubit, TatananSettingsState>(
      builder: (context, s) {
        final cubit = context.read<TatananSettingsCubit>();
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
              value: s.showArabic,
              onChanged: (_) => cubit.toggleArabic(),
            ),
            _ToggleRow(
              label: 'Transliterasi',
              subtitle: 'Tampilkan latin',
              value: s.showTransliteration,
              onChanged: (_) => cubit.toggleTransliteration(),
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
            const Divider(height: 1, color: Color(0xFFE2E8DF)),
            _FontSizeSlider(
              label: 'Ukuran Font Arab',
              value: s.arabFontSize,
              min: 16,
              max: 36,
              divisions: 20,
              onChanged: (v) => unawaited(cubit.setArabFontSize(v)),
            ),
            const Divider(height: 1, color: Color(0xFFE2E8DF)),
            _FontSizeSlider(
              label: 'Ukuran Font Transliterasi',
              value: s.transliterationFontSize,
              min: 8,
              max: 18,
              divisions: 10,
              onChanged: (v) => unawaited(cubit.setTransliterationFontSize(v)),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: cubit.resetFontSizes,
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
      },
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
              overlayColor:
                  const Color(0xFFCAFF00).withValues(alpha: 0.20),
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
  });

  final String label;
  final String? subtitle;
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
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF111111),
                  ),
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
