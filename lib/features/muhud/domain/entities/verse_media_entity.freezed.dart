// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verse_media_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VerseMediaEntity {

 int get id; int get verseId; HadiMediaEntity get hadi; String get mediaUrl; int get duration; VerseMediaType get type;
/// Create a copy of VerseMediaEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerseMediaEntityCopyWith<VerseMediaEntity> get copyWith => _$VerseMediaEntityCopyWithImpl<VerseMediaEntity>(this as VerseMediaEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerseMediaEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.verseId, verseId) || other.verseId == verseId)&&(identical(other.hadi, hadi) || other.hadi == hadi)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,id,verseId,hadi,mediaUrl,duration,type);

@override
String toString() {
  return 'VerseMediaEntity(id: $id, verseId: $verseId, hadi: $hadi, mediaUrl: $mediaUrl, duration: $duration, type: $type)';
}


}

/// @nodoc
abstract mixin class $VerseMediaEntityCopyWith<$Res>  {
  factory $VerseMediaEntityCopyWith(VerseMediaEntity value, $Res Function(VerseMediaEntity) _then) = _$VerseMediaEntityCopyWithImpl;
@useResult
$Res call({
 int id, int verseId, HadiMediaEntity hadi, String mediaUrl, int duration, VerseMediaType type
});


$HadiMediaEntityCopyWith<$Res> get hadi;

}
/// @nodoc
class _$VerseMediaEntityCopyWithImpl<$Res>
    implements $VerseMediaEntityCopyWith<$Res> {
  _$VerseMediaEntityCopyWithImpl(this._self, this._then);

  final VerseMediaEntity _self;
  final $Res Function(VerseMediaEntity) _then;

/// Create a copy of VerseMediaEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? verseId = null,Object? hadi = null,Object? mediaUrl = null,Object? duration = null,Object? type = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,verseId: null == verseId ? _self.verseId : verseId // ignore: cast_nullable_to_non_nullable
as int,hadi: null == hadi ? _self.hadi : hadi // ignore: cast_nullable_to_non_nullable
as HadiMediaEntity,mediaUrl: null == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as VerseMediaType,
  ));
}
/// Create a copy of VerseMediaEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HadiMediaEntityCopyWith<$Res> get hadi {
  
  return $HadiMediaEntityCopyWith<$Res>(_self.hadi, (value) {
    return _then(_self.copyWith(hadi: value));
  });
}
}


/// Adds pattern-matching-related methods to [VerseMediaEntity].
extension VerseMediaEntityPatterns on VerseMediaEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerseMediaEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerseMediaEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerseMediaEntity value)  $default,){
final _that = this;
switch (_that) {
case _VerseMediaEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerseMediaEntity value)?  $default,){
final _that = this;
switch (_that) {
case _VerseMediaEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int verseId,  HadiMediaEntity hadi,  String mediaUrl,  int duration,  VerseMediaType type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerseMediaEntity() when $default != null:
return $default(_that.id,_that.verseId,_that.hadi,_that.mediaUrl,_that.duration,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int verseId,  HadiMediaEntity hadi,  String mediaUrl,  int duration,  VerseMediaType type)  $default,) {final _that = this;
switch (_that) {
case _VerseMediaEntity():
return $default(_that.id,_that.verseId,_that.hadi,_that.mediaUrl,_that.duration,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int verseId,  HadiMediaEntity hadi,  String mediaUrl,  int duration,  VerseMediaType type)?  $default,) {final _that = this;
switch (_that) {
case _VerseMediaEntity() when $default != null:
return $default(_that.id,_that.verseId,_that.hadi,_that.mediaUrl,_that.duration,_that.type);case _:
  return null;

}
}

}

/// @nodoc


class _VerseMediaEntity implements VerseMediaEntity {
  const _VerseMediaEntity({required this.id, required this.verseId, required this.hadi, required this.mediaUrl, required this.duration, required this.type});
  

@override final  int id;
@override final  int verseId;
@override final  HadiMediaEntity hadi;
@override final  String mediaUrl;
@override final  int duration;
@override final  VerseMediaType type;

/// Create a copy of VerseMediaEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerseMediaEntityCopyWith<_VerseMediaEntity> get copyWith => __$VerseMediaEntityCopyWithImpl<_VerseMediaEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerseMediaEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.verseId, verseId) || other.verseId == verseId)&&(identical(other.hadi, hadi) || other.hadi == hadi)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,id,verseId,hadi,mediaUrl,duration,type);

@override
String toString() {
  return 'VerseMediaEntity(id: $id, verseId: $verseId, hadi: $hadi, mediaUrl: $mediaUrl, duration: $duration, type: $type)';
}


}

/// @nodoc
abstract mixin class _$VerseMediaEntityCopyWith<$Res> implements $VerseMediaEntityCopyWith<$Res> {
  factory _$VerseMediaEntityCopyWith(_VerseMediaEntity value, $Res Function(_VerseMediaEntity) _then) = __$VerseMediaEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, int verseId, HadiMediaEntity hadi, String mediaUrl, int duration, VerseMediaType type
});


@override $HadiMediaEntityCopyWith<$Res> get hadi;

}
/// @nodoc
class __$VerseMediaEntityCopyWithImpl<$Res>
    implements _$VerseMediaEntityCopyWith<$Res> {
  __$VerseMediaEntityCopyWithImpl(this._self, this._then);

  final _VerseMediaEntity _self;
  final $Res Function(_VerseMediaEntity) _then;

/// Create a copy of VerseMediaEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? verseId = null,Object? hadi = null,Object? mediaUrl = null,Object? duration = null,Object? type = null,}) {
  return _then(_VerseMediaEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,verseId: null == verseId ? _self.verseId : verseId // ignore: cast_nullable_to_non_nullable
as int,hadi: null == hadi ? _self.hadi : hadi // ignore: cast_nullable_to_non_nullable
as HadiMediaEntity,mediaUrl: null == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as VerseMediaType,
  ));
}

/// Create a copy of VerseMediaEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HadiMediaEntityCopyWith<$Res> get hadi {
  
  return $HadiMediaEntityCopyWith<$Res>(_self.hadi, (value) {
    return _then(_self.copyWith(hadi: value));
  });
}
}

// dart format on
