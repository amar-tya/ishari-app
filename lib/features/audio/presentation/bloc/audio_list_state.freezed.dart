// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AudioListState {

 AudioListStatus get status; List<AudioTrackEntity> get tracks; String get query; Map<AudioCategory, Set<String>> get appliedSelected; Map<AudioCategory, Set<String>> get draftSelected; AudioSort get sort;// Id of the loaded/current track — stays set while paused, only clears
// on stop/completion/losing ownership to muhudVerse.
 String? get playingId; bool get isAudioLoading;// Actually producing sound right now — distinct from `playingId != null`
// (loaded), since a loaded track can be paused.
 bool get isPlaying; Duration get position; Duration? get duration; String? get errorMessage;// Bumped on every fetch completion so RefreshIndicator's stream.firstWhere
// can detect "done" even when the refreshed data is value-equal to the
// previous state (freezed equality would otherwise never emit a change).
 int get refreshTick;
/// Create a copy of AudioListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioListStateCopyWith<AudioListState> get copyWith => _$AudioListStateCopyWithImpl<AudioListState>(this as AudioListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioListState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.tracks, tracks)&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other.appliedSelected, appliedSelected)&&const DeepCollectionEquality().equals(other.draftSelected, draftSelected)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.playingId, playingId) || other.playingId == playingId)&&(identical(other.isAudioLoading, isAudioLoading) || other.isAudioLoading == isAudioLoading)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.position, position) || other.position == position)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.refreshTick, refreshTick) || other.refreshTick == refreshTick));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(tracks),query,const DeepCollectionEquality().hash(appliedSelected),const DeepCollectionEquality().hash(draftSelected),sort,playingId,isAudioLoading,isPlaying,position,duration,errorMessage,refreshTick);

@override
String toString() {
  return 'AudioListState(status: $status, tracks: $tracks, query: $query, appliedSelected: $appliedSelected, draftSelected: $draftSelected, sort: $sort, playingId: $playingId, isAudioLoading: $isAudioLoading, isPlaying: $isPlaying, position: $position, duration: $duration, errorMessage: $errorMessage, refreshTick: $refreshTick)';
}


}

/// @nodoc
abstract mixin class $AudioListStateCopyWith<$Res>  {
  factory $AudioListStateCopyWith(AudioListState value, $Res Function(AudioListState) _then) = _$AudioListStateCopyWithImpl;
@useResult
$Res call({
 AudioListStatus status, List<AudioTrackEntity> tracks, String query, Map<AudioCategory, Set<String>> appliedSelected, Map<AudioCategory, Set<String>> draftSelected, AudioSort sort, String? playingId, bool isAudioLoading, bool isPlaying, Duration position, Duration? duration, String? errorMessage, int refreshTick
});




}
/// @nodoc
class _$AudioListStateCopyWithImpl<$Res>
    implements $AudioListStateCopyWith<$Res> {
  _$AudioListStateCopyWithImpl(this._self, this._then);

  final AudioListState _self;
  final $Res Function(AudioListState) _then;

/// Create a copy of AudioListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? tracks = null,Object? query = null,Object? appliedSelected = null,Object? draftSelected = null,Object? sort = null,Object? playingId = freezed,Object? isAudioLoading = null,Object? isPlaying = null,Object? position = null,Object? duration = freezed,Object? errorMessage = freezed,Object? refreshTick = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AudioListStatus,tracks: null == tracks ? _self.tracks : tracks // ignore: cast_nullable_to_non_nullable
as List<AudioTrackEntity>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,appliedSelected: null == appliedSelected ? _self.appliedSelected : appliedSelected // ignore: cast_nullable_to_non_nullable
as Map<AudioCategory, Set<String>>,draftSelected: null == draftSelected ? _self.draftSelected : draftSelected // ignore: cast_nullable_to_non_nullable
as Map<AudioCategory, Set<String>>,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as AudioSort,playingId: freezed == playingId ? _self.playingId : playingId // ignore: cast_nullable_to_non_nullable
as String?,isAudioLoading: null == isAudioLoading ? _self.isAudioLoading : isAudioLoading // ignore: cast_nullable_to_non_nullable
as bool,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,refreshTick: null == refreshTick ? _self.refreshTick : refreshTick // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AudioListState].
extension AudioListStatePatterns on AudioListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AudioListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AudioListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AudioListState value)  $default,){
final _that = this;
switch (_that) {
case _AudioListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AudioListState value)?  $default,){
final _that = this;
switch (_that) {
case _AudioListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AudioListStatus status,  List<AudioTrackEntity> tracks,  String query,  Map<AudioCategory, Set<String>> appliedSelected,  Map<AudioCategory, Set<String>> draftSelected,  AudioSort sort,  String? playingId,  bool isAudioLoading,  bool isPlaying,  Duration position,  Duration? duration,  String? errorMessage,  int refreshTick)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AudioListState() when $default != null:
return $default(_that.status,_that.tracks,_that.query,_that.appliedSelected,_that.draftSelected,_that.sort,_that.playingId,_that.isAudioLoading,_that.isPlaying,_that.position,_that.duration,_that.errorMessage,_that.refreshTick);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AudioListStatus status,  List<AudioTrackEntity> tracks,  String query,  Map<AudioCategory, Set<String>> appliedSelected,  Map<AudioCategory, Set<String>> draftSelected,  AudioSort sort,  String? playingId,  bool isAudioLoading,  bool isPlaying,  Duration position,  Duration? duration,  String? errorMessage,  int refreshTick)  $default,) {final _that = this;
switch (_that) {
case _AudioListState():
return $default(_that.status,_that.tracks,_that.query,_that.appliedSelected,_that.draftSelected,_that.sort,_that.playingId,_that.isAudioLoading,_that.isPlaying,_that.position,_that.duration,_that.errorMessage,_that.refreshTick);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AudioListStatus status,  List<AudioTrackEntity> tracks,  String query,  Map<AudioCategory, Set<String>> appliedSelected,  Map<AudioCategory, Set<String>> draftSelected,  AudioSort sort,  String? playingId,  bool isAudioLoading,  bool isPlaying,  Duration position,  Duration? duration,  String? errorMessage,  int refreshTick)?  $default,) {final _that = this;
switch (_that) {
case _AudioListState() when $default != null:
return $default(_that.status,_that.tracks,_that.query,_that.appliedSelected,_that.draftSelected,_that.sort,_that.playingId,_that.isAudioLoading,_that.isPlaying,_that.position,_that.duration,_that.errorMessage,_that.refreshTick);case _:
  return null;

}
}

}

/// @nodoc


class _AudioListState extends AudioListState {
  const _AudioListState({this.status = AudioListStatus.initial, final  List<AudioTrackEntity> tracks = const <AudioTrackEntity>[], this.query = '', final  Map<AudioCategory, Set<String>> appliedSelected = const <AudioCategory, Set<String>>{}, final  Map<AudioCategory, Set<String>> draftSelected = const <AudioCategory, Set<String>>{}, this.sort = AudioSort.terbaru, this.playingId, this.isAudioLoading = false, this.isPlaying = false, this.position = Duration.zero, this.duration, this.errorMessage, this.refreshTick = 0}): _tracks = tracks,_appliedSelected = appliedSelected,_draftSelected = draftSelected,super._();
  

@override@JsonKey() final  AudioListStatus status;
 final  List<AudioTrackEntity> _tracks;
@override@JsonKey() List<AudioTrackEntity> get tracks {
  if (_tracks is EqualUnmodifiableListView) return _tracks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tracks);
}

@override@JsonKey() final  String query;
 final  Map<AudioCategory, Set<String>> _appliedSelected;
@override@JsonKey() Map<AudioCategory, Set<String>> get appliedSelected {
  if (_appliedSelected is EqualUnmodifiableMapView) return _appliedSelected;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_appliedSelected);
}

 final  Map<AudioCategory, Set<String>> _draftSelected;
@override@JsonKey() Map<AudioCategory, Set<String>> get draftSelected {
  if (_draftSelected is EqualUnmodifiableMapView) return _draftSelected;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_draftSelected);
}

@override@JsonKey() final  AudioSort sort;
// Id of the loaded/current track — stays set while paused, only clears
// on stop/completion/losing ownership to muhudVerse.
@override final  String? playingId;
@override@JsonKey() final  bool isAudioLoading;
// Actually producing sound right now — distinct from `playingId != null`
// (loaded), since a loaded track can be paused.
@override@JsonKey() final  bool isPlaying;
@override@JsonKey() final  Duration position;
@override final  Duration? duration;
@override final  String? errorMessage;
// Bumped on every fetch completion so RefreshIndicator's stream.firstWhere
// can detect "done" even when the refreshed data is value-equal to the
// previous state (freezed equality would otherwise never emit a change).
@override@JsonKey() final  int refreshTick;

/// Create a copy of AudioListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudioListStateCopyWith<_AudioListState> get copyWith => __$AudioListStateCopyWithImpl<_AudioListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioListState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._tracks, _tracks)&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other._appliedSelected, _appliedSelected)&&const DeepCollectionEquality().equals(other._draftSelected, _draftSelected)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.playingId, playingId) || other.playingId == playingId)&&(identical(other.isAudioLoading, isAudioLoading) || other.isAudioLoading == isAudioLoading)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.position, position) || other.position == position)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.refreshTick, refreshTick) || other.refreshTick == refreshTick));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_tracks),query,const DeepCollectionEquality().hash(_appliedSelected),const DeepCollectionEquality().hash(_draftSelected),sort,playingId,isAudioLoading,isPlaying,position,duration,errorMessage,refreshTick);

@override
String toString() {
  return 'AudioListState(status: $status, tracks: $tracks, query: $query, appliedSelected: $appliedSelected, draftSelected: $draftSelected, sort: $sort, playingId: $playingId, isAudioLoading: $isAudioLoading, isPlaying: $isPlaying, position: $position, duration: $duration, errorMessage: $errorMessage, refreshTick: $refreshTick)';
}


}

/// @nodoc
abstract mixin class _$AudioListStateCopyWith<$Res> implements $AudioListStateCopyWith<$Res> {
  factory _$AudioListStateCopyWith(_AudioListState value, $Res Function(_AudioListState) _then) = __$AudioListStateCopyWithImpl;
@override @useResult
$Res call({
 AudioListStatus status, List<AudioTrackEntity> tracks, String query, Map<AudioCategory, Set<String>> appliedSelected, Map<AudioCategory, Set<String>> draftSelected, AudioSort sort, String? playingId, bool isAudioLoading, bool isPlaying, Duration position, Duration? duration, String? errorMessage, int refreshTick
});




}
/// @nodoc
class __$AudioListStateCopyWithImpl<$Res>
    implements _$AudioListStateCopyWith<$Res> {
  __$AudioListStateCopyWithImpl(this._self, this._then);

  final _AudioListState _self;
  final $Res Function(_AudioListState) _then;

/// Create a copy of AudioListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? tracks = null,Object? query = null,Object? appliedSelected = null,Object? draftSelected = null,Object? sort = null,Object? playingId = freezed,Object? isAudioLoading = null,Object? isPlaying = null,Object? position = null,Object? duration = freezed,Object? errorMessage = freezed,Object? refreshTick = null,}) {
  return _then(_AudioListState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AudioListStatus,tracks: null == tracks ? _self._tracks : tracks // ignore: cast_nullable_to_non_nullable
as List<AudioTrackEntity>,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,appliedSelected: null == appliedSelected ? _self._appliedSelected : appliedSelected // ignore: cast_nullable_to_non_nullable
as Map<AudioCategory, Set<String>>,draftSelected: null == draftSelected ? _self._draftSelected : draftSelected // ignore: cast_nullable_to_non_nullable
as Map<AudioCategory, Set<String>>,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as AudioSort,playingId: freezed == playingId ? _self.playingId : playingId // ignore: cast_nullable_to_non_nullable
as String?,isAudioLoading: null == isAudioLoading ? _self.isAudioLoading : isAudioLoading // ignore: cast_nullable_to_non_nullable
as bool,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,refreshTick: null == refreshTick ? _self.refreshTick : refreshTick // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
