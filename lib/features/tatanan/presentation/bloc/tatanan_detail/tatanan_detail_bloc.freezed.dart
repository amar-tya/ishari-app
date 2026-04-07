// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tatanan_detail_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TatananDetailEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TatananDetailEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TatananDetailEvent()';
}


}

/// @nodoc
class $TatananDetailEventCopyWith<$Res>  {
$TatananDetailEventCopyWith(TatananDetailEvent _, $Res Function(TatananDetailEvent) __);
}


/// Adds pattern-matching-related methods to [TatananDetailEvent].
extension TatananDetailEventPatterns on TatananDetailEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Load value)?  load,TResult Function( _ToggleEditMode value)?  toggleEditMode,TResult Function( _AddVerses value)?  addVerses,TResult Function( _RemoveVerse value)?  removeVerse,TResult Function( _Reorder value)?  reorder,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that);case _ToggleEditMode() when toggleEditMode != null:
return toggleEditMode(_that);case _AddVerses() when addVerses != null:
return addVerses(_that);case _RemoveVerse() when removeVerse != null:
return removeVerse(_that);case _Reorder() when reorder != null:
return reorder(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Load value)  load,required TResult Function( _ToggleEditMode value)  toggleEditMode,required TResult Function( _AddVerses value)  addVerses,required TResult Function( _RemoveVerse value)  removeVerse,required TResult Function( _Reorder value)  reorder,}){
final _that = this;
switch (_that) {
case _Load():
return load(_that);case _ToggleEditMode():
return toggleEditMode(_that);case _AddVerses():
return addVerses(_that);case _RemoveVerse():
return removeVerse(_that);case _Reorder():
return reorder(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Load value)?  load,TResult? Function( _ToggleEditMode value)?  toggleEditMode,TResult? Function( _AddVerses value)?  addVerses,TResult? Function( _RemoveVerse value)?  removeVerse,TResult? Function( _Reorder value)?  reorder,}){
final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that);case _ToggleEditMode() when toggleEditMode != null:
return toggleEditMode(_that);case _AddVerses() when addVerses != null:
return addVerses(_that);case _RemoveVerse() when removeVerse != null:
return removeVerse(_that);case _Reorder() when reorder != null:
return reorder(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String tatananId)?  load,TResult Function()?  toggleEditMode,TResult Function( String tatananId,  List<int> verseIds)?  addVerses,TResult Function( String tatananId,  int verseId)?  removeVerse,TResult Function( String tatananId,  List<VersePositionUpdate> updates)?  reorder,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that.tatananId);case _ToggleEditMode() when toggleEditMode != null:
return toggleEditMode();case _AddVerses() when addVerses != null:
return addVerses(_that.tatananId,_that.verseIds);case _RemoveVerse() when removeVerse != null:
return removeVerse(_that.tatananId,_that.verseId);case _Reorder() when reorder != null:
return reorder(_that.tatananId,_that.updates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String tatananId)  load,required TResult Function()  toggleEditMode,required TResult Function( String tatananId,  List<int> verseIds)  addVerses,required TResult Function( String tatananId,  int verseId)  removeVerse,required TResult Function( String tatananId,  List<VersePositionUpdate> updates)  reorder,}) {final _that = this;
switch (_that) {
case _Load():
return load(_that.tatananId);case _ToggleEditMode():
return toggleEditMode();case _AddVerses():
return addVerses(_that.tatananId,_that.verseIds);case _RemoveVerse():
return removeVerse(_that.tatananId,_that.verseId);case _Reorder():
return reorder(_that.tatananId,_that.updates);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String tatananId)?  load,TResult? Function()?  toggleEditMode,TResult? Function( String tatananId,  List<int> verseIds)?  addVerses,TResult? Function( String tatananId,  int verseId)?  removeVerse,TResult? Function( String tatananId,  List<VersePositionUpdate> updates)?  reorder,}) {final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that.tatananId);case _ToggleEditMode() when toggleEditMode != null:
return toggleEditMode();case _AddVerses() when addVerses != null:
return addVerses(_that.tatananId,_that.verseIds);case _RemoveVerse() when removeVerse != null:
return removeVerse(_that.tatananId,_that.verseId);case _Reorder() when reorder != null:
return reorder(_that.tatananId,_that.updates);case _:
  return null;

}
}

}

/// @nodoc


class _Load implements TatananDetailEvent {
  const _Load({required this.tatananId});
  

 final  String tatananId;

/// Create a copy of TatananDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadCopyWith<_Load> get copyWith => __$LoadCopyWithImpl<_Load>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Load&&(identical(other.tatananId, tatananId) || other.tatananId == tatananId));
}


@override
int get hashCode => Object.hash(runtimeType,tatananId);

@override
String toString() {
  return 'TatananDetailEvent.load(tatananId: $tatananId)';
}


}

/// @nodoc
abstract mixin class _$LoadCopyWith<$Res> implements $TatananDetailEventCopyWith<$Res> {
  factory _$LoadCopyWith(_Load value, $Res Function(_Load) _then) = __$LoadCopyWithImpl;
@useResult
$Res call({
 String tatananId
});




}
/// @nodoc
class __$LoadCopyWithImpl<$Res>
    implements _$LoadCopyWith<$Res> {
  __$LoadCopyWithImpl(this._self, this._then);

  final _Load _self;
  final $Res Function(_Load) _then;

/// Create a copy of TatananDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tatananId = null,}) {
  return _then(_Load(
tatananId: null == tatananId ? _self.tatananId : tatananId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ToggleEditMode implements TatananDetailEvent {
  const _ToggleEditMode();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToggleEditMode);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TatananDetailEvent.toggleEditMode()';
}


}




/// @nodoc


class _AddVerses implements TatananDetailEvent {
  const _AddVerses({required this.tatananId, required final  List<int> verseIds}): _verseIds = verseIds;
  

 final  String tatananId;
 final  List<int> _verseIds;
 List<int> get verseIds {
  if (_verseIds is EqualUnmodifiableListView) return _verseIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_verseIds);
}


/// Create a copy of TatananDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddVersesCopyWith<_AddVerses> get copyWith => __$AddVersesCopyWithImpl<_AddVerses>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddVerses&&(identical(other.tatananId, tatananId) || other.tatananId == tatananId)&&const DeepCollectionEquality().equals(other._verseIds, _verseIds));
}


@override
int get hashCode => Object.hash(runtimeType,tatananId,const DeepCollectionEquality().hash(_verseIds));

@override
String toString() {
  return 'TatananDetailEvent.addVerses(tatananId: $tatananId, verseIds: $verseIds)';
}


}

/// @nodoc
abstract mixin class _$AddVersesCopyWith<$Res> implements $TatananDetailEventCopyWith<$Res> {
  factory _$AddVersesCopyWith(_AddVerses value, $Res Function(_AddVerses) _then) = __$AddVersesCopyWithImpl;
@useResult
$Res call({
 String tatananId, List<int> verseIds
});




}
/// @nodoc
class __$AddVersesCopyWithImpl<$Res>
    implements _$AddVersesCopyWith<$Res> {
  __$AddVersesCopyWithImpl(this._self, this._then);

  final _AddVerses _self;
  final $Res Function(_AddVerses) _then;

/// Create a copy of TatananDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tatananId = null,Object? verseIds = null,}) {
  return _then(_AddVerses(
tatananId: null == tatananId ? _self.tatananId : tatananId // ignore: cast_nullable_to_non_nullable
as String,verseIds: null == verseIds ? _self._verseIds : verseIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

/// @nodoc


class _RemoveVerse implements TatananDetailEvent {
  const _RemoveVerse({required this.tatananId, required this.verseId});
  

 final  String tatananId;
 final  int verseId;

/// Create a copy of TatananDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoveVerseCopyWith<_RemoveVerse> get copyWith => __$RemoveVerseCopyWithImpl<_RemoveVerse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoveVerse&&(identical(other.tatananId, tatananId) || other.tatananId == tatananId)&&(identical(other.verseId, verseId) || other.verseId == verseId));
}


@override
int get hashCode => Object.hash(runtimeType,tatananId,verseId);

@override
String toString() {
  return 'TatananDetailEvent.removeVerse(tatananId: $tatananId, verseId: $verseId)';
}


}

/// @nodoc
abstract mixin class _$RemoveVerseCopyWith<$Res> implements $TatananDetailEventCopyWith<$Res> {
  factory _$RemoveVerseCopyWith(_RemoveVerse value, $Res Function(_RemoveVerse) _then) = __$RemoveVerseCopyWithImpl;
@useResult
$Res call({
 String tatananId, int verseId
});




}
/// @nodoc
class __$RemoveVerseCopyWithImpl<$Res>
    implements _$RemoveVerseCopyWith<$Res> {
  __$RemoveVerseCopyWithImpl(this._self, this._then);

  final _RemoveVerse _self;
  final $Res Function(_RemoveVerse) _then;

/// Create a copy of TatananDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tatananId = null,Object? verseId = null,}) {
  return _then(_RemoveVerse(
tatananId: null == tatananId ? _self.tatananId : tatananId // ignore: cast_nullable_to_non_nullable
as String,verseId: null == verseId ? _self.verseId : verseId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _Reorder implements TatananDetailEvent {
  const _Reorder({required this.tatananId, required final  List<VersePositionUpdate> updates}): _updates = updates;
  

 final  String tatananId;
 final  List<VersePositionUpdate> _updates;
 List<VersePositionUpdate> get updates {
  if (_updates is EqualUnmodifiableListView) return _updates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_updates);
}


/// Create a copy of TatananDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReorderCopyWith<_Reorder> get copyWith => __$ReorderCopyWithImpl<_Reorder>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Reorder&&(identical(other.tatananId, tatananId) || other.tatananId == tatananId)&&const DeepCollectionEquality().equals(other._updates, _updates));
}


@override
int get hashCode => Object.hash(runtimeType,tatananId,const DeepCollectionEquality().hash(_updates));

@override
String toString() {
  return 'TatananDetailEvent.reorder(tatananId: $tatananId, updates: $updates)';
}


}

/// @nodoc
abstract mixin class _$ReorderCopyWith<$Res> implements $TatananDetailEventCopyWith<$Res> {
  factory _$ReorderCopyWith(_Reorder value, $Res Function(_Reorder) _then) = __$ReorderCopyWithImpl;
@useResult
$Res call({
 String tatananId, List<VersePositionUpdate> updates
});




}
/// @nodoc
class __$ReorderCopyWithImpl<$Res>
    implements _$ReorderCopyWith<$Res> {
  __$ReorderCopyWithImpl(this._self, this._then);

  final _Reorder _self;
  final $Res Function(_Reorder) _then;

/// Create a copy of TatananDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tatananId = null,Object? updates = null,}) {
  return _then(_Reorder(
tatananId: null == tatananId ? _self.tatananId : tatananId // ignore: cast_nullable_to_non_nullable
as String,updates: null == updates ? _self._updates : updates // ignore: cast_nullable_to_non_nullable
as List<VersePositionUpdate>,
  ));
}


}

/// @nodoc
mixin _$TatananDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TatananDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TatananDetailState()';
}


}

/// @nodoc
class $TatananDetailStateCopyWith<$Res>  {
$TatananDetailStateCopyWith(TatananDetailState _, $Res Function(TatananDetailState) __);
}


/// Adds pattern-matching-related methods to [TatananDetailState].
extension TatananDetailStatePatterns on TatananDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Error():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( TatananEntity tatanan,  List<TatananVerseEntity> verses,  bool isEditMode)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.tatanan,_that.verses,_that.isEditMode);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( TatananEntity tatanan,  List<TatananVerseEntity> verses,  bool isEditMode)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.tatanan,_that.verses,_that.isEditMode);case _Error():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( TatananEntity tatanan,  List<TatananVerseEntity> verses,  bool isEditMode)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.tatanan,_that.verses,_that.isEditMode);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements TatananDetailState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TatananDetailState.initial()';
}


}




/// @nodoc


class _Loading implements TatananDetailState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TatananDetailState.loading()';
}


}




/// @nodoc


class _Loaded implements TatananDetailState {
  const _Loaded({required this.tatanan, required final  List<TatananVerseEntity> verses, this.isEditMode = false}): _verses = verses;
  

 final  TatananEntity tatanan;
 final  List<TatananVerseEntity> _verses;
 List<TatananVerseEntity> get verses {
  if (_verses is EqualUnmodifiableListView) return _verses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_verses);
}

@JsonKey() final  bool isEditMode;

/// Create a copy of TatananDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.tatanan, tatanan) || other.tatanan == tatanan)&&const DeepCollectionEquality().equals(other._verses, _verses)&&(identical(other.isEditMode, isEditMode) || other.isEditMode == isEditMode));
}


@override
int get hashCode => Object.hash(runtimeType,tatanan,const DeepCollectionEquality().hash(_verses),isEditMode);

@override
String toString() {
  return 'TatananDetailState.loaded(tatanan: $tatanan, verses: $verses, isEditMode: $isEditMode)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $TatananDetailStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 TatananEntity tatanan, List<TatananVerseEntity> verses, bool isEditMode
});


$TatananEntityCopyWith<$Res> get tatanan;

}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of TatananDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tatanan = null,Object? verses = null,Object? isEditMode = null,}) {
  return _then(_Loaded(
tatanan: null == tatanan ? _self.tatanan : tatanan // ignore: cast_nullable_to_non_nullable
as TatananEntity,verses: null == verses ? _self._verses : verses // ignore: cast_nullable_to_non_nullable
as List<TatananVerseEntity>,isEditMode: null == isEditMode ? _self.isEditMode : isEditMode // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of TatananDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TatananEntityCopyWith<$Res> get tatanan {
  
  return $TatananEntityCopyWith<$Res>(_self.tatanan, (value) {
    return _then(_self.copyWith(tatanan: value));
  });
}
}

/// @nodoc


class _Error implements TatananDetailState {
  const _Error({required this.message});
  

 final  String message;

/// Create a copy of TatananDetailState
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
  return 'TatananDetailState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $TatananDetailStateCopyWith<$Res> {
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

/// Create a copy of TatananDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
