// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_version_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppVersionEntity {

 String get minVersion; String get latestVersion; String get storeUrl; String get releaseNotes;
/// Create a copy of AppVersionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppVersionEntityCopyWith<AppVersionEntity> get copyWith => _$AppVersionEntityCopyWithImpl<AppVersionEntity>(this as AppVersionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppVersionEntity&&(identical(other.minVersion, minVersion) || other.minVersion == minVersion)&&(identical(other.latestVersion, latestVersion) || other.latestVersion == latestVersion)&&(identical(other.storeUrl, storeUrl) || other.storeUrl == storeUrl)&&(identical(other.releaseNotes, releaseNotes) || other.releaseNotes == releaseNotes));
}


@override
int get hashCode => Object.hash(runtimeType,minVersion,latestVersion,storeUrl,releaseNotes);

@override
String toString() {
  return 'AppVersionEntity(minVersion: $minVersion, latestVersion: $latestVersion, storeUrl: $storeUrl, releaseNotes: $releaseNotes)';
}


}

/// @nodoc
abstract mixin class $AppVersionEntityCopyWith<$Res>  {
  factory $AppVersionEntityCopyWith(AppVersionEntity value, $Res Function(AppVersionEntity) _then) = _$AppVersionEntityCopyWithImpl;
@useResult
$Res call({
 String minVersion, String latestVersion, String storeUrl, String releaseNotes
});




}
/// @nodoc
class _$AppVersionEntityCopyWithImpl<$Res>
    implements $AppVersionEntityCopyWith<$Res> {
  _$AppVersionEntityCopyWithImpl(this._self, this._then);

  final AppVersionEntity _self;
  final $Res Function(AppVersionEntity) _then;

/// Create a copy of AppVersionEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? minVersion = null,Object? latestVersion = null,Object? storeUrl = null,Object? releaseNotes = null,}) {
  return _then(_self.copyWith(
minVersion: null == minVersion ? _self.minVersion : minVersion // ignore: cast_nullable_to_non_nullable
as String,latestVersion: null == latestVersion ? _self.latestVersion : latestVersion // ignore: cast_nullable_to_non_nullable
as String,storeUrl: null == storeUrl ? _self.storeUrl : storeUrl // ignore: cast_nullable_to_non_nullable
as String,releaseNotes: null == releaseNotes ? _self.releaseNotes : releaseNotes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppVersionEntity].
extension AppVersionEntityPatterns on AppVersionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppVersionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppVersionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppVersionEntity value)  $default,){
final _that = this;
switch (_that) {
case _AppVersionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppVersionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AppVersionEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String minVersion,  String latestVersion,  String storeUrl,  String releaseNotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppVersionEntity() when $default != null:
return $default(_that.minVersion,_that.latestVersion,_that.storeUrl,_that.releaseNotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String minVersion,  String latestVersion,  String storeUrl,  String releaseNotes)  $default,) {final _that = this;
switch (_that) {
case _AppVersionEntity():
return $default(_that.minVersion,_that.latestVersion,_that.storeUrl,_that.releaseNotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String minVersion,  String latestVersion,  String storeUrl,  String releaseNotes)?  $default,) {final _that = this;
switch (_that) {
case _AppVersionEntity() when $default != null:
return $default(_that.minVersion,_that.latestVersion,_that.storeUrl,_that.releaseNotes);case _:
  return null;

}
}

}

/// @nodoc


class _AppVersionEntity implements AppVersionEntity {
  const _AppVersionEntity({required this.minVersion, required this.latestVersion, required this.storeUrl, required this.releaseNotes});
  

@override final  String minVersion;
@override final  String latestVersion;
@override final  String storeUrl;
@override final  String releaseNotes;

/// Create a copy of AppVersionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppVersionEntityCopyWith<_AppVersionEntity> get copyWith => __$AppVersionEntityCopyWithImpl<_AppVersionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppVersionEntity&&(identical(other.minVersion, minVersion) || other.minVersion == minVersion)&&(identical(other.latestVersion, latestVersion) || other.latestVersion == latestVersion)&&(identical(other.storeUrl, storeUrl) || other.storeUrl == storeUrl)&&(identical(other.releaseNotes, releaseNotes) || other.releaseNotes == releaseNotes));
}


@override
int get hashCode => Object.hash(runtimeType,minVersion,latestVersion,storeUrl,releaseNotes);

@override
String toString() {
  return 'AppVersionEntity(minVersion: $minVersion, latestVersion: $latestVersion, storeUrl: $storeUrl, releaseNotes: $releaseNotes)';
}


}

/// @nodoc
abstract mixin class _$AppVersionEntityCopyWith<$Res> implements $AppVersionEntityCopyWith<$Res> {
  factory _$AppVersionEntityCopyWith(_AppVersionEntity value, $Res Function(_AppVersionEntity) _then) = __$AppVersionEntityCopyWithImpl;
@override @useResult
$Res call({
 String minVersion, String latestVersion, String storeUrl, String releaseNotes
});




}
/// @nodoc
class __$AppVersionEntityCopyWithImpl<$Res>
    implements _$AppVersionEntityCopyWith<$Res> {
  __$AppVersionEntityCopyWithImpl(this._self, this._then);

  final _AppVersionEntity _self;
  final $Res Function(_AppVersionEntity) _then;

/// Create a copy of AppVersionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? minVersion = null,Object? latestVersion = null,Object? storeUrl = null,Object? releaseNotes = null,}) {
  return _then(_AppVersionEntity(
minVersion: null == minVersion ? _self.minVersion : minVersion // ignore: cast_nullable_to_non_nullable
as String,latestVersion: null == latestVersion ? _self.latestVersion : latestVersion // ignore: cast_nullable_to_non_nullable
as String,storeUrl: null == storeUrl ? _self.storeUrl : storeUrl // ignore: cast_nullable_to_non_nullable
as String,releaseNotes: null == releaseNotes ? _self.releaseNotes : releaseNotes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
