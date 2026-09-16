// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hadi_directory_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HadiDirectoryEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HadiDirectoryEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HadiDirectoryEvent()';
}


}

/// @nodoc
class $HadiDirectoryEventCopyWith<$Res>  {
$HadiDirectoryEventCopyWith(HadiDirectoryEvent _, $Res Function(HadiDirectoryEvent) __);
}


/// Adds pattern-matching-related methods to [HadiDirectoryEvent].
extension HadiDirectoryEventPatterns on HadiDirectoryEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _LoadAll value)?  loadAll,TResult Function( _SearchChanged value)?  searchChanged,TResult Function( _PlayTrack value)?  playTrack,TResult Function( _StopAudio value)?  stopAudio,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoadAll() when loadAll != null:
return loadAll(_that);case _SearchChanged() when searchChanged != null:
return searchChanged(_that);case _PlayTrack() when playTrack != null:
return playTrack(_that);case _StopAudio() when stopAudio != null:
return stopAudio(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _LoadAll value)  loadAll,required TResult Function( _SearchChanged value)  searchChanged,required TResult Function( _PlayTrack value)  playTrack,required TResult Function( _StopAudio value)  stopAudio,}){
final _that = this;
switch (_that) {
case _LoadAll():
return loadAll(_that);case _SearchChanged():
return searchChanged(_that);case _PlayTrack():
return playTrack(_that);case _StopAudio():
return stopAudio(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _LoadAll value)?  loadAll,TResult? Function( _SearchChanged value)?  searchChanged,TResult? Function( _PlayTrack value)?  playTrack,TResult? Function( _StopAudio value)?  stopAudio,}){
final _that = this;
switch (_that) {
case _LoadAll() when loadAll != null:
return loadAll(_that);case _SearchChanged() when searchChanged != null:
return searchChanged(_that);case _PlayTrack() when playTrack != null:
return playTrack(_that);case _StopAudio() when stopAudio != null:
return stopAudio(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( bool forceRefresh)?  loadAll,TResult Function( String query)?  searchChanged,TResult Function( int audioId)?  playTrack,TResult Function()?  stopAudio,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoadAll() when loadAll != null:
return loadAll(_that.forceRefresh);case _SearchChanged() when searchChanged != null:
return searchChanged(_that.query);case _PlayTrack() when playTrack != null:
return playTrack(_that.audioId);case _StopAudio() when stopAudio != null:
return stopAudio();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( bool forceRefresh)  loadAll,required TResult Function( String query)  searchChanged,required TResult Function( int audioId)  playTrack,required TResult Function()  stopAudio,}) {final _that = this;
switch (_that) {
case _LoadAll():
return loadAll(_that.forceRefresh);case _SearchChanged():
return searchChanged(_that.query);case _PlayTrack():
return playTrack(_that.audioId);case _StopAudio():
return stopAudio();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( bool forceRefresh)?  loadAll,TResult? Function( String query)?  searchChanged,TResult? Function( int audioId)?  playTrack,TResult? Function()?  stopAudio,}) {final _that = this;
switch (_that) {
case _LoadAll() when loadAll != null:
return loadAll(_that.forceRefresh);case _SearchChanged() when searchChanged != null:
return searchChanged(_that.query);case _PlayTrack() when playTrack != null:
return playTrack(_that.audioId);case _StopAudio() when stopAudio != null:
return stopAudio();case _:
  return null;

}
}

}

/// @nodoc


class _LoadAll implements HadiDirectoryEvent {
  const _LoadAll({this.forceRefresh = false});
  

@JsonKey() final  bool forceRefresh;

/// Create a copy of HadiDirectoryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadAllCopyWith<_LoadAll> get copyWith => __$LoadAllCopyWithImpl<_LoadAll>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadAll&&(identical(other.forceRefresh, forceRefresh) || other.forceRefresh == forceRefresh));
}


@override
int get hashCode => Object.hash(runtimeType,forceRefresh);

@override
String toString() {
  return 'HadiDirectoryEvent.loadAll(forceRefresh: $forceRefresh)';
}


}

/// @nodoc
abstract mixin class _$LoadAllCopyWith<$Res> implements $HadiDirectoryEventCopyWith<$Res> {
  factory _$LoadAllCopyWith(_LoadAll value, $Res Function(_LoadAll) _then) = __$LoadAllCopyWithImpl;
@useResult
$Res call({
 bool forceRefresh
});




}
/// @nodoc
class __$LoadAllCopyWithImpl<$Res>
    implements _$LoadAllCopyWith<$Res> {
  __$LoadAllCopyWithImpl(this._self, this._then);

  final _LoadAll _self;
  final $Res Function(_LoadAll) _then;

/// Create a copy of HadiDirectoryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? forceRefresh = null,}) {
  return _then(_LoadAll(
forceRefresh: null == forceRefresh ? _self.forceRefresh : forceRefresh // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _SearchChanged implements HadiDirectoryEvent {
  const _SearchChanged(this.query);
  

 final  String query;

/// Create a copy of HadiDirectoryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchChangedCopyWith<_SearchChanged> get copyWith => __$SearchChangedCopyWithImpl<_SearchChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchChanged&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'HadiDirectoryEvent.searchChanged(query: $query)';
}


}

/// @nodoc
abstract mixin class _$SearchChangedCopyWith<$Res> implements $HadiDirectoryEventCopyWith<$Res> {
  factory _$SearchChangedCopyWith(_SearchChanged value, $Res Function(_SearchChanged) _then) = __$SearchChangedCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class __$SearchChangedCopyWithImpl<$Res>
    implements _$SearchChangedCopyWith<$Res> {
  __$SearchChangedCopyWithImpl(this._self, this._then);

  final _SearchChanged _self;
  final $Res Function(_SearchChanged) _then;

/// Create a copy of HadiDirectoryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(_SearchChanged(
null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _PlayTrack implements HadiDirectoryEvent {
  const _PlayTrack(this.audioId);
  

 final  int audioId;

/// Create a copy of HadiDirectoryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayTrackCopyWith<_PlayTrack> get copyWith => __$PlayTrackCopyWithImpl<_PlayTrack>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayTrack&&(identical(other.audioId, audioId) || other.audioId == audioId));
}


@override
int get hashCode => Object.hash(runtimeType,audioId);

@override
String toString() {
  return 'HadiDirectoryEvent.playTrack(audioId: $audioId)';
}


}

/// @nodoc
abstract mixin class _$PlayTrackCopyWith<$Res> implements $HadiDirectoryEventCopyWith<$Res> {
  factory _$PlayTrackCopyWith(_PlayTrack value, $Res Function(_PlayTrack) _then) = __$PlayTrackCopyWithImpl;
@useResult
$Res call({
 int audioId
});




}
/// @nodoc
class __$PlayTrackCopyWithImpl<$Res>
    implements _$PlayTrackCopyWith<$Res> {
  __$PlayTrackCopyWithImpl(this._self, this._then);

  final _PlayTrack _self;
  final $Res Function(_PlayTrack) _then;

/// Create a copy of HadiDirectoryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? audioId = null,}) {
  return _then(_PlayTrack(
null == audioId ? _self.audioId : audioId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _StopAudio implements HadiDirectoryEvent {
  const _StopAudio();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StopAudio);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HadiDirectoryEvent.stopAudio()';
}


}




// dart format on
