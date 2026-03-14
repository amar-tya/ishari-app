// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verse_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VerseEntity {

 int get id; int get chapterId; int get verseNumber; String get arabicText; String get transliteration;
/// Create a copy of VerseEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerseEntityCopyWith<VerseEntity> get copyWith => _$VerseEntityCopyWithImpl<VerseEntity>(this as VerseEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerseEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.verseNumber, verseNumber) || other.verseNumber == verseNumber)&&(identical(other.arabicText, arabicText) || other.arabicText == arabicText)&&(identical(other.transliteration, transliteration) || other.transliteration == transliteration));
}


@override
int get hashCode => Object.hash(runtimeType,id,chapterId,verseNumber,arabicText,transliteration);

@override
String toString() {
  return 'VerseEntity(id: $id, chapterId: $chapterId, verseNumber: $verseNumber, arabicText: $arabicText, transliteration: $transliteration)';
}


}

/// @nodoc
abstract mixin class $VerseEntityCopyWith<$Res>  {
  factory $VerseEntityCopyWith(VerseEntity value, $Res Function(VerseEntity) _then) = _$VerseEntityCopyWithImpl;
@useResult
$Res call({
 int id, int chapterId, int verseNumber, String arabicText, String transliteration
});




}
/// @nodoc
class _$VerseEntityCopyWithImpl<$Res>
    implements $VerseEntityCopyWith<$Res> {
  _$VerseEntityCopyWithImpl(this._self, this._then);

  final VerseEntity _self;
  final $Res Function(VerseEntity) _then;

/// Create a copy of VerseEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? chapterId = null,Object? verseNumber = null,Object? arabicText = null,Object? transliteration = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as int,verseNumber: null == verseNumber ? _self.verseNumber : verseNumber // ignore: cast_nullable_to_non_nullable
as int,arabicText: null == arabicText ? _self.arabicText : arabicText // ignore: cast_nullable_to_non_nullable
as String,transliteration: null == transliteration ? _self.transliteration : transliteration // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VerseEntity].
extension VerseEntityPatterns on VerseEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerseEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerseEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerseEntity value)  $default,){
final _that = this;
switch (_that) {
case _VerseEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerseEntity value)?  $default,){
final _that = this;
switch (_that) {
case _VerseEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int chapterId,  int verseNumber,  String arabicText,  String transliteration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerseEntity() when $default != null:
return $default(_that.id,_that.chapterId,_that.verseNumber,_that.arabicText,_that.transliteration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int chapterId,  int verseNumber,  String arabicText,  String transliteration)  $default,) {final _that = this;
switch (_that) {
case _VerseEntity():
return $default(_that.id,_that.chapterId,_that.verseNumber,_that.arabicText,_that.transliteration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int chapterId,  int verseNumber,  String arabicText,  String transliteration)?  $default,) {final _that = this;
switch (_that) {
case _VerseEntity() when $default != null:
return $default(_that.id,_that.chapterId,_that.verseNumber,_that.arabicText,_that.transliteration);case _:
  return null;

}
}

}

/// @nodoc


class _VerseEntity implements VerseEntity {
  const _VerseEntity({required this.id, required this.chapterId, required this.verseNumber, required this.arabicText, required this.transliteration});
  

@override final  int id;
@override final  int chapterId;
@override final  int verseNumber;
@override final  String arabicText;
@override final  String transliteration;

/// Create a copy of VerseEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerseEntityCopyWith<_VerseEntity> get copyWith => __$VerseEntityCopyWithImpl<_VerseEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerseEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId)&&(identical(other.verseNumber, verseNumber) || other.verseNumber == verseNumber)&&(identical(other.arabicText, arabicText) || other.arabicText == arabicText)&&(identical(other.transliteration, transliteration) || other.transliteration == transliteration));
}


@override
int get hashCode => Object.hash(runtimeType,id,chapterId,verseNumber,arabicText,transliteration);

@override
String toString() {
  return 'VerseEntity(id: $id, chapterId: $chapterId, verseNumber: $verseNumber, arabicText: $arabicText, transliteration: $transliteration)';
}


}

/// @nodoc
abstract mixin class _$VerseEntityCopyWith<$Res> implements $VerseEntityCopyWith<$Res> {
  factory _$VerseEntityCopyWith(_VerseEntity value, $Res Function(_VerseEntity) _then) = __$VerseEntityCopyWithImpl;
@override @useResult
$Res call({
 int id, int chapterId, int verseNumber, String arabicText, String transliteration
});




}
/// @nodoc
class __$VerseEntityCopyWithImpl<$Res>
    implements _$VerseEntityCopyWith<$Res> {
  __$VerseEntityCopyWithImpl(this._self, this._then);

  final _VerseEntity _self;
  final $Res Function(_VerseEntity) _then;

/// Create a copy of VerseEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? chapterId = null,Object? verseNumber = null,Object? arabicText = null,Object? transliteration = null,}) {
  return _then(_VerseEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as int,verseNumber: null == verseNumber ? _self.verseNumber : verseNumber // ignore: cast_nullable_to_non_nullable
as int,arabicText: null == arabicText ? _self.arabicText : arabicText // ignore: cast_nullable_to_non_nullable
as String,transliteration: null == transliteration ? _self.transliteration : transliteration // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
