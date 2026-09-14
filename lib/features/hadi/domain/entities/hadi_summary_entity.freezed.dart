// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hadi_summary_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HadiSummaryEntity {

 String get id; String get name; String? get photoUrl; String? get description;
/// Create a copy of HadiSummaryEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HadiSummaryEntityCopyWith<HadiSummaryEntity> get copyWith => _$HadiSummaryEntityCopyWithImpl<HadiSummaryEntity>(this as HadiSummaryEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HadiSummaryEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,photoUrl,description);

@override
String toString() {
  return 'HadiSummaryEntity(id: $id, name: $name, photoUrl: $photoUrl, description: $description)';
}


}

/// @nodoc
abstract mixin class $HadiSummaryEntityCopyWith<$Res>  {
  factory $HadiSummaryEntityCopyWith(HadiSummaryEntity value, $Res Function(HadiSummaryEntity) _then) = _$HadiSummaryEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? photoUrl, String? description
});




}
/// @nodoc
class _$HadiSummaryEntityCopyWithImpl<$Res>
    implements $HadiSummaryEntityCopyWith<$Res> {
  _$HadiSummaryEntityCopyWithImpl(this._self, this._then);

  final HadiSummaryEntity _self;
  final $Res Function(HadiSummaryEntity) _then;

/// Create a copy of HadiSummaryEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? photoUrl = freezed,Object? description = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HadiSummaryEntity].
extension HadiSummaryEntityPatterns on HadiSummaryEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HadiSummaryEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HadiSummaryEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HadiSummaryEntity value)  $default,){
final _that = this;
switch (_that) {
case _HadiSummaryEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HadiSummaryEntity value)?  $default,){
final _that = this;
switch (_that) {
case _HadiSummaryEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? photoUrl,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HadiSummaryEntity() when $default != null:
return $default(_that.id,_that.name,_that.photoUrl,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? photoUrl,  String? description)  $default,) {final _that = this;
switch (_that) {
case _HadiSummaryEntity():
return $default(_that.id,_that.name,_that.photoUrl,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? photoUrl,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _HadiSummaryEntity() when $default != null:
return $default(_that.id,_that.name,_that.photoUrl,_that.description);case _:
  return null;

}
}

}

/// @nodoc


class _HadiSummaryEntity implements HadiSummaryEntity {
  const _HadiSummaryEntity({required this.id, required this.name, this.photoUrl, this.description});
  

@override final  String id;
@override final  String name;
@override final  String? photoUrl;
@override final  String? description;

/// Create a copy of HadiSummaryEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HadiSummaryEntityCopyWith<_HadiSummaryEntity> get copyWith => __$HadiSummaryEntityCopyWithImpl<_HadiSummaryEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HadiSummaryEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,photoUrl,description);

@override
String toString() {
  return 'HadiSummaryEntity(id: $id, name: $name, photoUrl: $photoUrl, description: $description)';
}


}

/// @nodoc
abstract mixin class _$HadiSummaryEntityCopyWith<$Res> implements $HadiSummaryEntityCopyWith<$Res> {
  factory _$HadiSummaryEntityCopyWith(_HadiSummaryEntity value, $Res Function(_HadiSummaryEntity) _then) = __$HadiSummaryEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? photoUrl, String? description
});




}
/// @nodoc
class __$HadiSummaryEntityCopyWithImpl<$Res>
    implements _$HadiSummaryEntityCopyWith<$Res> {
  __$HadiSummaryEntityCopyWithImpl(this._self, this._then);

  final _HadiSummaryEntity _self;
  final $Res Function(_HadiSummaryEntity) _then;

/// Create a copy of HadiSummaryEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? photoUrl = freezed,Object? description = freezed,}) {
  return _then(_HadiSummaryEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
