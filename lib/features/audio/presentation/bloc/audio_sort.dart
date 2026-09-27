enum AudioSort { terbaru, az, terlama }

extension AudioSortExt on AudioSort {
  String get label {
    return switch (this) {
      AudioSort.terbaru => 'Terbaru',
      AudioSort.az => 'A-Z',
      AudioSort.terlama => 'Terlama',
    };
  }
}
