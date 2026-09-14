// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hadi_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HadiSummaryModel {

@JsonKey(fromJson: _idToString) String get id; String get name;@JsonKey(name: 'image_url') String? get photoUrl; String? get description;
/// Create a copy of HadiSummaryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HadiSummaryModelCopyWith<HadiSummaryModel> get copyWith => _$HadiSummaryModelCopyWithImpl<HadiSummaryModel>(this as HadiSummaryModel, _$identity);

  /// Serializes this HadiSummaryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HadiSummaryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,photoUrl,description);

@override
String toString() {
  return 'HadiSummaryModel(id: $id, name: $name, photoUrl: $photoUrl, description: $description)';
}


}

/// @nodoc
abstract mixin class $HadiSummaryModelCopyWith<$Res>  {
  factory $HadiSummaryModelCopyWith(HadiSummaryModel value, $Res Function(HadiSummaryModel) _then) = _$HadiSummaryModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _idToString) String id, String name,@JsonKey(name: 'image_url') String? photoUrl, String? description
});




}
/// @nodoc
class _$HadiSummaryModelCopyWithImpl<$Res>
    implements $HadiSummaryModelCopyWith<$Res> {
  _$HadiSummaryModelCopyWithImpl(this._self, this._then);

  final HadiSummaryModel _self;
  final $Res Function(HadiSummaryModel) _then;

/// Create a copy of HadiSummaryModel
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


/// Adds pattern-matching-related methods to [HadiSummaryModel].
extension HadiSummaryModelPatterns on HadiSummaryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HadiSummaryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HadiSummaryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HadiSummaryModel value)  $default,){
final _that = this;
switch (_that) {
case _HadiSummaryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HadiSummaryModel value)?  $default,){
final _that = this;
switch (_that) {
case _HadiSummaryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idToString)  String id,  String name, @JsonKey(name: 'image_url')  String? photoUrl,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HadiSummaryModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idToString)  String id,  String name, @JsonKey(name: 'image_url')  String? photoUrl,  String? description)  $default,) {final _that = this;
switch (_that) {
case _HadiSummaryModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _idToString)  String id,  String name, @JsonKey(name: 'image_url')  String? photoUrl,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _HadiSummaryModel() when $default != null:
return $default(_that.id,_that.name,_that.photoUrl,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HadiSummaryModel extends HadiSummaryModel {
  const _HadiSummaryModel({@JsonKey(fromJson: _idToString) required this.id, required this.name, @JsonKey(name: 'image_url') this.photoUrl, this.description}): super._();
  factory _HadiSummaryModel.fromJson(Map<String, dynamic> json) => _$HadiSummaryModelFromJson(json);

@override@JsonKey(fromJson: _idToString) final  String id;
@override final  String name;
@override@JsonKey(name: 'image_url') final  String? photoUrl;
@override final  String? description;

/// Create a copy of HadiSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HadiSummaryModelCopyWith<_HadiSummaryModel> get copyWith => __$HadiSummaryModelCopyWithImpl<_HadiSummaryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HadiSummaryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HadiSummaryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,photoUrl,description);

@override
String toString() {
  return 'HadiSummaryModel(id: $id, name: $name, photoUrl: $photoUrl, description: $description)';
}


}

/// @nodoc
abstract mixin class _$HadiSummaryModelCopyWith<$Res> implements $HadiSummaryModelCopyWith<$Res> {
  factory _$HadiSummaryModelCopyWith(_HadiSummaryModel value, $Res Function(_HadiSummaryModel) _then) = __$HadiSummaryModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _idToString) String id, String name,@JsonKey(name: 'image_url') String? photoUrl, String? description
});




}
/// @nodoc
class __$HadiSummaryModelCopyWithImpl<$Res>
    implements _$HadiSummaryModelCopyWith<$Res> {
  __$HadiSummaryModelCopyWithImpl(this._self, this._then);

  final _HadiSummaryModel _self;
  final $Res Function(_HadiSummaryModel) _then;

/// Create a copy of HadiSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? photoUrl = freezed,Object? description = freezed,}) {
  return _then(_HadiSummaryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
