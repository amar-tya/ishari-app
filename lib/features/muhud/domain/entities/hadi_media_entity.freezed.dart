// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hadi_media_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HadiMediaEntity {

 String get id; String get name; String? get photoUrl;
/// Create a copy of HadiMediaEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HadiMediaEntityCopyWith<HadiMediaEntity> get copyWith => _$HadiMediaEntityCopyWithImpl<HadiMediaEntity>(this as HadiMediaEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HadiMediaEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,photoUrl);

@override
String toString() {
  return 'HadiMediaEntity(id: $id, name: $name, photoUrl: $photoUrl)';
}


}

/// @nodoc
abstract mixin class $HadiMediaEntityCopyWith<$Res>  {
  factory $HadiMediaEntityCopyWith(HadiMediaEntity value, $Res Function(HadiMediaEntity) _then) = _$HadiMediaEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? photoUrl
});




}
/// @nodoc
class _$HadiMediaEntityCopyWithImpl<$Res>
    implements $HadiMediaEntityCopyWith<$Res> {
  _$HadiMediaEntityCopyWithImpl(this._self, this._then);

  final HadiMediaEntity _self;
  final $Res Function(HadiMediaEntity) _then;

/// Create a copy of HadiMediaEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? photoUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HadiMediaEntity].
extension HadiMediaEntityPatterns on HadiMediaEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HadiMediaEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HadiMediaEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HadiMediaEntity value)  $default,){
final _that = this;
switch (_that) {
case _HadiMediaEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HadiMediaEntity value)?  $default,){
final _that = this;
switch (_that) {
case _HadiMediaEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? photoUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HadiMediaEntity() when $default != null:
return $default(_that.id,_that.name,_that.photoUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? photoUrl)  $default,) {final _that = this;
switch (_that) {
case _HadiMediaEntity():
return $default(_that.id,_that.name,_that.photoUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? photoUrl)?  $default,) {final _that = this;
switch (_that) {
case _HadiMediaEntity() when $default != null:
return $default(_that.id,_that.name,_that.photoUrl);case _:
  return null;

}
}

}

/// @nodoc


class _HadiMediaEntity implements HadiMediaEntity {
  const _HadiMediaEntity({required this.id, required this.name, this.photoUrl});
  

@override final  String id;
@override final  String name;
@override final  String? photoUrl;

/// Create a copy of HadiMediaEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HadiMediaEntityCopyWith<_HadiMediaEntity> get copyWith => __$HadiMediaEntityCopyWithImpl<_HadiMediaEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HadiMediaEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,photoUrl);

@override
String toString() {
  return 'HadiMediaEntity(id: $id, name: $name, photoUrl: $photoUrl)';
}


}

/// @nodoc
abstract mixin class _$HadiMediaEntityCopyWith<$Res> implements $HadiMediaEntityCopyWith<$Res> {
  factory _$HadiMediaEntityCopyWith(_HadiMediaEntity value, $Res Function(_HadiMediaEntity) _then) = __$HadiMediaEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? photoUrl
});




}
/// @nodoc
class __$HadiMediaEntityCopyWithImpl<$Res>
    implements _$HadiMediaEntityCopyWith<$Res> {
  __$HadiMediaEntityCopyWithImpl(this._self, this._then);

  final _HadiMediaEntity _self;
  final $Res Function(_HadiMediaEntity) _then;

/// Create a copy of HadiMediaEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? photoUrl = freezed,}) {
  return _then(_HadiMediaEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
