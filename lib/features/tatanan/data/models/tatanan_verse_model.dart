import 'package:ishari/features/tatanan/domain/entities/tatanan_verse_entity.dart';

class TatananVerseModel {
  const TatananVerseModel({
    required this.id,
    required this.tatananId,
    required this.verseId,
    required this.position,
    required this.verseNumber,
    required this.arabicText,
    required this.transliteration,
  });

  factory TatananVerseModel.fromJson(Map<String, dynamic> json) {
    final verse = json['verses'] as Map<String, dynamic>? ?? {};

    return TatananVerseModel(
      id: json['id'] as String,
      tatananId: json['tatanan_id'] as String,
      verseId: _parseInt(json['verse_id']),
      position: _parseInt(json['position']),
      verseNumber: _parseInt(verse['verse_number']),
      arabicText: verse['arabic_text'] as String? ?? '',
      transliteration: verse['transliteration'] as String? ?? '',
    );
  }

  final String id;
  final String tatananId;
  final int verseId;
  final int position;
  final int verseNumber;
  final String arabicText;
  final String transliteration;

  TatananVerseEntity toEntity() => TatananVerseEntity(
        id: id,
        tatananId: tatananId,
        verseId: verseId,
        position: position,
        verseNumber: verseNumber,
        arabicText: arabicText,
        transliteration: transliteration,
      );

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
