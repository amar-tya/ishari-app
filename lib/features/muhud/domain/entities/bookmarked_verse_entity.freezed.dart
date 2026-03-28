// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bookmarked_verse_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookmarkedVerseEntity {

 int get verseId; int get verseNumber; String get arabicText; String get transliteration; int get chapterId; String get chapterTitle; String get chapterCategory; DateTime get bookmarkedAt; String? get note;
/// Create a copy of BookmarkedVerseEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookmarkedVerseEntityCopyWith<BookmarkedVerseEntity> get copyWith => _$BookmarkedVerseEntityCopyWithImpl<BookmarkedVerseEntity>(this as BookmarkedVerseEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookmarkedVerseEntity&&(identical(other.verseId, verseId) || other.verseId == verseId)&&(identical(other.verseNumber, verseNumber) || other.verseNumber == verseNumber)&&(identical(other.arabicText, arabicText) || other.arabicText == arabicText)&&(identical(other.transliteration, transliteration) || other.transliteration == transliteration)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.chapterTitle, chapterTitle) || other.chapterTitle == chapterTitle)&&(identical(other.chapterCategory, chapterCategory) || other.chapterCategory == chapterCategory)&&(identical(other.bookmarkedAt, bookmarkedAt) || other.bookmarkedAt == bookmarkedAt)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,verseId,verseNumber,arabicText,transliteration,chapterId,chapterTitle,chapterCategory,bookmarkedAt,note);

@override
String toString() {
  return 'BookmarkedVerseEntity(verseId: $verseId, verseNumber: $verseNumber, arabicText: $arabicText, transliteration: $transliteration, chapterId: $chapterId, chapterTitle: $chapterTitle, chapterCategory: $chapterCategory, bookmarkedAt: $bookmarkedAt, note: $note)';
}


}

/// @nodoc
abstract mixin class $BookmarkedVerseEntityCopyWith<$Res>  {
  factory $BookmarkedVerseEntityCopyWith(BookmarkedVerseEntity value, $Res Function(BookmarkedVerseEntity) _then) = _$BookmarkedVerseEntityCopyWithImpl;
@useResult
$Res call({
 int verseId, int verseNumber, String arabicText, String transliteration, int chapterId, String chapterTitle, String chapterCategory, DateTime bookmarkedAt, String? note
});




}
/// @nodoc
class _$BookmarkedVerseEntityCopyWithImpl<$Res>
    implements $BookmarkedVerseEntityCopyWith<$Res> {
  _$BookmarkedVerseEntityCopyWithImpl(this._self, this._then);

  final BookmarkedVerseEntity _self;
  final $Res Function(BookmarkedVerseEntity) _then;

/// Create a copy of BookmarkedVerseEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? verseId = null,Object? verseNumber = null,Object? arabicText = null,Object? transliteration = null,Object? chapterId = null,Object? chapterTitle = null,Object? chapterCategory = null,Object? bookmarkedAt = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
verseId: null == verseId ? _self.verseId : verseId // ignore: cast_nullable_to_non_nullable
as int,verseNumber: null == verseNumber ? _self.verseNumber : verseNumber // ignore: cast_nullable_to_non_nullable
as int,arabicText: null == arabicText ? _self.arabicText : arabicText // ignore: cast_nullable_to_non_nullable
as String,transliteration: null == transliteration ? _self.transliteration : transliteration // ignore: cast_nullable_to_non_nullable
as String,chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as int,chapterTitle: null == chapterTitle ? _self.chapterTitle : chapterTitle // ignore: cast_nullable_to_non_nullable
as String,chapterCategory: null == chapterCategory ? _self.chapterCategory : chapterCategory // ignore: cast_nullable_to_non_nullable
as String,bookmarkedAt: null == bookmarkedAt ? _self.bookmarkedAt : bookmarkedAt // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BookmarkedVerseEntity].
extension BookmarkedVerseEntityPatterns on BookmarkedVerseEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookmarkedVerseEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookmarkedVerseEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookmarkedVerseEntity value)  $default,){
final _that = this;
switch (_that) {
case _BookmarkedVerseEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookmarkedVerseEntity value)?  $default,){
final _that = this;
switch (_that) {
case _BookmarkedVerseEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int verseId,  int verseNumber,  String arabicText,  String transliteration,  int chapterId,  String chapterTitle,  String chapterCategory,  DateTime bookmarkedAt,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookmarkedVerseEntity() when $default != null:
return $default(_that.verseId,_that.verseNumber,_that.arabicText,_that.transliteration,_that.chapterId,_that.chapterTitle,_that.chapterCategory,_that.bookmarkedAt,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int verseId,  int verseNumber,  String arabicText,  String transliteration,  int chapterId,  String chapterTitle,  String chapterCategory,  DateTime bookmarkedAt,  String? note)  $default,) {final _that = this;
switch (_that) {
case _BookmarkedVerseEntity():
return $default(_that.verseId,_that.verseNumber,_that.arabicText,_that.transliteration,_that.chapterId,_that.chapterTitle,_that.chapterCategory,_that.bookmarkedAt,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int verseId,  int verseNumber,  String arabicText,  String transliteration,  int chapterId,  String chapterTitle,  String chapterCategory,  DateTime bookmarkedAt,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _BookmarkedVerseEntity() when $default != null:
return $default(_that.verseId,_that.verseNumber,_that.arabicText,_that.transliteration,_that.chapterId,_that.chapterTitle,_that.chapterCategory,_that.bookmarkedAt,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _BookmarkedVerseEntity implements BookmarkedVerseEntity {
  const _BookmarkedVerseEntity({required this.verseId, required this.verseNumber, required this.arabicText, required this.transliteration, required this.chapterId, required this.chapterTitle, required this.chapterCategory, required this.bookmarkedAt, this.note});
  

@override final  int verseId;
@override final  int verseNumber;
@override final  String arabicText;
@override final  String transliteration;
@override final  int chapterId;
@override final  String chapterTitle;
@override final  String chapterCategory;
@override final  DateTime bookmarkedAt;
@override final  String? note;

/// Create a copy of BookmarkedVerseEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookmarkedVerseEntityCopyWith<_BookmarkedVerseEntity> get copyWith => __$BookmarkedVerseEntityCopyWithImpl<_BookmarkedVerseEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookmarkedVerseEntity&&(identical(other.verseId, verseId) || other.verseId == verseId)&&(identical(other.verseNumber, verseNumber) || other.verseNumber == verseNumber)&&(identical(other.arabicText, arabicText) || other.arabicText == arabicText)&&(identical(other.transliteration, transliteration) || other.transliteration == transliteration)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.chapterTitle, chapterTitle) || other.chapterTitle == chapterTitle)&&(identical(other.chapterCategory, chapterCategory) || other.chapterCategory == chapterCategory)&&(identical(other.bookmarkedAt, bookmarkedAt) || other.bookmarkedAt == bookmarkedAt)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,verseId,verseNumber,arabicText,transliteration,chapterId,chapterTitle,chapterCategory,bookmarkedAt,note);

@override
String toString() {
  return 'BookmarkedVerseEntity(verseId: $verseId, verseNumber: $verseNumber, arabicText: $arabicText, transliteration: $transliteration, chapterId: $chapterId, chapterTitle: $chapterTitle, chapterCategory: $chapterCategory, bookmarkedAt: $bookmarkedAt, note: $note)';
}


}

/// @nodoc
abstract mixin class _$BookmarkedVerseEntityCopyWith<$Res> implements $BookmarkedVerseEntityCopyWith<$Res> {
  factory _$BookmarkedVerseEntityCopyWith(_BookmarkedVerseEntity value, $Res Function(_BookmarkedVerseEntity) _then) = __$BookmarkedVerseEntityCopyWithImpl;
@override @useResult
$Res call({
 int verseId, int verseNumber, String arabicText, String transliteration, int chapterId, String chapterTitle, String chapterCategory, DateTime bookmarkedAt, String? note
});




}
/// @nodoc
class __$BookmarkedVerseEntityCopyWithImpl<$Res>
    implements _$BookmarkedVerseEntityCopyWith<$Res> {
  __$BookmarkedVerseEntityCopyWithImpl(this._self, this._then);

  final _BookmarkedVerseEntity _self;
  final $Res Function(_BookmarkedVerseEntity) _then;

/// Create a copy of BookmarkedVerseEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? verseId = null,Object? verseNumber = null,Object? arabicText = null,Object? transliteration = null,Object? chapterId = null,Object? chapterTitle = null,Object? chapterCategory = null,Object? bookmarkedAt = null,Object? note = freezed,}) {
  return _then(_BookmarkedVerseEntity(
verseId: null == verseId ? _self.verseId : verseId // ignore: cast_nullable_to_non_nullable
as int,verseNumber: null == verseNumber ? _self.verseNumber : verseNumber // ignore: cast_nullable_to_non_nullable
as int,arabicText: null == arabicText ? _self.arabicText : arabicText // ignore: cast_nullable_to_non_nullable
as String,transliteration: null == transliteration ? _self.transliteration : transliteration // ignore: cast_nullable_to_non_nullable
as String,chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as int,chapterTitle: null == chapterTitle ? _self.chapterTitle : chapterTitle // ignore: cast_nullable_to_non_nullable
as String,chapterCategory: null == chapterCategory ? _self.chapterCategory : chapterCategory // ignore: cast_nullable_to_non_nullable
as String,bookmarkedAt: null == bookmarkedAt ? _self.bookmarkedAt : bookmarkedAt // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
