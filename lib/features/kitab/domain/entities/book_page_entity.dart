import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_page_entity.freezed.dart';

@freezed
abstract class BookPageEntity with _$BookPageEntity {
  const factory BookPageEntity({
    required int id,
    required int bookId,
    required int pageNumber,
    required String imageUrl,
    int? chapterId,
  }) = _BookPageEntity;
}
