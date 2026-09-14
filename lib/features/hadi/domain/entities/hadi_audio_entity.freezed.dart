// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hadi_audio_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HadiAudioEntity {

 int get id; String get hadiId; int get verseId; int get verseNumber; String get chapterTitle; String get arabicText; String get mediaUrl; VerseMediaType get type; int? get duration;
/// Create a copy of HadiAudioEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HadiAudioEntityCopyWith<HadiAudioEntity> get copyWith => _$HadiAudioEntityCopyWithImpl<HadiAudioEntity>(this as HadiAudioEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HadiAudioEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.hadiId, hadiId) || other.hadiId == hadiId)&&(identical(other.verseId, verseId) || other.verseId == verseId)&&(identical(other.verseNumber, verseNumber) || other.verseNumber == verseNumber)&&(identical(other.chapterTitle, chapterTitle) || other.chapterTitle == chapterTitle)&&(identical(other.arabicText, arabicText) || other.arabicText == arabicText)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.type, type) || other.type == type)&&(identical(other.duration, duration) || other.duration == duration));
}


@override
int get hashCode => Object.hash(runtimeType,id,hadiId,verseId,verseNumber,chapterTitle,arabicText,mediaUrl,type,duration);

@override
String toString() {
  return 'HadiAudioEntity(id: $id, hadiId: $hadiId, verseId: $verseId, verseNumber: $verseNumber, chapterTitle: $chapterTitle, arabicText: $arabicText, mediaUrl: $mediaUrl, type: $type, duration: $duration)';
}


}

/// @nodoc
abstract mixin class $HadiAudioEntityCopyWith<$Res>  {
  factory $HadiAudioEntityCopyWith(HadiAudioEntity value, $Res Function(HadiAudioEntity) _then) = _$HadiAudioEntityCopyWithImpl;
@useResult
$Res call({
 int id, String hadiId, int verseId, int verseNumber, String chapterTitle, String arabicText, String mediaUrl, VerseMediaType type, int? duration
});




}
/// @nodoc
class _$HadiAudioEntityCopyWithImpl<$Res>
    implements $HadiAudioEntityCopyWith<$Res> {
  _$HadiAudioEntityCopyWithImpl(this._self, this._then);

  final HadiAudioEntity _self;
  final $Res Function(HadiAudioEntity) _then;

/// Create a copy of HadiAudioEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? hadiId = null,Object? verseId = null,Object? verseNumber = null,Object? chapterTitle = null,Object? arabicText = null,Object? mediaUrl = null,Object? type = null,Object? duration = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,hadiId: null == hadiId ? _self.hadiId : hadiId // ignore: cast_nullable_to_non_nullable
as String,verseId: null == verseId ? _self.verseId : verseId // ignore: cast_nullable_to_non_nullable
as int,verseNumber: null == verseNumber ? _self.verseNumber : verseNumber // ignore: cast_nullable_to_non_nullable
as int,chapterTitle: null == chapterTitle ? _self.chapterTitle : chapterTitle // ignore: cast_nullable_to_non_nullable
as String,arabicText: null == arabicText ? _self.arabicText : arabicText // ignore: cast_nullable_to_non_nullable
as String,mediaUrl: null == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as VerseMediaType,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [HadiAudioEntity].
extension HadiAudioEntityPatterns on HadiAudioEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HadiAudioEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HadiAudioEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HadiAudioEntity value)  $default,){
final _that = this;
switch (_that) {
case _HadiAudioEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HadiAudioEntity value)?  $default,){
final _that = this;
switch (_that) {
case _HadiAudioEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String hadiId,  int verseId,  int verseNumber,  String chapterTitle,  String arabicText,  String mediaUrl,  VerseMediaType type,  int? duration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HadiAudioEntity() when $default != null:
return $default(_that.id,_that.hadiId,_that.verseId,_that.verseNumber,_that.chapterTitle,_that.arabicText,_that.mediaUrl,_that.type,_that.duration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String hadiId,  int verseId,  int verseNumber,  String chapterTitle,  String arabicText,  String mediaUrl,  VerseMediaType type,  int? duration)  $default,) {final _that = this;
switch (_that) {
case _HadiAudioEntity():
return $default(_that.id,_that.hadiId,_that.verseId,_that.verseNumber,_that.chapterTitle,_that.arabicText,_that.mediaUrl,_that.type,_that.duration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String hadiId,  int verseId,  int verseNumber,  String chapterTitle,  String arabicText,  String mediaUrl,  VerseMediaType type,  int? duration)?  $default,) {final _that = this;
switch (_that) {
case _HadiAudioEntity() when $default != null:
return $default(_that.id,_that.hadiId,_that.verseId,_that.verseNumber,_that.chapterTitle,_that.arabicText,_that.mediaUrl,_that.type,_that.duration);case _:
  return null;

}
}

}

/// @nodoc


class _HadiAudioEntity implements HadiAudioEntity {
  const _HadiAudioEntity({required this.id, required this.hadiId, required this.verseId, required this.verseNumber, required this.chapterTitle, required this.arabicText, required this.mediaUrl, required this.type, this.duration});
  

@override final  int id;
@override final  String hadiId;
@override final  int verseId;
@override final  int verseNumber;
@override final  String chapterTitle;
@override final  String arabicText;
@override final  String mediaUrl;
@override final  VerseMediaType type;
@override final  int? duration;

/// Create a copy of HadiAudioEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HadiAudioEntityCopyWith<_HadiAudioEntity> get copyWith => __$HadiAudioEntityCopyWithImpl<_HadiAudioEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HadiAudioEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.hadiId, hadiId) || other.hadiId == hadiId)&&(identical(other.verseId, verseId) || other.verseId == verseId)&&(identical(other.verseNumber, verseNumber) || other.verseNumber == verseNumber)&&(identical(other.chapterTitle, chapterTitle) || other.chapterTitle == chapterTitle)&&(identical(other.arabicText, arabicText) || other.arabicText == arabicText)&&(identical(other.mediaUrl, mediaUrl) || other.mediaUrl == mediaUrl)&&(identical(other.type, type) || other.type == type)&&(identical(other.duration, duration) || other.duration == duration));
}


@override
int get hashCode => Object.hash(runtimeType,id,hadiId,verseId,verseNumber,chapterTitle,arabicText,mediaUrl,type,duration);

@override
String toString() {
  return 'HadiAudioEntity(id: $id, hadiId: $hadiId, verseId: $verseId, verseNumber: $verseNumber, chapterTitle: $chapterTitle, arabicText: $arabicText, mediaUrl: $mediaUrl, type: $type, duration: $duration)';
}


}

/// @nodoc
abstract mixin class _$HadiAudioEntityCopyWith<$Res> implements $HadiAudioEntityCopyWith<$Res> {
  factory _$HadiAudioEntityCopyWith(_HadiAudioEntity value, $Res Function(_HadiAudioEntity) _then) = __$HadiAudioEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, String hadiId, int verseId, int verseNumber, String chapterTitle, String arabicText, String mediaUrl, VerseMediaType type, int? duration
});




}
/// @nodoc
class __$HadiAudioEntityCopyWithImpl<$Res>
    implements _$HadiAudioEntityCopyWith<$Res> {
  __$HadiAudioEntityCopyWithImpl(this._self, this._then);

  final _HadiAudioEntity _self;
  final $Res Function(_HadiAudioEntity) _then;

/// Create a copy of HadiAudioEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? hadiId = null,Object? verseId = null,Object? verseNumber = null,Object? chapterTitle = null,Object? arabicText = null,Object? mediaUrl = null,Object? type = null,Object? duration = freezed,}) {
  return _then(_HadiAudioEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,hadiId: null == hadiId ? _self.hadiId : hadiId // ignore: cast_nullable_to_non_nullable
as String,verseId: null == verseId ? _self.verseId : verseId // ignore: cast_nullable_to_non_nullable
as int,verseNumber: null == verseNumber ? _self.verseNumber : verseNumber // ignore: cast_nullable_to_non_nullable
as int,chapterTitle: null == chapterTitle ? _self.chapterTitle : chapterTitle // ignore: cast_nullable_to_non_nullable
as String,arabicText: null == arabicText ? _self.arabicText : arabicText // ignore: cast_nullable_to_non_nullable
as String,mediaUrl: null == mediaUrl ? _self.mediaUrl : mediaUrl // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as VerseMediaType,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
