import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/features/tatanan/presentation/bloc/tatanan_settings_cubit.dart';
import 'package:ishari/shared/widgets/reader/reader_display_settings.dart';
import 'package:ishari/shared/widgets/reader/reader_font_size_slider.dart';
import 'package:ishari/shared/widgets/reader/reader_quick_tools_frame.dart';

class TatananQuickToolsPanel extends StatelessWidget {
  const TatananQuickToolsPanel({required this.onClose, super.key});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return ReaderQuickToolsFrame(
      onClose: onClose,
      child: BlocBuilder<TatananSettingsCubit, TatananSettingsState>(
        builder: (context, s) {
          final cubit = context.read<TatananSettingsCubit>();
          return ReaderDisplaySettings(
            showArabic: s.showArabic,
            showTransliteration: s.showTransliteration,
            onToggleArabic: cubit.toggleArabic,
            onToggleTransliteration: cubit.toggleTransliteration,
            sliders: [
              ReaderFontSizeSlider.arabic(
                value: s.arabFontSize,
                onChanged: (v) => unawaited(cubit.setArabFontSize(v)),
              ),
              ReaderFontSizeSlider.transliteration(
                value: s.transliterationFontSize,
                onChanged: (v) =>
                    unawaited(cubit.setTransliterationFontSize(v)),
              ),
            ],
            onResetFontSizes: cubit.resetFontSizes,
          );
        },
      ),
    );
  }
}
