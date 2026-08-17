import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ishari/features/kitab/domain/entities/book_page_entity.dart';

part 'book_page_model.freezed.dart';
part 'book_page_model.g.dart';

@freezed
abstract class BookPageModel with _$BookPageModel {
  const factory BookPageModel({
    required int id,
    @JsonKey(name: 'book_id') required int bookId,
    @JsonKey(name: 'page_number') required int pageNumber,
    @JsonKey(name: 'image_url') required String imageUrl,
    @JsonKey(name: 'chapter_id') int? chapterId,
  }) = _BookPageModel;

  const BookPageModel._();

  factory BookPageModel.fromJson(Map<String, dynamic> json) =>
      _$BookPageModelFromJson(json);

  BookPageEntity toEntity() => BookPageEntity(
    id: id,
    bookId: bookId,
    pageNumber: pageNumber,
    imageUrl: imageUrl,
    chapterId: chapterId,
  );
}
