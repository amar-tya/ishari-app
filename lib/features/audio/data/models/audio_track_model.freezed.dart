// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_track_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AudioTrackModel {

 String get id; String get title; String get mediaUrl; DateTime get createdAt; String? get hadiName; String? get rodadCabang; int? get duration; String? get description;
/// Create a copy of AudioTrackModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioTrackModelCopyWith<AudioTrackModel> get copyWith => _$AudioTrackModelCopyWithImpl<AudioTrackModel>(this as AudioTrackModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioTrackModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.hadiName, hadiName) || other.hadiName == hadiName)&&(identical(other.rodadCabang, rodadCabang) || other.rodadCabang == rodadCabang)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,mediaUrl,createdAt,hadiName,rodadCabang,duration,description);

@override
String toString() {
  return 'AudioTrackModel(id: $id, title: $title, mediaUrl: $mediaUrl, createdAt: $createdAt, hadiName: $hadiName, rodadCabang: $rodadCabang, duration: $duration, description: $description)';
}


}

/// @nodoc
abstract mixin class $AudioTrackModelCopyWith<$Res>  {
  factory $AudioTrackModelCopyWith(AudioTrackModel value, $Res Function(AudioTrackModel) _then) = _$AudioTrackModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String mediaUrl, DateTime createdAt, String? hadiName, String? rodadCabang, int? duration, String? description
});




}
/// @nodoc
class _$AudioTrackModelCopyWithImpl<$Res>
    implements $AudioTrackModelCopyWith<$Res> {
  _$AudioTrackModelCopyWithImpl(this._self, this._then);

  final AudioTrackModel _self;
  final $Res Function(AudioTrackModel) _then;

/// Create a copy of AudioTrackModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? mediaUrl = null,Object? createdAt = null,Object? hadiName = freezed,Object? rodadCabang = freezed,Object? duration = freezed,Object? description = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,mediaUrl: null == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,hadiName: freezed == hadiName ? _self.hadiName : hadiName // ignore: cast_nullable_to_non_nullable
as String?,rodadCabang: freezed == rodadCabang ? _self.rodadCabang : rodadCabang // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AudioTrackModel].
extension AudioTrackModelPatterns on AudioTrackModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AudioTrackModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AudioTrackModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AudioTrackModel value)  $default,){
final _that = this;
switch (_that) {
case _AudioTrackModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AudioTrackModel value)?  $default,){
final _that = this;
switch (_that) {
case _AudioTrackModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String mediaUrl,  DateTime createdAt,  String? hadiName,  String? rodadCabang,  int? duration,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AudioTrackModel() when $default != null:
return $default(_that.id,_that.title,_that.mediaUrl,_that.createdAt,_that.hadiName,_that.rodadCabang,_that.duration,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String mediaUrl,  DateTime createdAt,  String? hadiName,  String? rodadCabang,  int? duration,  String? description)  $default,) {final _that = this;
switch (_that) {
case _AudioTrackModel():
return $default(_that.id,_that.title,_that.mediaUrl,_that.createdAt,_that.hadiName,_that.rodadCabang,_that.duration,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String mediaUrl,  DateTime createdAt,  String? hadiName,  String? rodadCabang,  int? duration,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _AudioTrackModel() when $default != null:
return $default(_that.id,_that.title,_that.mediaUrl,_that.createdAt,_that.hadiName,_that.rodadCabang,_that.duration,_that.description);case _:
  return null;

}
}

}

/// @nodoc


class _AudioTrackModel extends AudioTrackModel {
  const _AudioTrackModel({required this.id, required this.title, required this.mediaUrl, required this.createdAt, this.hadiName, this.rodadCabang, this.duration, this.description}): super._();
  

@override final  String id;
@override final  String title;
@override final  String mediaUrl;
@override final  DateTime createdAt;
@override final  String? hadiName;
@override final  String? rodadCabang;
@override final  int? duration;
@override final  String? description;

/// Create a copy of AudioTrackModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudioTrackModelCopyWith<_AudioTrackModel> get copyWith => __$AudioTrackModelCopyWithImpl<_AudioTrackModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioTrackModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.hadiName, hadiName) || other.hadiName == hadiName)&&(identical(other.rodadCabang, rodadCabang) || other.rodadCabang == rodadCabang)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,mediaUrl,createdAt,hadiName,rodadCabang,duration,description);

@override
String toString() {
  return 'AudioTrackModel(id: $id, title: $title, mediaUrl: $mediaUrl, createdAt: $createdAt, hadiName: $hadiName, rodadCabang: $rodadCabang, duration: $duration, description: $description)';
}


}

/// @nodoc
abstract mixin class _$AudioTrackModelCopyWith<$Res> implements $AudioTrackModelCopyWith<$Res> {
  factory _$AudioTrackModelCopyWith(_AudioTrackModel value, $Res Function(_AudioTrackModel) _then) = __$AudioTrackModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String mediaUrl, DateTime createdAt, String? hadiName, String? rodadCabang, int? duration, String? description
});




}
/// @nodoc
class __$AudioTrackModelCopyWithImpl<$Res>
    implements _$AudioTrackModelCopyWith<$Res> {
  __$AudioTrackModelCopyWithImpl(this._self, this._then);

  final _AudioTrackModel _self;
  final $Res Function(_AudioTrackModel) _then;

/// Create a copy of AudioTrackModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? mediaUrl = null,Object? createdAt = null,Object? hadiName = freezed,Object? rodadCabang = freezed,Object? duration = freezed,Object? description = freezed,}) {
  return _then(_AudioTrackModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,mediaUrl: null == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,hadiName: freezed == hadiName ? _self.hadiName : hadiName // ignore: cast_nullable_to_non_nullable
as String?,rodadCabang: freezed == rodadCabang ? _self.rodadCabang : rodadCabang // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
