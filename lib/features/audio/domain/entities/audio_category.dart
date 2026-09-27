enum AudioCategory { hadi, muhud, rodadCabang }

extension AudioCategoryExt on AudioCategory {
  String get label {
    return switch (this) {
      AudioCategory.hadi => 'Hadi',
      AudioCategory.muhud => 'Muhud',
      AudioCategory.rodadCabang => 'Rodad Cabang',
    };
  }
}
