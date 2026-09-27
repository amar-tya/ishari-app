// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_track_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AudioTrackEntity {

 String get id; String get title; String get mediaUrl; DateTime get createdAt; String? get hadiName; String? get rodadCabang; int? get duration; String? get description;
/// Create a copy of AudioTrackEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioTrackEntityCopyWith<AudioTrackEntity> get copyWith => _$AudioTrackEntityCopyWithImpl<AudioTrackEntity>(this as AudioTrackEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioTrackEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.hadiName, hadiName) || other.hadiName == hadiName)&&(identical(other.rodadCabang, rodadCabang) || other.rodadCabang == rodadCabang)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,mediaUrl,createdAt,hadiName,rodadCabang,duration,description);

@override
String toString() {
  return 'AudioTrackEntity(id: $id, title: $title, mediaUrl: $mediaUrl, createdAt: $createdAt, hadiName: $hadiName, rodadCabang: $rodadCabang, duration: $duration, description: $description)';
}


}

/// @nodoc
abstract mixin class $AudioTrackEntityCopyWith<$Res>  {
  factory $AudioTrackEntityCopyWith(AudioTrackEntity value, $Res Function(AudioTrackEntity) _then) = _$AudioTrackEntityCopyWithImpl;
@useResult
$Res call({
 String id, String title, String mediaUrl, DateTime createdAt, String? hadiName, String? rodadCabang, int? duration, String? description
});




}
/// @nodoc
class _$AudioTrackEntityCopyWithImpl<$Res>
    implements $AudioTrackEntityCopyWith<$Res> {
  _$AudioTrackEntityCopyWithImpl(this._self, this._then);

  final AudioTrackEntity _self;
  final $Res Function(AudioTrackEntity) _then;

/// Create a copy of AudioTrackEntity
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


/// Adds pattern-matching-related methods to [AudioTrackEntity].
extension AudioTrackEntityPatterns on AudioTrackEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AudioTrackEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AudioTrackEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AudioTrackEntity value)  $default,){
final _that = this;
switch (_that) {
case _AudioTrackEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AudioTrackEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AudioTrackEntity() when $default != null:
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
case _AudioTrackEntity() when $default != null:
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
case _AudioTrackEntity():
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
case _AudioTrackEntity() when $default != null:
return $default(_that.id,_that.title,_that.mediaUrl,_that.createdAt,_that.hadiName,_that.rodadCabang,_that.duration,_that.description);case _:
  return null;

}
}

}

/// @nodoc


class _AudioTrackEntity extends AudioTrackEntity {
  const _AudioTrackEntity({required this.id, required this.title, required this.mediaUrl, required this.createdAt, this.hadiName, this.rodadCabang, this.duration, this.description}): super._();
  

@override final  String id;
@override final  String title;
@override final  String mediaUrl;
@override final  DateTime createdAt;
@override final  String? hadiName;
@override final  String? rodadCabang;
@override final  int? duration;
@override final  String? description;

/// Create a copy of AudioTrackEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudioTrackEntityCopyWith<_AudioTrackEntity> get copyWith => __$AudioTrackEntityCopyWithImpl<_AudioTrackEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioTrackEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.hadiName, hadiName) || other.hadiName == hadiName)&&(identical(other.rodadCabang, rodadCabang) || other.rodadCabang == rodadCabang)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,mediaUrl,createdAt,hadiName,rodadCabang,duration,description);

@override
String toString() {
  return 'AudioTrackEntity(id: $id, title: $title, mediaUrl: $mediaUrl, createdAt: $createdAt, hadiName: $hadiName, rodadCabang: $rodadCabang, duration: $duration, description: $description)';
}


}

/// @nodoc
abstract mixin class _$AudioTrackEntityCopyWith<$Res> implements $AudioTrackEntityCopyWith<$Res> {
  factory _$AudioTrackEntityCopyWith(_AudioTrackEntity value, $Res Function(_AudioTrackEntity) _then) = __$AudioTrackEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String mediaUrl, DateTime createdAt, String? hadiName, String? rodadCabang, int? duration, String? description
});




}
/// @nodoc
class __$AudioTrackEntityCopyWithImpl<$Res>
    implements _$AudioTrackEntityCopyWith<$Res> {
  __$AudioTrackEntityCopyWithImpl(this._self, this._then);

  final _AudioTrackEntity _self;
  final $Res Function(_AudioTrackEntity) _then;

/// Create a copy of AudioTrackEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? mediaUrl = null,Object? createdAt = null,Object? hadiName = freezed,Object? rodadCabang = freezed,Object? duration = freezed,Object? description = freezed,}) {
  return _then(_AudioTrackEntity(
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
