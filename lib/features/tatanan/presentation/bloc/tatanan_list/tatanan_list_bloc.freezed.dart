// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tatanan_list_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TatananListEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TatananListEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TatananListEvent()';
}


}

/// @nodoc
class $TatananListEventCopyWith<$Res>  {
$TatananListEventCopyWith(TatananListEvent _, $Res Function(TatananListEvent) __);
}


/// Adds pattern-matching-related methods to [TatananListEvent].
extension TatananListEventPatterns on TatananListEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Load value)?  load,TResult Function( _Create value)?  create,TResult Function( _Delete value)?  delete,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that);case _Create() when create != null:
return create(_that);case _Delete() when delete != null:
return delete(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Load value)  load,required TResult Function( _Create value)  create,required TResult Function( _Delete value)  delete,}){
final _that = this;
switch (_that) {
case _Load():
return load(_that);case _Create():
return create(_that);case _Delete():
return delete(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Load value)?  load,TResult? Function( _Create value)?  create,TResult? Function( _Delete value)?  delete,}){
final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that);case _Create() when create != null:
return create(_that);case _Delete() when delete != null:
return delete(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String userId)?  load,TResult Function( String userId,  int chapterId,  String name,  String? description)?  create,TResult Function( String tatananId)?  delete,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that.userId);case _Create() when create != null:
return create(_that.userId,_that.chapterId,_that.name,_that.description);case _Delete() when delete != null:
return delete(_that.tatananId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String userId)  load,required TResult Function( String userId,  int chapterId,  String name,  String? description)  create,required TResult Function( String tatananId)  delete,}) {final _that = this;
switch (_that) {
case _Load():
return load(_that.userId);case _Create():
return create(_that.userId,_that.chapterId,_that.name,_that.description);case _Delete():
return delete(_that.tatananId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String userId)?  load,TResult? Function( String userId,  int chapterId,  String name,  String? description)?  create,TResult? Function( String tatananId)?  delete,}) {final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that.userId);case _Create() when create != null:
return create(_that.userId,_that.chapterId,_that.name,_that.description);case _Delete() when delete != null:
return delete(_that.tatananId);case _:
  return null;

}
}

}

/// @nodoc


class _Load implements TatananListEvent {
  const _Load({required this.userId});
  

 final  String userId;

/// Create a copy of TatananListEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadCopyWith<_Load> get copyWith => __$LoadCopyWithImpl<_Load>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Load&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,userId);

@override
String toString() {
  return 'TatananListEvent.load(userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$LoadCopyWith<$Res> implements $TatananListEventCopyWith<$Res> {
  factory _$LoadCopyWith(_Load value, $Res Function(_Load) _then) = __$LoadCopyWithImpl;
@useResult
$Res call({
 String userId
});




}
/// @nodoc
class __$LoadCopyWithImpl<$Res>
    implements _$LoadCopyWith<$Res> {
  __$LoadCopyWithImpl(this._self, this._then);

  final _Load _self;
  final $Res Function(_Load) _then;

/// Create a copy of TatananListEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = null,}) {
  return _then(_Load(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Create implements TatananListEvent {
  const _Create({required this.userId, required this.chapterId, required this.name, this.description});
  

 final  String userId;
 final  int chapterId;
 final  String name;
 final  String? description;

/// Create a copy of TatananListEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateCopyWith<_Create> get copyWith => __$CreateCopyWithImpl<_Create>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Create&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}


@override
int get hashCode => Object.hash(runtimeType,userId,chapterId,name,description);

@override
String toString() {
  return 'TatananListEvent.create(userId: $userId, chapterId: $chapterId, name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class _$CreateCopyWith<$Res> implements $TatananListEventCopyWith<$Res> {
  factory _$CreateCopyWith(_Create value, $Res Function(_Create) _then) = __$CreateCopyWithImpl;
@useResult
$Res call({
 String userId, int chapterId, String name, String? description
});




}
/// @nodoc
class __$CreateCopyWithImpl<$Res>
    implements _$CreateCopyWith<$Res> {
  __$CreateCopyWithImpl(this._self, this._then);

  final _Create _self;
  final $Res Function(_Create) _then;

/// Create a copy of TatananListEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? chapterId = null,Object? name = null,Object? description = freezed,}) {
  return _then(_Create(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _Delete implements TatananListEvent {
  const _Delete({required this.tatananId});
  

 final  String tatananId;

/// Create a copy of TatananListEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeleteCopyWith<_Delete> get copyWith => __$DeleteCopyWithImpl<_Delete>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Delete&&(identical(other.tatananId, tatananId) || other.tatananId == tatananId));
}


@override
int get hashCode => Object.hash(runtimeType,tatananId);

@override
String toString() {
  return 'TatananListEvent.delete(tatananId: $tatananId)';
}


}

/// @nodoc
abstract mixin class _$DeleteCopyWith<$Res> implements $TatananListEventCopyWith<$Res> {
  factory _$DeleteCopyWith(_Delete value, $Res Function(_Delete) _then) = __$DeleteCopyWithImpl;
@useResult
$Res call({
 String tatananId
});




}
/// @nodoc
class __$DeleteCopyWithImpl<$Res>
    implements _$DeleteCopyWith<$Res> {
  __$DeleteCopyWithImpl(this._self, this._then);

  final _Delete _self;
  final $Res Function(_Delete) _then;

/// Create a copy of TatananListEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tatananId = null,}) {
  return _then(_Delete(
tatananId: null == tatananId ? _self.tatananId : tatananId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$TatananListState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TatananListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TatananListState()';
}


}

/// @nodoc
class $TatananListStateCopyWith<$Res>  {
$TatananListStateCopyWith(TatananListState _, $Res Function(TatananListState) __);
}


/// Adds pattern-matching-related methods to [TatananListState].
extension TatananListStatePatterns on TatananListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Created value)?  created,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Created() when created != null:
return created(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Created value)  created,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Created():
return created(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Created value)?  created,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Created() when created != null:
return created(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<TatananEntity> tatanans)?  loaded,TResult Function( String tatananId)?  created,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.tatanans);case _Created() when created != null:
return created(_that.tatananId);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<TatananEntity> tatanans)  loaded,required TResult Function( String tatananId)  created,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.tatanans);case _Created():
return created(_that.tatananId);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<TatananEntity> tatanans)?  loaded,TResult? Function( String tatananId)?  created,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.tatanans);case _Created() when created != null:
return created(_that.tatananId);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements TatananListState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TatananListState.initial()';
}


}




/// @nodoc


class _Loading implements TatananListState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TatananListState.loading()';
}


}




/// @nodoc


class _Loaded implements TatananListState {
  const _Loaded({required final  List<TatananEntity> tatanans}): _tatanans = tatanans;
  

 final  List<TatananEntity> _tatanans;
 List<TatananEntity> get tatanans {
  if (_tatanans is EqualUnmodifiableListView) return _tatanans;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tatanans);
}


/// Create a copy of TatananListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._tatanans, _tatanans));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_tatanans));

@override
String toString() {
  return 'TatananListState.loaded(tatanans: $tatanans)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $TatananListStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<TatananEntity> tatanans
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of TatananListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tatanans = null,}) {
  return _then(_Loaded(
tatanans: null == tatanans ? _self._tatanans : tatanans // ignore: cast_nullable_to_non_nullable
as List<TatananEntity>,
  ));
}


}

/// @nodoc


class _Created implements TatananListState {
  const _Created({required this.tatananId});
  

 final  String tatananId;

/// Create a copy of TatananListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatedCopyWith<_Created> get copyWith => __$CreatedCopyWithImpl<_Created>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Created&&(identical(other.tatananId, tatananId) || other.tatananId == tatananId));
}


@override
int get hashCode => Object.hash(runtimeType,tatananId);

@override
String toString() {
  return 'TatananListState.created(tatananId: $tatananId)';
}


}

/// @nodoc
abstract mixin class _$CreatedCopyWith<$Res> implements $TatananListStateCopyWith<$Res> {
  factory _$CreatedCopyWith(_Created value, $Res Function(_Created) _then) = __$CreatedCopyWithImpl;
@useResult
$Res call({
 String tatananId
});




}
/// @nodoc
class __$CreatedCopyWithImpl<$Res>
    implements _$CreatedCopyWith<$Res> {
  __$CreatedCopyWithImpl(this._self, this._then);

  final _Created _self;
  final $Res Function(_Created) _then;

/// Create a copy of TatananListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tatananId = null,}) {
  return _then(_Created(
tatananId: null == tatananId ? _self.tatananId : tatananId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Error implements TatananListState {
  const _Error({required this.message});
  

 final  String message;

/// Create a copy of TatananListState
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
  return 'TatananListState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $TatananListStateCopyWith<$Res> {
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

/// Create a copy of TatananListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
