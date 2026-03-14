// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hadi_media_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HadiMediaModel {

@JsonKey(fromJson: _idToString) String get id; String get name;@JsonKey(name: 'image_url') String? get photoUrl;
/// Create a copy of HadiMediaModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HadiMediaModelCopyWith<HadiMediaModel> get copyWith => _$HadiMediaModelCopyWithImpl<HadiMediaModel>(this as HadiMediaModel, _$identity);

  /// Serializes this HadiMediaModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HadiMediaModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,photoUrl);

@override
String toString() {
  return 'HadiMediaModel(id: $id, name: $name, photoUrl: $photoUrl)';
}


}

/// @nodoc
abstract mixin class $HadiMediaModelCopyWith<$Res>  {
  factory $HadiMediaModelCopyWith(HadiMediaModel value, $Res Function(HadiMediaModel) _then) = _$HadiMediaModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _idToString) String id, String name,@JsonKey(name: 'image_url') String? photoUrl
});




}
/// @nodoc
class _$HadiMediaModelCopyWithImpl<$Res>
    implements $HadiMediaModelCopyWith<$Res> {
  _$HadiMediaModelCopyWithImpl(this._self, this._then);

  final HadiMediaModel _self;
  final $Res Function(HadiMediaModel) _then;

/// Create a copy of HadiMediaModel
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


/// Adds pattern-matching-related methods to [HadiMediaModel].
extension HadiMediaModelPatterns on HadiMediaModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HadiMediaModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HadiMediaModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HadiMediaModel value)  $default,){
final _that = this;
switch (_that) {
case _HadiMediaModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HadiMediaModel value)?  $default,){
final _that = this;
switch (_that) {
case _HadiMediaModel() when $default != null:
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
case _HadiMediaModel() when $default != null:
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
case _HadiMediaModel():
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
case _HadiMediaModel() when $default != null:
return $default(_that.id,_that.name,_that.photoUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HadiMediaModel extends HadiMediaModel {
  const _HadiMediaModel({@JsonKey(fromJson: _idToString) required this.id, required this.name, @JsonKey(name: 'image_url') this.photoUrl}): super._();
  factory _HadiMediaModel.fromJson(Map<String, dynamic> json) => _$HadiMediaModelFromJson(json);

@override@JsonKey(fromJson: _idToString) final  String id;
@override final  String name;
@override@JsonKey(name: 'image_url') final  String? photoUrl;

/// Create a copy of HadiMediaModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HadiMediaModelCopyWith<_HadiMediaModel> get copyWith => __$HadiMediaModelCopyWithImpl<_HadiMediaModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HadiMediaModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HadiMediaModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,photoUrl);

@override
String toString() {
  return 'HadiMediaModel(id: $id, name: $name, photoUrl: $photoUrl)';
}


}

/// @nodoc
abstract mixin class _$HadiMediaModelCopyWith<$Res> implements $HadiMediaModelCopyWith<$Res> {
  factory _$HadiMediaModelCopyWith(_HadiMediaModel value, $Res Function(_HadiMediaModel) _then) = __$HadiMediaModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _idToString) String id, String name,@JsonKey(name: 'image_url') String? photoUrl
});




}
/// @nodoc
class __$HadiMediaModelCopyWithImpl<$Res>
    implements _$HadiMediaModelCopyWith<$Res> {
  __$HadiMediaModelCopyWithImpl(this._self, this._then);

  final _HadiMediaModel _self;
  final $Res Function(_HadiMediaModel) _then;

/// Create a copy of HadiMediaModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? photoUrl = freezed,}) {
  return _then(_HadiMediaModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
