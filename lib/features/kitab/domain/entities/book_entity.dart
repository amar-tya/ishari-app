import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_entity.freezed.dart';

@freezed
abstract class BookEntity with _$BookEntity {
  const factory BookEntity({
    required String id,
    required String title,
    String? author,
    String? description,
    int? publishedYear,
    String? coverImageUrl,
  }) = _BookEntity;
}
