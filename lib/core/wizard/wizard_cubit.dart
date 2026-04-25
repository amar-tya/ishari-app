import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ishari/core/wizard/wizard_state.dart';

class WizardCubit extends Cubit<WizardState> {
  WizardCubit(this._storage) : super(const WizardInactive());

  final FlutterSecureStorage _storage;
  static const _kKey = 'wizard_completed';
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    final done = await _storage.read(key: _kKey);
    if (done != 'true') {
      emit(const WizardActive(WizardStep.muhudSplit));
    }
  }

  void advance() {
    final s = state;
    if (s is! WizardActive) return;
    final next = _next(s.step);
    if (next == null) {
      _complete();
    } else {
      emit(WizardActive(next));
    }
  }

  void advanceToTatananDetail() {
    final s = state;
    if (s is WizardActive && s.step == WizardStep.tatananCreate) {
      emit(const WizardActive(WizardStep.tatananDetail));
    }
  }

  void skipForGuest() => _complete();

  void skip() => _complete();

  WizardStep? _next(WizardStep step) => switch (step) {
    WizardStep.muhudSplit => WizardStep.muhudAudio,
    WizardStep.muhudAudio => WizardStep.tabBeranda,
    WizardStep.tabBeranda => WizardStep.tabCari,
    WizardStep.tabCari => WizardStep.tabKitab,
    WizardStep.tabKitab => WizardStep.tabBookmark,
    WizardStep.tabBookmark => WizardStep.tabTatanan,
    WizardStep.tabTatanan => WizardStep.tatananCreate,
    WizardStep.tatananCreate => WizardStep.tatananDetail,
    WizardStep.tatananDetail => null,
  };

  void _complete() {
    unawaited(_storage.write(key: _kKey, value: 'true'));
    emit(const WizardDone());
  }
}
