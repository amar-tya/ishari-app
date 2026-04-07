// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chapter_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChapterEntity {

 String get id; String get title; String get category; String get description; int get verseCount; int? get number;
/// Create a copy of ChapterEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterEntityCopyWith<ChapterEntity> get copyWith => _$ChapterEntityCopyWithImpl<ChapterEntity>(this as ChapterEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChapterEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.description, description) || other.description == description)&&(identical(other.verseCount, verseCount) || other.verseCount == verseCount)&&(identical(other.number, number) || other.number == number));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,category,description,verseCount,number);

@override
String toString() {
  return 'ChapterEntity(id: $id, title: $title, category: $category, description: $description, verseCount: $verseCount, number: $number)';
}


}

/// @nodoc
abstract mixin class $ChapterEntityCopyWith<$Res>  {
  factory $ChapterEntityCopyWith(ChapterEntity value, $Res Function(ChapterEntity) _then) = _$ChapterEntityCopyWithImpl;
@useResult
$Res call({
 String id, String title, String category, String description, int verseCount, int? number
});




}
/// @nodoc
class _$ChapterEntityCopyWithImpl<$Res>
    implements $ChapterEntityCopyWith<$Res> {
  _$ChapterEntityCopyWithImpl(this._self, this._then);

  final ChapterEntity _self;
  final $Res Function(ChapterEntity) _then;

/// Create a copy of ChapterEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? category = null,Object? description = null,Object? verseCount = null,Object? number = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,verseCount: null == verseCount ? _self.verseCount : verseCount // ignore: cast_nullable_to_non_nullable
as int,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChapterEntity].
extension ChapterEntityPatterns on ChapterEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChapterEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChapterEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChapterEntity value)  $default,){
final _that = this;
switch (_that) {
case _ChapterEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChapterEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ChapterEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String category,  String description,  int verseCount,  int? number)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChapterEntity() when $default != null:
return $default(_that.id,_that.title,_that.category,_that.description,_that.verseCount,_that.number);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String category,  String description,  int verseCount,  int? number)  $default,) {final _that = this;
switch (_that) {
case _ChapterEntity():
return $default(_that.id,_that.title,_that.category,_that.description,_that.verseCount,_that.number);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String category,  String description,  int verseCount,  int? number)?  $default,) {final _that = this;
switch (_that) {
case _ChapterEntity() when $default != null:
return $default(_that.id,_that.title,_that.category,_that.description,_that.verseCount,_that.number);case _:
  return null;

}
}

}

/// @nodoc


class _ChapterEntity implements ChapterEntity {
  const _ChapterEntity({required this.id, required this.title, required this.category, required this.description, this.verseCount = 0, this.number});
  

@override final  String id;
@override final  String title;
@override final  String category;
@override final  String description;
@override@JsonKey() final  int verseCount;
@override final  int? number;

/// Create a copy of ChapterEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChapterEntityCopyWith<_ChapterEntity> get copyWith => __$ChapterEntityCopyWithImpl<_ChapterEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChapterEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.description, description) || other.description == description)&&(identical(other.verseCount, verseCount) || other.verseCount == verseCount)&&(identical(other.number, number) || other.number == number));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,category,description,verseCount,number);

@override
String toString() {
  return 'ChapterEntity(id: $id, title: $title, category: $category, description: $description, verseCount: $verseCount, number: $number)';
}


}

/// @nodoc
abstract mixin class _$ChapterEntityCopyWith<$Res> implements $ChapterEntityCopyWith<$Res> {
  factory _$ChapterEntityCopyWith(_ChapterEntity value, $Res Function(_ChapterEntity) _then) = __$ChapterEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String category, String description, int verseCount, int? number
});




}
/// @nodoc
class __$ChapterEntityCopyWithImpl<$Res>
    implements _$ChapterEntityCopyWith<$Res> {
  __$ChapterEntityCopyWithImpl(this._self, this._then);

  final _ChapterEntity _self;
  final $Res Function(_ChapterEntity) _then;

/// Create a copy of ChapterEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? category = null,Object? description = null,Object? verseCount = null,Object? number = freezed,}) {
  return _then(_ChapterEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,verseCount: null == verseCount ? _self.verseCount : verseCount // ignore: cast_nullable_to_non_nullable
as int,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
