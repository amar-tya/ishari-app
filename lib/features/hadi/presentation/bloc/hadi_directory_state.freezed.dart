// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hadi_directory_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HadiDirectoryState {

 HadiDirectoryStatus get status; List<HadiSummaryEntity> get hadiList; List<HadiAudioEntity> get audioList; String get searchQuery; int? get playingAudioId; bool get isAudioLoading; String? get errorMessage;// Bumped on every fetch completion so RefreshIndicator's stream.firstWhere
// can detect "done" even when the refreshed data is value-equal to the
// previous state (freezed equality would otherwise never emit a change).
 int get refreshTick;
/// Create a copy of HadiDirectoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HadiDirectoryStateCopyWith<HadiDirectoryState> get copyWith => _$HadiDirectoryStateCopyWithImpl<HadiDirectoryState>(this as HadiDirectoryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HadiDirectoryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.hadiList, hadiList)&&const DeepCollectionEquality().equals(other.audioList, audioList)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.playingAudioId, playingAudioId) || other.playingAudioId == playingAudioId)&&(identical(other.isAudioLoading, isAudioLoading) || other.isAudioLoading == isAudioLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.refreshTick, refreshTick) || other.refreshTick == refreshTick));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(hadiList),const DeepCollectionEquality().hash(audioList),searchQuery,playingAudioId,isAudioLoading,errorMessage,refreshTick);

@override
String toString() {
  return 'HadiDirectoryState(status: $status, hadiList: $hadiList, audioList: $audioList, searchQuery: $searchQuery, playingAudioId: $playingAudioId, isAudioLoading: $isAudioLoading, errorMessage: $errorMessage, refreshTick: $refreshTick)';
}


}

/// @nodoc
abstract mixin class $HadiDirectoryStateCopyWith<$Res>  {
  factory $HadiDirectoryStateCopyWith(HadiDirectoryState value, $Res Function(HadiDirectoryState) _then) = _$HadiDirectoryStateCopyWithImpl;
@useResult
$Res call({
 HadiDirectoryStatus status, List<HadiSummaryEntity> hadiList, List<HadiAudioEntity> audioList, String searchQuery, int? playingAudioId, bool isAudioLoading, String? errorMessage, int refreshTick
});




}
/// @nodoc
class _$HadiDirectoryStateCopyWithImpl<$Res>
    implements $HadiDirectoryStateCopyWith<$Res> {
  _$HadiDirectoryStateCopyWithImpl(this._self, this._then);

  final HadiDirectoryState _self;
  final $Res Function(HadiDirectoryState) _then;

/// Create a copy of HadiDirectoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? hadiList = null,Object? audioList = null,Object? searchQuery = null,Object? playingAudioId = freezed,Object? isAudioLoading = null,Object? errorMessage = freezed,Object? refreshTick = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HadiDirectoryStatus,hadiList: null == hadiList ? _self.hadiList : hadiList // ignore: cast_nullable_to_non_nullable
as List<HadiSummaryEntity>,audioList: null == audioList ? _self.audioList : audioList // ignore: cast_nullable_to_non_nullable
as List<HadiAudioEntity>,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,playingAudioId: freezed == playingAudioId ? _self.playingAudioId : playingAudioId // ignore: cast_nullable_to_non_nullable
as int?,isAudioLoading: null == isAudioLoading ? _self.isAudioLoading : isAudioLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,refreshTick: null == refreshTick ? _self.refreshTick : refreshTick // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [HadiDirectoryState].
extension HadiDirectoryStatePatterns on HadiDirectoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HadiDirectoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HadiDirectoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HadiDirectoryState value)  $default,){
final _that = this;
switch (_that) {
case _HadiDirectoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HadiDirectoryState value)?  $default,){
final _that = this;
switch (_that) {
case _HadiDirectoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( HadiDirectoryStatus status,  List<HadiSummaryEntity> hadiList,  List<HadiAudioEntity> audioList,  String searchQuery,  int? playingAudioId,  bool isAudioLoading,  String? errorMessage,  int refreshTick)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HadiDirectoryState() when $default != null:
return $default(_that.status,_that.hadiList,_that.audioList,_that.searchQuery,_that.playingAudioId,_that.isAudioLoading,_that.errorMessage,_that.refreshTick);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( HadiDirectoryStatus status,  List<HadiSummaryEntity> hadiList,  List<HadiAudioEntity> audioList,  String searchQuery,  int? playingAudioId,  bool isAudioLoading,  String? errorMessage,  int refreshTick)  $default,) {final _that = this;
switch (_that) {
case _HadiDirectoryState():
return $default(_that.status,_that.hadiList,_that.audioList,_that.searchQuery,_that.playingAudioId,_that.isAudioLoading,_that.errorMessage,_that.refreshTick);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( HadiDirectoryStatus status,  List<HadiSummaryEntity> hadiList,  List<HadiAudioEntity> audioList,  String searchQuery,  int? playingAudioId,  bool isAudioLoading,  String? errorMessage,  int refreshTick)?  $default,) {final _that = this;
switch (_that) {
case _HadiDirectoryState() when $default != null:
return $default(_that.status,_that.hadiList,_that.audioList,_that.searchQuery,_that.playingAudioId,_that.isAudioLoading,_that.errorMessage,_that.refreshTick);case _:
  return null;

}
}

}

/// @nodoc


class _HadiDirectoryState extends HadiDirectoryState {
  const _HadiDirectoryState({this.status = HadiDirectoryStatus.initial, final  List<HadiSummaryEntity> hadiList = const <HadiSummaryEntity>[], final  List<HadiAudioEntity> audioList = const <HadiAudioEntity>[], this.searchQuery = '', this.playingAudioId, this.isAudioLoading = false, this.errorMessage, this.refreshTick = 0}): _hadiList = hadiList,_audioList = audioList,super._();
  

@override@JsonKey() final  HadiDirectoryStatus status;
 final  List<HadiSummaryEntity> _hadiList;
@override@JsonKey() List<HadiSummaryEntity> get hadiList {
  if (_hadiList is EqualUnmodifiableListView) return _hadiList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hadiList);
}

 final  List<HadiAudioEntity> _audioList;
@override@JsonKey() List<HadiAudioEntity> get audioList {
  if (_audioList is EqualUnmodifiableListView) return _audioList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_audioList);
}

@override@JsonKey() final  String searchQuery;
@override final  int? playingAudioId;
@override@JsonKey() final  bool isAudioLoading;
@override final  String? errorMessage;
// Bumped on every fetch completion so RefreshIndicator's stream.firstWhere
// can detect "done" even when the refreshed data is value-equal to the
// previous state (freezed equality would otherwise never emit a change).
@override@JsonKey() final  int refreshTick;

/// Create a copy of HadiDirectoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HadiDirectoryStateCopyWith<_HadiDirectoryState> get copyWith => __$HadiDirectoryStateCopyWithImpl<_HadiDirectoryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HadiDirectoryState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._hadiList, _hadiList)&&const DeepCollectionEquality().equals(other._audioList, _audioList)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.playingAudioId, playingAudioId) || other.playingAudioId == playingAudioId)&&(identical(other.isAudioLoading, isAudioLoading) || other.isAudioLoading == isAudioLoading)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.refreshTick, refreshTick) || other.refreshTick == refreshTick));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_hadiList),const DeepCollectionEquality().hash(_audioList),searchQuery,playingAudioId,isAudioLoading,errorMessage,refreshTick);

@override
String toString() {
  return 'HadiDirectoryState(status: $status, hadiList: $hadiList, audioList: $audioList, searchQuery: $searchQuery, playingAudioId: $playingAudioId, isAudioLoading: $isAudioLoading, errorMessage: $errorMessage, refreshTick: $refreshTick)';
}


}

/// @nodoc
abstract mixin class _$HadiDirectoryStateCopyWith<$Res> implements $HadiDirectoryStateCopyWith<$Res> {
  factory _$HadiDirectoryStateCopyWith(_HadiDirectoryState value, $Res Function(_HadiDirectoryState) _then) = __$HadiDirectoryStateCopyWithImpl;
@override @useResult
$Res call({
 HadiDirectoryStatus status, List<HadiSummaryEntity> hadiList, List<HadiAudioEntity> audioList, String searchQuery, int? playingAudioId, bool isAudioLoading, String? errorMessage, int refreshTick
});




}
/// @nodoc
class __$HadiDirectoryStateCopyWithImpl<$Res>
    implements _$HadiDirectoryStateCopyWith<$Res> {
  __$HadiDirectoryStateCopyWithImpl(this._self, this._then);

  final _HadiDirectoryState _self;
  final $Res Function(_HadiDirectoryState) _then;

/// Create a copy of HadiDirectoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? hadiList = null,Object? audioList = null,Object? searchQuery = null,Object? playingAudioId = freezed,Object? isAudioLoading = null,Object? errorMessage = freezed,Object? refreshTick = null,}) {
  return _then(_HadiDirectoryState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as HadiDirectoryStatus,hadiList: null == hadiList ? _self._hadiList : hadiList // ignore: cast_nullable_to_non_nullable
as List<HadiSummaryEntity>,audioList: null == audioList ? _self._audioList : audioList // ignore: cast_nullable_to_non_nullable
as List<HadiAudioEntity>,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,playingAudioId: freezed == playingAudioId ? _self.playingAudioId : playingAudioId // ignore: cast_nullable_to_non_nullable
as int?,isAudioLoading: null == isAudioLoading ? _self.isAudioLoading : isAudioLoading // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,refreshTick: null == refreshTick ? _self.refreshTick : refreshTick // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
