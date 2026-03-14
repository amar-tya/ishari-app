enum VerseMediaType {
  joz,
  yahum,
  terem,
  inat,
  rojazz,
}

extension VerseMediaTypeExt on VerseMediaType {
  String get label {
    return switch (this) {
      VerseMediaType.joz => 'Joz',
      VerseMediaType.yahum => 'Yahum',
      VerseMediaType.terem => 'Terem',
      VerseMediaType.inat => 'Inat',
      VerseMediaType.rojazz => 'Rojazz',
    };
  }

  static VerseMediaType fromString(String value) {
    return switch (value.toLowerCase()) {
      'joz' => VerseMediaType.joz,
      'yahum' => VerseMediaType.yahum,
      'terem' => VerseMediaType.terem,
      'inat' => VerseMediaType.inat,
      'rojazz' => VerseMediaType.rojazz,
      _ => VerseMediaType.joz,
    };
  }
}
