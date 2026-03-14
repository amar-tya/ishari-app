// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verse_media_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VerseMediaModel {

@JsonKey(fromJson: _idToString) String get id;@JsonKey(name: 'verse_id', fromJson: _verseIdToString) String get verseId; HadiMediaModel get hadi;@JsonKey(name: 'media_url') String get mediaUrl;@JsonKey(fromJson: _idToString) String get duration;@JsonKey(fromJson: _typeToString) String get type;
/// Create a copy of VerseMediaModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerseMediaModelCopyWith<VerseMediaModel> get copyWith => _$VerseMediaModelCopyWithImpl<VerseMediaModel>(this as VerseMediaModel, _$identity);

  /// Serializes this VerseMediaModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerseMediaModel&&(identical(other.id, id) || other.id == id)&&(identical(other.verseId, verseId) || other.verseId == verseId)&&(identical(other.hadi, hadi) || other.hadi == hadi)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,verseId,hadi,mediaUrl,duration,type);

@override
String toString() {
  return 'VerseMediaModel(id: $id, verseId: $verseId, hadi: $hadi, mediaUrl: $mediaUrl, duration: $duration, type: $type)';
}


}

/// @nodoc
abstract mixin class $VerseMediaModelCopyWith<$Res>  {
  factory $VerseMediaModelCopyWith(VerseMediaModel value, $Res Function(VerseMediaModel) _then) = _$VerseMediaModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _idToString) String id,@JsonKey(name: 'verse_id', fromJson: _verseIdToString) String verseId, HadiMediaModel hadi,@JsonKey(name: 'media_url') String mediaUrl,@JsonKey(fromJson: _idToString) String duration,@JsonKey(fromJson: _typeToString) String type
});


$HadiMediaModelCopyWith<$Res> get hadi;

}
/// @nodoc
class _$VerseMediaModelCopyWithImpl<$Res>
    implements $VerseMediaModelCopyWith<$Res> {
  _$VerseMediaModelCopyWithImpl(this._self, this._then);

  final VerseMediaModel _self;
  final $Res Function(VerseMediaModel) _then;

/// Create a copy of VerseMediaModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? verseId = null,Object? hadi = null,Object? mediaUrl = null,Object? duration = null,Object? type = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,verseId: null == verseId ? _self.verseId : verseId // ignore: cast_nullable_to_non_nullable
as String,hadi: null == hadi ? _self.hadi : hadi // ignore: cast_nullable_to_non_nullable
as HadiMediaModel,mediaUrl: null == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of VerseMediaModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HadiMediaModelCopyWith<$Res> get hadi {
  
  return $HadiMediaModelCopyWith<$Res>(_self.hadi, (value) {
    return _then(_self.copyWith(hadi: value));
  });
}
}


/// Adds pattern-matching-related methods to [VerseMediaModel].
extension VerseMediaModelPatterns on VerseMediaModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerseMediaModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerseMediaModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerseMediaModel value)  $default,){
final _that = this;
switch (_that) {
case _VerseMediaModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerseMediaModel value)?  $default,){
final _that = this;
switch (_that) {
case _VerseMediaModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idToString)  String id, @JsonKey(name: 'verse_id', fromJson: _verseIdToString)  String verseId,  HadiMediaModel hadi, @JsonKey(name: 'media_url')  String mediaUrl, @JsonKey(fromJson: _idToString)  String duration, @JsonKey(fromJson: _typeToString)  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerseMediaModel() when $default != null:
return $default(_that.id,_that.verseId,_that.hadi,_that.mediaUrl,_that.duration,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idToString)  String id, @JsonKey(name: 'verse_id', fromJson: _verseIdToString)  String verseId,  HadiMediaModel hadi, @JsonKey(name: 'media_url')  String mediaUrl, @JsonKey(fromJson: _idToString)  String duration, @JsonKey(fromJson: _typeToString)  String type)  $default,) {final _that = this;
switch (_that) {
case _VerseMediaModel():
return $default(_that.id,_that.verseId,_that.hadi,_that.mediaUrl,_that.duration,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _idToString)  String id, @JsonKey(name: 'verse_id', fromJson: _verseIdToString)  String verseId,  HadiMediaModel hadi, @JsonKey(name: 'media_url')  String mediaUrl, @JsonKey(fromJson: _idToString)  String duration, @JsonKey(fromJson: _typeToString)  String type)?  $default,) {final _that = this;
switch (_that) {
case _VerseMediaModel() when $default != null:
return $default(_that.id,_that.verseId,_that.hadi,_that.mediaUrl,_that.duration,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VerseMediaModel extends VerseMediaModel {
  const _VerseMediaModel({@JsonKey(fromJson: _idToString) required this.id, @JsonKey(name: 'verse_id', fromJson: _verseIdToString) required this.verseId, required this.hadi, @JsonKey(name: 'media_url') required this.mediaUrl, @JsonKey(fromJson: _idToString) required this.duration, @JsonKey(fromJson: _typeToString) required this.type}): super._();
  factory _VerseMediaModel.fromJson(Map<String, dynamic> json) => _$VerseMediaModelFromJson(json);

@override@JsonKey(fromJson: _idToString) final  String id;
@override@JsonKey(name: 'verse_id', fromJson: _verseIdToString) final  String verseId;
@override final  HadiMediaModel hadi;
@override@JsonKey(name: 'media_url') final  String mediaUrl;
@override@JsonKey(fromJson: _idToString) final  String duration;
@override@JsonKey(fromJson: _typeToString) final  String type;

/// Create a copy of VerseMediaModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerseMediaModelCopyWith<_VerseMediaModel> get copyWith => __$VerseMediaModelCopyWithImpl<_VerseMediaModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VerseMediaModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerseMediaModel&&(identical(other.id, id) || other.id == id)&&(identical(other.verseId, verseId) || other.verseId == verseId)&&(identical(other.hadi, hadi) || other.hadi == hadi)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,verseId,hadi,mediaUrl,duration,type);

@override
String toString() {
  return 'VerseMediaModel(id: $id, verseId: $verseId, hadi: $hadi, mediaUrl: $mediaUrl, duration: $duration, type: $type)';
}


}

/// @nodoc
abstract mixin class _$VerseMediaModelCopyWith<$Res> implements $VerseMediaModelCopyWith<$Res> {
  factory _$VerseMediaModelCopyWith(_VerseMediaModel value, $Res Function(_VerseMediaModel) _then) = __$VerseMediaModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _idToString) String id,@JsonKey(name: 'verse_id', fromJson: _verseIdToString) String verseId, HadiMediaModel hadi,@JsonKey(name: 'media_url') String mediaUrl,@JsonKey(fromJson: _idToString) String duration,@JsonKey(fromJson: _typeToString) String type
});


@override $HadiMediaModelCopyWith<$Res> get hadi;

}
/// @nodoc
class __$VerseMediaModelCopyWithImpl<$Res>
    implements _$VerseMediaModelCopyWith<$Res> {
  __$VerseMediaModelCopyWithImpl(this._self, this._then);

  final _VerseMediaModel _self;
  final $Res Function(_VerseMediaModel) _then;

/// Create a copy of VerseMediaModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? verseId = null,Object? hadi = null,Object? mediaUrl = null,Object? duration = null,Object? type = null,}) {
  return _then(_VerseMediaModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,verseId: null == verseId ? _self.verseId : verseId // ignore: cast_nullable_to_non_nullable
as String,hadi: null == hadi ? _self.hadi : hadi // ignore: cast_nullable_to_non_nullable
as HadiMediaModel,mediaUrl: null == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of VerseMediaModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$HadiMediaModelCopyWith<$Res> get hadi {
  
  return $HadiMediaModelCopyWith<$Res>(_self.hadi, (value) {
    return _then(_self.copyWith(hadi: value));
  });
}
}

// dart format on
