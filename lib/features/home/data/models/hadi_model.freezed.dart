// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hadi_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HadiModel {

@JsonKey(fromJson: _idToString) String get id; String get name;@JsonKey(name: 'image_url') String? get photoUrl;
/// Create a copy of HadiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HadiModelCopyWith<HadiModel> get copyWith => _$HadiModelCopyWithImpl<HadiModel>(this as HadiModel, _$identity);

  /// Serializes this HadiModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HadiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,photoUrl);

@override
String toString() {
  return 'HadiModel(id: $id, name: $name, photoUrl: $photoUrl)';
}


}

/// @nodoc
abstract mixin class $HadiModelCopyWith<$Res>  {
  factory $HadiModelCopyWith(HadiModel value, $Res Function(HadiModel) _then) = _$HadiModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _idToString) String id, String name,@JsonKey(name: 'image_url') String? photoUrl
});




}
/// @nodoc
class _$HadiModelCopyWithImpl<$Res>
    implements $HadiModelCopyWith<$Res> {
  _$HadiModelCopyWithImpl(this._self, this._then);

  final HadiModel _self;
  final $Res Function(HadiModel) _then;

/// Create a copy of HadiModel
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


/// Adds pattern-matching-related methods to [HadiModel].
extension HadiModelPatterns on HadiModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HadiModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HadiModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HadiModel value)  $default,){
final _that = this;
switch (_that) {
case _HadiModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HadiModel value)?  $default,){
final _that = this;
switch (_that) {
case _HadiModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idToString)  String id,  String name, @JsonKey(name: 'image_url')  String? photoUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HadiModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idToString)  String id,  String name, @JsonKey(name: 'image_url')  String? photoUrl)  $default,) {final _that = this;
switch (_that) {
case _HadiModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _idToString)  String id,  String name, @JsonKey(name: 'image_url')  String? photoUrl)?  $default,) {final _that = this;
switch (_that) {
case _HadiModel() when $default != null:
return $default(_that.id,_that.name,_that.photoUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HadiModel extends HadiModel {
  const _HadiModel({@JsonKey(fromJson: _idToString) required this.id, required this.name, @JsonKey(name: 'image_url') this.photoUrl}): super._();
  factory _HadiModel.fromJson(Map<String, dynamic> json) => _$HadiModelFromJson(json);

@override@JsonKey(fromJson: _idToString) final  String id;
@override final  String name;
@override@JsonKey(name: 'image_url') final  String? photoUrl;

/// Create a copy of HadiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HadiModelCopyWith<_HadiModel> get copyWith => __$HadiModelCopyWithImpl<_HadiModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HadiModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HadiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,photoUrl);

@override
String toString() {
  return 'HadiModel(id: $id, name: $name, photoUrl: $photoUrl)';
}


}

/// @nodoc
abstract mixin class _$HadiModelCopyWith<$Res> implements $HadiModelCopyWith<$Res> {
  factory _$HadiModelCopyWith(_HadiModel value, $Res Function(_HadiModel) _then) = __$HadiModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _idToString) String id, String name,@JsonKey(name: 'image_url') String? photoUrl
});




}
/// @nodoc
class __$HadiModelCopyWithImpl<$Res>
    implements _$HadiModelCopyWith<$Res> {
  __$HadiModelCopyWithImpl(this._self, this._then);

  final _HadiModel _self;
  final $Res Function(_HadiModel) _then;

/// Create a copy of HadiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? photoUrl = freezed,}) {
  return _then(_HadiModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
