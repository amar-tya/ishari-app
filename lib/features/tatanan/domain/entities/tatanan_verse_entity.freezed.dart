// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tatanan_verse_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TatananVerseEntity {

 String get id; String get tatananId; int get verseId; int get position; int get verseNumber; String get arabicText; String get transliteration;
/// Create a copy of TatananVerseEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TatananVerseEntityCopyWith<TatananVerseEntity> get copyWith => _$TatananVerseEntityCopyWithImpl<TatananVerseEntity>(this as TatananVerseEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TatananVerseEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.tatananId, tatananId) || other.tatananId == tatananId)&&(identical(other.verseId, verseId) || other.verseId == verseId)&&(identical(other.position, position) || other.position == position)&&(identical(other.verseNumber, verseNumber) || other.verseNumber == verseNumber)&&(identical(other.arabicText, arabicText) || other.arabicText == arabicText)&&(identical(other.transliteration, transliteration) || other.transliteration == transliteration));
}


@override
int get hashCode => Object.hash(runtimeType,id,tatananId,verseId,position,verseNumber,arabicText,transliteration);

@override
String toString() {
  return 'TatananVerseEntity(id: $id, tatananId: $tatananId, verseId: $verseId, position: $position, verseNumber: $verseNumber, arabicText: $arabicText, transliteration: $transliteration)';
}


}

/// @nodoc
abstract mixin class $TatananVerseEntityCopyWith<$Res>  {
  factory $TatananVerseEntityCopyWith(TatananVerseEntity value, $Res Function(TatananVerseEntity) _then) = _$TatananVerseEntityCopyWithImpl;
@useResult
$Res call({
 String id, String tatananId, int verseId, int position, int verseNumber, String arabicText, String transliteration
});




}
/// @nodoc
class _$TatananVerseEntityCopyWithImpl<$Res>
    implements $TatananVerseEntityCopyWith<$Res> {
  _$TatananVerseEntityCopyWithImpl(this._self, this._then);

  final TatananVerseEntity _self;
  final $Res Function(TatananVerseEntity) _then;

/// Create a copy of TatananVerseEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? tatananId = null,Object? verseId = null,Object? position = null,Object? verseNumber = null,Object? arabicText = null,Object? transliteration = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tatananId: null == tatananId ? _self.tatananId : tatananId // ignore: cast_nullable_to_non_nullable
as String,verseId: null == verseId ? _self.verseId : verseId // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,verseNumber: null == verseNumber ? _self.verseNumber : verseNumber // ignore: cast_nullable_to_non_nullable
as int,arabicText: null == arabicText ? _self.arabicText : arabicText // ignore: cast_nullable_to_non_nullable
as String,transliteration: null == transliteration ? _self.transliteration : transliteration // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TatananVerseEntity].
extension TatananVerseEntityPatterns on TatananVerseEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TatananVerseEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TatananVerseEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TatananVerseEntity value)  $default,){
final _that = this;
switch (_that) {
case _TatananVerseEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TatananVerseEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TatananVerseEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String tatananId,  int verseId,  int position,  int verseNumber,  String arabicText,  String transliteration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TatananVerseEntity() when $default != null:
return $default(_that.id,_that.tatananId,_that.verseId,_that.position,_that.verseNumber,_that.arabicText,_that.transliteration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String tatananId,  int verseId,  int position,  int verseNumber,  String arabicText,  String transliteration)  $default,) {final _that = this;
switch (_that) {
case _TatananVerseEntity():
return $default(_that.id,_that.tatananId,_that.verseId,_that.position,_that.verseNumber,_that.arabicText,_that.transliteration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String tatananId,  int verseId,  int position,  int verseNumber,  String arabicText,  String transliteration)?  $default,) {final _that = this;
switch (_that) {
case _TatananVerseEntity() when $default != null:
return $default(_that.id,_that.tatananId,_that.verseId,_that.position,_that.verseNumber,_that.arabicText,_that.transliteration);case _:
  return null;

}
}

}

/// @nodoc


class _TatananVerseEntity implements TatananVerseEntity {
  const _TatananVerseEntity({required this.id, required this.tatananId, required this.verseId, required this.position, required this.verseNumber, required this.arabicText, required this.transliteration});
  

@override final  String id;
@override final  String tatananId;
@override final  int verseId;
@override final  int position;
@override final  int verseNumber;
@override final  String arabicText;
@override final  String transliteration;

/// Create a copy of TatananVerseEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TatananVerseEntityCopyWith<_TatananVerseEntity> get copyWith => __$TatananVerseEntityCopyWithImpl<_TatananVerseEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TatananVerseEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.tatananId, tatananId) || other.tatananId == tatananId)&&(identical(other.verseId, verseId) || other.verseId == verseId)&&(identical(other.position, position) || other.position == position)&&(identical(other.verseNumber, verseNumber) || other.verseNumber == verseNumber)&&(identical(other.arabicText, arabicText) || other.arabicText == arabicText)&&(identical(other.transliteration, transliteration) || other.transliteration == transliteration));
}


@override
int get hashCode => Object.hash(runtimeType,id,tatananId,verseId,position,verseNumber,arabicText,transliteration);

@override
String toString() {
  return 'TatananVerseEntity(id: $id, tatananId: $tatananId, verseId: $verseId, position: $position, verseNumber: $verseNumber, arabicText: $arabicText, transliteration: $transliteration)';
}


}

/// @nodoc
abstract mixin class _$TatananVerseEntityCopyWith<$Res> implements $TatananVerseEntityCopyWith<$Res> {
  factory _$TatananVerseEntityCopyWith(_TatananVerseEntity value, $Res Function(_TatananVerseEntity) _then) = __$TatananVerseEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String tatananId, int verseId, int position, int verseNumber, String arabicText, String transliteration
});




}
/// @nodoc
class __$TatananVerseEntityCopyWithImpl<$Res>
    implements _$TatananVerseEntityCopyWith<$Res> {
  __$TatananVerseEntityCopyWithImpl(this._self, this._then);

  final _TatananVerseEntity _self;
  final $Res Function(_TatananVerseEntity) _then;

/// Create a copy of TatananVerseEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? tatananId = null,Object? verseId = null,Object? position = null,Object? verseNumber = null,Object? arabicText = null,Object? transliteration = null,}) {
  return _then(_TatananVerseEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,tatananId: null == tatananId ? _self.tatananId : tatananId // ignore: cast_nullable_to_non_nullable
as String,verseId: null == verseId ? _self.verseId : verseId // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,verseNumber: null == verseNumber ? _self.verseNumber : verseNumber // ignore: cast_nullable_to_non_nullable
as int,arabicText: null == arabicText ? _self.arabicText : arabicText // ignore: cast_nullable_to_non_nullable
as String,transliteration: null == transliteration ? _self.transliteration : transliteration // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
