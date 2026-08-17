// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_page_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookPageModel {

 int get id;@JsonKey(name: 'book_id') int get bookId;@JsonKey(name: 'page_number') int get pageNumber;@JsonKey(name: 'image_url') String get imageUrl;@JsonKey(name: 'chapter_id') int? get chapterId;
/// Create a copy of BookPageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookPageModelCopyWith<BookPageModel> get copyWith => _$BookPageModelCopyWithImpl<BookPageModel>(this as BookPageModel, _$identity);

  /// Serializes this BookPageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookPageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookId,pageNumber,imageUrl,chapterId);

@override
String toString() {
  return 'BookPageModel(id: $id, bookId: $bookId, pageNumber: $pageNumber, imageUrl: $imageUrl, chapterId: $chapterId)';
}


}

/// @nodoc
abstract mixin class $BookPageModelCopyWith<$Res>  {
  factory $BookPageModelCopyWith(BookPageModel value, $Res Function(BookPageModel) _then) = _$BookPageModelCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'book_id') int bookId,@JsonKey(name: 'page_number') int pageNumber,@JsonKey(name: 'image_url') String imageUrl,@JsonKey(name: 'chapter_id') int? chapterId
});




}
/// @nodoc
class _$BookPageModelCopyWithImpl<$Res>
    implements $BookPageModelCopyWith<$Res> {
  _$BookPageModelCopyWithImpl(this._self, this._then);

  final BookPageModel _self;
  final $Res Function(BookPageModel) _then;

/// Create a copy of BookPageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? bookId = null,Object? pageNumber = null,Object? imageUrl = null,Object? chapterId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as int,pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,chapterId: freezed == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookPageModel].
extension BookPageModelPatterns on BookPageModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookPageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookPageModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookPageModel value)  $default,){
final _that = this;
switch (_that) {
case _BookPageModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookPageModel value)?  $default,){
final _that = this;
switch (_that) {
case _BookPageModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'book_id')  int bookId, @JsonKey(name: 'page_number')  int pageNumber, @JsonKey(name: 'image_url')  String imageUrl, @JsonKey(name: 'chapter_id')  int? chapterId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookPageModel() when $default != null:
return $default(_that.id,_that.bookId,_that.pageNumber,_that.imageUrl,_that.chapterId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'book_id')  int bookId, @JsonKey(name: 'page_number')  int pageNumber, @JsonKey(name: 'image_url')  String imageUrl, @JsonKey(name: 'chapter_id')  int? chapterId)  $default,) {final _that = this;
switch (_that) {
case _BookPageModel():
return $default(_that.id,_that.bookId,_that.pageNumber,_that.imageUrl,_that.chapterId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'book_id')  int bookId, @JsonKey(name: 'page_number')  int pageNumber, @JsonKey(name: 'image_url')  String imageUrl, @JsonKey(name: 'chapter_id')  int? chapterId)?  $default,) {final _that = this;
switch (_that) {
case _BookPageModel() when $default != null:
return $default(_that.id,_that.bookId,_that.pageNumber,_that.imageUrl,_that.chapterId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookPageModel extends BookPageModel {
  const _BookPageModel({required this.id, @JsonKey(name: 'book_id') required this.bookId, @JsonKey(name: 'page_number') required this.pageNumber, @JsonKey(name: 'image_url') required this.imageUrl, @JsonKey(name: 'chapter_id') this.chapterId}): super._();
  factory _BookPageModel.fromJson(Map<String, dynamic> json) => _$BookPageModelFromJson(json);

@override final  int id;
@override@JsonKey(name: 'book_id') final  int bookId;
@override@JsonKey(name: 'page_number') final  int pageNumber;
@override@JsonKey(name: 'image_url') final  String imageUrl;
@override@JsonKey(name: 'chapter_id') final  int? chapterId;

/// Create a copy of BookPageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookPageModelCopyWith<_BookPageModel> get copyWith => __$BookPageModelCopyWithImpl<_BookPageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookPageModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookPageModel&&(identical(other.id, id) || other.id == id)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,bookId,pageNumber,imageUrl,chapterId);

@override
String toString() {
  return 'BookPageModel(id: $id, bookId: $bookId, pageNumber: $pageNumber, imageUrl: $imageUrl, chapterId: $chapterId)';
}


}

/// @nodoc
abstract mixin class _$BookPageModelCopyWith<$Res> implements $BookPageModelCopyWith<$Res> {
  factory _$BookPageModelCopyWith(_BookPageModel value, $Res Function(_BookPageModel) _then) = __$BookPageModelCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'book_id') int bookId,@JsonKey(name: 'page_number') int pageNumber,@JsonKey(name: 'image_url') String imageUrl,@JsonKey(name: 'chapter_id') int? chapterId
});




}
/// @nodoc
class __$BookPageModelCopyWithImpl<$Res>
    implements _$BookPageModelCopyWith<$Res> {
  __$BookPageModelCopyWithImpl(this._self, this._then);

  final _BookPageModel _self;
  final $Res Function(_BookPageModel) _then;

/// Create a copy of BookPageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bookId = null,Object? pageNumber = null,Object? imageUrl = null,Object? chapterId = freezed,}) {
  return _then(_BookPageModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,bookId: null == bookId ? _self.bookId : bookId // ignore: cast_nullable_to_non_nullable
as int,pageNumber: null == pageNumber ? _self.pageNumber : pageNumber // ignore: cast_nullable_to_non_nullable
as int,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,chapterId: freezed == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
