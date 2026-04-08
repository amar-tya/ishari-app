// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UpdateState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UpdateState()';
}


}

/// @nodoc
class $UpdateStateCopyWith<$Res>  {
$UpdateStateCopyWith(UpdateState _, $Res Function(UpdateState) __);
}


/// Adds pattern-matching-related methods to [UpdateState].
extension UpdateStatePatterns on UpdateState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Checking value)?  checking,TResult Function( _UpToDate value)?  upToDate,TResult Function( _SoftUpdate value)?  softUpdate,TResult Function( _ForceUpdate value)?  forceUpdate,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Checking() when checking != null:
return checking(_that);case _UpToDate() when upToDate != null:
return upToDate(_that);case _SoftUpdate() when softUpdate != null:
return softUpdate(_that);case _ForceUpdate() when forceUpdate != null:
return forceUpdate(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Checking value)  checking,required TResult Function( _UpToDate value)  upToDate,required TResult Function( _SoftUpdate value)  softUpdate,required TResult Function( _ForceUpdate value)  forceUpdate,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Checking():
return checking(_that);case _UpToDate():
return upToDate(_that);case _SoftUpdate():
return softUpdate(_that);case _ForceUpdate():
return forceUpdate(_that);case _Error():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Checking value)?  checking,TResult? Function( _UpToDate value)?  upToDate,TResult? Function( _SoftUpdate value)?  softUpdate,TResult? Function( _ForceUpdate value)?  forceUpdate,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Checking() when checking != null:
return checking(_that);case _UpToDate() when upToDate != null:
return upToDate(_that);case _SoftUpdate() when softUpdate != null:
return softUpdate(_that);case _ForceUpdate() when forceUpdate != null:
return forceUpdate(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  checking,TResult Function()?  upToDate,TResult Function( String latestVersion,  String storeUrl,  String releaseNotes)?  softUpdate,TResult Function( String storeUrl,  String releaseNotes)?  forceUpdate,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Checking() when checking != null:
return checking();case _UpToDate() when upToDate != null:
return upToDate();case _SoftUpdate() when softUpdate != null:
return softUpdate(_that.latestVersion,_that.storeUrl,_that.releaseNotes);case _ForceUpdate() when forceUpdate != null:
return forceUpdate(_that.storeUrl,_that.releaseNotes);case _Error() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  checking,required TResult Function()  upToDate,required TResult Function( String latestVersion,  String storeUrl,  String releaseNotes)  softUpdate,required TResult Function( String storeUrl,  String releaseNotes)  forceUpdate,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Checking():
return checking();case _UpToDate():
return upToDate();case _SoftUpdate():
return softUpdate(_that.latestVersion,_that.storeUrl,_that.releaseNotes);case _ForceUpdate():
return forceUpdate(_that.storeUrl,_that.releaseNotes);case _Error():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  checking,TResult? Function()?  upToDate,TResult? Function( String latestVersion,  String storeUrl,  String releaseNotes)?  softUpdate,TResult? Function( String storeUrl,  String releaseNotes)?  forceUpdate,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Checking() when checking != null:
return checking();case _UpToDate() when upToDate != null:
return upToDate();case _SoftUpdate() when softUpdate != null:
return softUpdate(_that.latestVersion,_that.storeUrl,_that.releaseNotes);case _ForceUpdate() when forceUpdate != null:
return forceUpdate(_that.storeUrl,_that.releaseNotes);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements UpdateState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UpdateState.initial()';
}


}




/// @nodoc


class _Checking implements UpdateState {
  const _Checking();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Checking);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UpdateState.checking()';
}


}




/// @nodoc


class _UpToDate implements UpdateState {
  const _UpToDate();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpToDate);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'UpdateState.upToDate()';
}


}




/// @nodoc


class _SoftUpdate implements UpdateState {
  const _SoftUpdate({required this.latestVersion, required this.storeUrl, required this.releaseNotes});
  

 final  String latestVersion;
 final  String storeUrl;
 final  String releaseNotes;

/// Create a copy of UpdateState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SoftUpdateCopyWith<_SoftUpdate> get copyWith => __$SoftUpdateCopyWithImpl<_SoftUpdate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SoftUpdate&&(identical(other.latestVersion, latestVersion) || other.latestVersion == latestVersion)&&(identical(other.storeUrl, storeUrl) || other.storeUrl == storeUrl)&&(identical(other.releaseNotes, releaseNotes) || other.releaseNotes == releaseNotes));
}


@override
int get hashCode => Object.hash(runtimeType,latestVersion,storeUrl,releaseNotes);

@override
String toString() {
  return 'UpdateState.softUpdate(latestVersion: $latestVersion, storeUrl: $storeUrl, releaseNotes: $releaseNotes)';
}


}

/// @nodoc
abstract mixin class _$SoftUpdateCopyWith<$Res> implements $UpdateStateCopyWith<$Res> {
  factory _$SoftUpdateCopyWith(_SoftUpdate value, $Res Function(_SoftUpdate) _then) = __$SoftUpdateCopyWithImpl;
@useResult
$Res call({
 String latestVersion, String storeUrl, String releaseNotes
});




}
/// @nodoc
class __$SoftUpdateCopyWithImpl<$Res>
    implements _$SoftUpdateCopyWith<$Res> {
  __$SoftUpdateCopyWithImpl(this._self, this._then);

  final _SoftUpdate _self;
  final $Res Function(_SoftUpdate) _then;

/// Create a copy of UpdateState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? latestVersion = null,Object? storeUrl = null,Object? releaseNotes = null,}) {
  return _then(_SoftUpdate(
latestVersion: null == latestVersion ? _self.latestVersion : latestVersion // ignore: cast_nullable_to_non_nullable
as String,storeUrl: null == storeUrl ? _self.storeUrl : storeUrl // ignore: cast_nullable_to_non_nullable
as String,releaseNotes: null == releaseNotes ? _self.releaseNotes : releaseNotes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ForceUpdate implements UpdateState {
  const _ForceUpdate({required this.storeUrl, required this.releaseNotes});
  

 final  String storeUrl;
 final  String releaseNotes;

/// Create a copy of UpdateState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForceUpdateCopyWith<_ForceUpdate> get copyWith => __$ForceUpdateCopyWithImpl<_ForceUpdate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForceUpdate&&(identical(other.storeUrl, storeUrl) || other.storeUrl == storeUrl)&&(identical(other.releaseNotes, releaseNotes) || other.releaseNotes == releaseNotes));
}


@override
int get hashCode => Object.hash(runtimeType,storeUrl,releaseNotes);

@override
String toString() {
  return 'UpdateState.forceUpdate(storeUrl: $storeUrl, releaseNotes: $releaseNotes)';
}


}

/// @nodoc
abstract mixin class _$ForceUpdateCopyWith<$Res> implements $UpdateStateCopyWith<$Res> {
  factory _$ForceUpdateCopyWith(_ForceUpdate value, $Res Function(_ForceUpdate) _then) = __$ForceUpdateCopyWithImpl;
@useResult
$Res call({
 String storeUrl, String releaseNotes
});




}
/// @nodoc
class __$ForceUpdateCopyWithImpl<$Res>
    implements _$ForceUpdateCopyWith<$Res> {
  __$ForceUpdateCopyWithImpl(this._self, this._then);

  final _ForceUpdate _self;
  final $Res Function(_ForceUpdate) _then;

/// Create a copy of UpdateState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? storeUrl = null,Object? releaseNotes = null,}) {
  return _then(_ForceUpdate(
storeUrl: null == storeUrl ? _self.storeUrl : storeUrl // ignore: cast_nullable_to_non_nullable
as String,releaseNotes: null == releaseNotes ? _self.releaseNotes : releaseNotes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Error implements UpdateState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of UpdateState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'UpdateState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $UpdateStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of UpdateState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
