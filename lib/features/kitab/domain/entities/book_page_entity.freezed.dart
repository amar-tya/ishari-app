// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_page_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookPageEntity {

 int get id; int get bookId; int get pageNumber; String get imageUrl; int? get chapterId;
/// Create a copy of BookPageEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookPageEntityCopyWith<BookPageEntity> get copyWith => _$BookPageEntityCopyWithImpl<BookPageEntity>(this as BookPageEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookPageEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId));
}


@override
int get hashCode => Object.hash(runtimeType,id,bookId,pageNumber,imageUrl,chapterId);

@override
String toString() {
  return 'BookPageEntity(id: $id, bookId: $bookId, pageNumber: $pageNumber, imageUrl: $imageUrl, chapterId: $chapterId)';
}


}

/// @nodoc
abstract mixin class $BookPageEntityCopyWith<$Res>  {
  factory $BookPageEntityCopyWith(BookPageEntity value, $Res Function(BookPageEntity) _then) = _$BookPageEntityCopyWithImpl;
@useResult
$Res call({
 int id, int bookId, int pageNumber, String imageUrl, int? chapterId
});




}
/// @nodoc
class _$BookPageEntityCopyWithImpl<$Res>
    implements $BookPageEntityCopyWith<$Res> {
  _$BookPageEntityCopyWithImpl(this._self, this._then);

  final BookPageEntity _self;
  final $Res Function(BookPageEntity) _then;

/// Create a copy of BookPageEntity
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


/// Adds pattern-matching-related methods to [BookPageEntity].
extension BookPageEntityPatterns on BookPageEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookPageEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookPageEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookPageEntity value)  $default,){
final _that = this;
switch (_that) {
case _BookPageEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookPageEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BookPageEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int bookId,  int pageNumber,  String imageUrl,  int? chapterId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookPageEntity() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int bookId,  int pageNumber,  String imageUrl,  int? chapterId)  $default,) {final _that = this;
switch (_that) {
case _BookPageEntity():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int bookId,  int pageNumber,  String imageUrl,  int? chapterId)?  $default,) {final _that = this;
switch (_that) {
case _BookPageEntity() when $default != null:
return $default(_that.id,_that.bookId,_that.pageNumber,_that.imageUrl,_that.chapterId);case _:
  return null;

}
}

}

/// @nodoc


class _BookPageEntity implements BookPageEntity {
  const _BookPageEntity({required this.id, required this.bookId, required this.pageNumber, required this.imageUrl, this.chapterId});
  

@override final  int id;
@override final  int bookId;
@override final  int pageNumber;
@override final  String imageUrl;
@override final  int? chapterId;

/// Create a copy of BookPageEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookPageEntityCopyWith<_BookPageEntity> get copyWith => __$BookPageEntityCopyWithImpl<_BookPageEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookPageEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.bookId, bookId) || other.bookId == bookId)&&(identical(other.pageNumber, pageNumber) || other.pageNumber == pageNumber)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId));
}


@override
int get hashCode => Object.hash(runtimeType,id,bookId,pageNumber,imageUrl,chapterId);

@override
String toString() {
  return 'BookPageEntity(id: $id, bookId: $bookId, pageNumber: $pageNumber, imageUrl: $imageUrl, chapterId: $chapterId)';
}


}

/// @nodoc
abstract mixin class _$BookPageEntityCopyWith<$Res> implements $BookPageEntityCopyWith<$Res> {
  factory _$BookPageEntityCopyWith(_BookPageEntity value, $Res Function(_BookPageEntity) _then) = __$BookPageEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, int bookId, int pageNumber, String imageUrl, int? chapterId
});




}
/// @nodoc
class __$BookPageEntityCopyWithImpl<$Res>
    implements _$BookPageEntityCopyWith<$Res> {
  __$BookPageEntityCopyWithImpl(this._self, this._then);

  final _BookPageEntity _self;
  final $Res Function(_BookPageEntity) _then;

/// Create a copy of BookPageEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? bookId = null,Object? pageNumber = null,Object? imageUrl = null,Object? chapterId = freezed,}) {
  return _then(_BookPageEntity(
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
