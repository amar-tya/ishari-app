import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ishari/features/kitab/domain/entities/book_entity.dart';

part 'book_model.freezed.dart';
part 'book_model.g.dart';

String _idToString(dynamic v) => v.toString();

@freezed
abstract class BookModel with _$BookModel {
  const factory BookModel({
    @JsonKey(fromJson: _idToString) required String id,
    required String title,
    String? author,
    String? description,
    @JsonKey(name: 'published_year') int? publishedYear,
    @JsonKey(name: 'cover_image_url') String? coverImageUrl,
  }) = _BookModel;

  const BookModel._();

  factory BookModel.fromJson(Map<String, dynamic> json) =>
      _$BookModelFromJson(json);

  BookEntity toEntity() => BookEntity(
    id: id,
    title: title,
    author: author,
    description: description,
    publishedYear: publishedYear,
    coverImageUrl: coverImageUrl,
  );
}
