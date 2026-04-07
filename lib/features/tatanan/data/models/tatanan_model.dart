import 'package:ishari/features/tatanan/domain/entities/tatanan_entity.dart';

class TatananModel {
  const TatananModel({
    required this.id,
    required this.userId,
    required this.chapterId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.verseCount,
    required this.chapterTitle,
    required this.category,
    this.description,
    this.chapterNumber,
  });

  factory TatananModel.fromJson(Map<String, dynamic> json) {
    final chapter = json['chapters'] as Map<String, dynamic>? ?? {};
    final verses = json['tatanan_verses'] as List<dynamic>? ?? [];

    return TatananModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      chapterId: _parseInt(json['chapter_id']),
      name: json['name'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      verseCount: verses.length,
      chapterTitle: chapter['title'] as String? ?? '',
      category: chapter['category'] as String? ?? '',
      chapterNumber: (chapter['chapter_number'] as num?)?.toInt(),
    );
  }

  final String id;
  final String userId;
  final int chapterId;
  final String name;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int verseCount;
  final String chapterTitle;
  final String category;
  final int? chapterNumber;

  TatananEntity toEntity() => TatananEntity(
        id: id,
        userId: userId,
        chapterId: chapterId,
        name: name,
        description: description,
        createdAt: createdAt,
        updatedAt: updatedAt,
        verseCount: verseCount,
        chapterTitle: chapterTitle,
        category: category,
        chapterNumber: chapterNumber,
      );

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
