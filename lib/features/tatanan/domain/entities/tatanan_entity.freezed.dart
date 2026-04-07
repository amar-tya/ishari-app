// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tatanan_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TatananEntity {

 String get id; String get userId; int get chapterId; String get name; DateTime get createdAt; DateTime get updatedAt; String? get description; int get verseCount; String get chapterTitle; String get category; int? get chapterNumber;
/// Create a copy of TatananEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TatananEntityCopyWith<TatananEntity> get copyWith => _$TatananEntityCopyWithImpl<TatananEntity>(this as TatananEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TatananEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.verseCount, verseCount) || other.verseCount == verseCount)&&(identical(other.chapterTitle, chapterTitle) || other.chapterTitle == chapterTitle)&&(identical(other.category, category) || other.category == category)&&(identical(other.chapterNumber, chapterNumber) || other.chapterNumber == chapterNumber));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,chapterId,name,createdAt,updatedAt,description,verseCount,chapterTitle,category,chapterNumber);

@override
String toString() {
  return 'TatananEntity(id: $id, userId: $userId, chapterId: $chapterId, name: $name, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, verseCount: $verseCount, chapterTitle: $chapterTitle, category: $category, chapterNumber: $chapterNumber)';
}


}

/// @nodoc
abstract mixin class $TatananEntityCopyWith<$Res>  {
  factory $TatananEntityCopyWith(TatananEntity value, $Res Function(TatananEntity) _then) = _$TatananEntityCopyWithImpl;
@useResult
$Res call({
 String id, String userId, int chapterId, String name, DateTime createdAt, DateTime updatedAt, String? description, int verseCount, String chapterTitle, String category, int? chapterNumber
});




}
/// @nodoc
class _$TatananEntityCopyWithImpl<$Res>
    implements $TatananEntityCopyWith<$Res> {
  _$TatananEntityCopyWithImpl(this._self, this._then);

  final TatananEntity _self;
  final $Res Function(TatananEntity) _then;

/// Create a copy of TatananEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? chapterId = null,Object? name = null,Object? createdAt = null,Object? updatedAt = null,Object? description = freezed,Object? verseCount = null,Object? chapterTitle = null,Object? category = null,Object? chapterNumber = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,verseCount: null == verseCount ? _self.verseCount : verseCount // ignore: cast_nullable_to_non_nullable
as int,chapterTitle: null == chapterTitle ? _self.chapterTitle : chapterTitle // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,chapterNumber: freezed == chapterNumber ? _self.chapterNumber : chapterNumber // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [TatananEntity].
extension TatananEntityPatterns on TatananEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TatananEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TatananEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TatananEntity value)  $default,){
final _that = this;
switch (_that) {
case _TatananEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TatananEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TatananEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  int chapterId,  String name,  DateTime createdAt,  DateTime updatedAt,  String? description,  int verseCount,  String chapterTitle,  String category,  int? chapterNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TatananEntity() when $default != null:
return $default(_that.id,_that.userId,_that.chapterId,_that.name,_that.createdAt,_that.updatedAt,_that.description,_that.verseCount,_that.chapterTitle,_that.category,_that.chapterNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  int chapterId,  String name,  DateTime createdAt,  DateTime updatedAt,  String? description,  int verseCount,  String chapterTitle,  String category,  int? chapterNumber)  $default,) {final _that = this;
switch (_that) {
case _TatananEntity():
return $default(_that.id,_that.userId,_that.chapterId,_that.name,_that.createdAt,_that.updatedAt,_that.description,_that.verseCount,_that.chapterTitle,_that.category,_that.chapterNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  int chapterId,  String name,  DateTime createdAt,  DateTime updatedAt,  String? description,  int verseCount,  String chapterTitle,  String category,  int? chapterNumber)?  $default,) {final _that = this;
switch (_that) {
case _TatananEntity() when $default != null:
return $default(_that.id,_that.userId,_that.chapterId,_that.name,_that.createdAt,_that.updatedAt,_that.description,_that.verseCount,_that.chapterTitle,_that.category,_that.chapterNumber);case _:
  return null;

}
}

}

/// @nodoc


class _TatananEntity implements TatananEntity {
  const _TatananEntity({required this.id, required this.userId, required this.chapterId, required this.name, required this.createdAt, required this.updatedAt, this.description, this.verseCount = 0, this.chapterTitle = '', this.category = '', this.chapterNumber});
  

@override final  String id;
@override final  String userId;
@override final  int chapterId;
@override final  String name;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? description;
@override@JsonKey() final  int verseCount;
@override@JsonKey() final  String chapterTitle;
@override@JsonKey() final  String category;
@override final  int? chapterNumber;

/// Create a copy of TatananEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TatananEntityCopyWith<_TatananEntity> get copyWith => __$TatananEntityCopyWithImpl<_TatananEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TatananEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.name, name) || other.name == name)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.verseCount, verseCount) || other.verseCount == verseCount)&&(identical(other.chapterTitle, chapterTitle) || other.chapterTitle == chapterTitle)&&(identical(other.category, category) || other.category == category)&&(identical(other.chapterNumber, chapterNumber) || other.chapterNumber == chapterNumber));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,chapterId,name,createdAt,updatedAt,description,verseCount,chapterTitle,category,chapterNumber);

@override
String toString() {
  return 'TatananEntity(id: $id, userId: $userId, chapterId: $chapterId, name: $name, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, verseCount: $verseCount, chapterTitle: $chapterTitle, category: $category, chapterNumber: $chapterNumber)';
}


}

/// @nodoc
abstract mixin class _$TatananEntityCopyWith<$Res> implements $TatananEntityCopyWith<$Res> {
  factory _$TatananEntityCopyWith(_TatananEntity value, $Res Function(_TatananEntity) _then) = __$TatananEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, int chapterId, String name, DateTime createdAt, DateTime updatedAt, String? description, int verseCount, String chapterTitle, String category, int? chapterNumber
});




}
/// @nodoc
class __$TatananEntityCopyWithImpl<$Res>
    implements _$TatananEntityCopyWith<$Res> {
  __$TatananEntityCopyWithImpl(this._self, this._then);

  final _TatananEntity _self;
  final $Res Function(_TatananEntity) _then;

/// Create a copy of TatananEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? chapterId = null,Object? name = null,Object? createdAt = null,Object? updatedAt = null,Object? description = freezed,Object? verseCount = null,Object? chapterTitle = null,Object? category = null,Object? chapterNumber = freezed,}) {
  return _then(_TatananEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,verseCount: null == verseCount ? _self.verseCount : verseCount // ignore: cast_nullable_to_non_nullable
as int,chapterTitle: null == chapterTitle ? _self.chapterTitle : chapterTitle // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,chapterNumber: freezed == chapterNumber ? _self.chapterNumber : chapterNumber // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
