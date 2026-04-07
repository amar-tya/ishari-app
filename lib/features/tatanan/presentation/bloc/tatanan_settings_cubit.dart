import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TatananSettingsState {
  const TatananSettingsState({
    this.showArabic = true,
    this.showTransliteration = true,
    this.arabFontSize = 20.0,
    this.transliterationFontSize = 12.0,
  });

  final bool showArabic;
  final bool showTransliteration;
  final double arabFontSize;
  final double transliterationFontSize;

  TatananSettingsState copyWith({
    bool? showArabic,
    bool? showTransliteration,
    double? arabFontSize,
    double? transliterationFontSize,
  }) =>
      TatananSettingsState(
        showArabic: showArabic ?? this.showArabic,
        showTransliteration: showTransliteration ?? this.showTransliteration,
        arabFontSize: arabFontSize ?? this.arabFontSize,
        transliterationFontSize:
            transliterationFontSize ?? this.transliterationFontSize,
      );
}

class TatananSettingsCubit extends Cubit<TatananSettingsState> {
  TatananSettingsCubit() : super(const TatananSettingsState()) {
    unawaited(_load());
  }

  static const _kArab = 'tatanan_arab_font_size';
  static const _kTranslit = 'tatanan_transliteration_font_size';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    emit(state.copyWith(
      arabFontSize: prefs.getDouble(_kArab) ?? 20.0,
      transliterationFontSize: prefs.getDouble(_kTranslit) ?? 12.0,
    ));
  }

  void toggleArabic() => emit(state.copyWith(showArabic: !state.showArabic));

  void toggleTransliteration() =>
      emit(state.copyWith(showTransliteration: !state.showTransliteration));

  Future<void> setArabFontSize(double size) async {
    emit(state.copyWith(arabFontSize: size));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kArab, size);
  }

  Future<void> setTransliterationFontSize(double size) async {
    emit(state.copyWith(transliterationFontSize: size));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kTranslit, size);
  }

  void resetFontSizes() {
    emit(state.copyWith(arabFontSize: 20, transliterationFontSize: 12));
    unawaited(SharedPreferences.getInstance().then((prefs) async {
      await prefs.setDouble(_kArab, 20);
      await prefs.setDouble(_kTranslit, 12);
    }));
  }
}
