// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verse_with_details_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VerseWithDetailsEntity {

 VerseEntity get verse; List<TranslationEntity> get translations; List<VerseMediaEntity> get mediaList;
/// Create a copy of VerseWithDetailsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerseWithDetailsEntityCopyWith<VerseWithDetailsEntity> get copyWith => _$VerseWithDetailsEntityCopyWithImpl<VerseWithDetailsEntity>(this as VerseWithDetailsEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerseWithDetailsEntity&&(identical(other.verse, verse) || other.verse == verse)&&const DeepCollectionEquality().equals(other.translations, translations)&&const DeepCollectionEquality().equals(other.mediaList, mediaList));
}


@override
int get hashCode => Object.hash(runtimeType,verse,const DeepCollectionEquality().hash(translations),const DeepCollectionEquality().hash(mediaList));

@override
String toString() {
  return 'VerseWithDetailsEntity(verse: $verse, translations: $translations, mediaList: $mediaList)';
}


}

/// @nodoc
abstract mixin class $VerseWithDetailsEntityCopyWith<$Res>  {
  factory $VerseWithDetailsEntityCopyWith(VerseWithDetailsEntity value, $Res Function(VerseWithDetailsEntity) _then) = _$VerseWithDetailsEntityCopyWithImpl;
@useResult
$Res call({
 VerseEntity verse, List<TranslationEntity> translations, List<VerseMediaEntity> mediaList
});


$VerseEntityCopyWith<$Res> get verse;

}
/// @nodoc
class _$VerseWithDetailsEntityCopyWithImpl<$Res>
    implements $VerseWithDetailsEntityCopyWith<$Res> {
  _$VerseWithDetailsEntityCopyWithImpl(this._self, this._then);

  final VerseWithDetailsEntity _self;
  final $Res Function(VerseWithDetailsEntity) _then;

/// Create a copy of VerseWithDetailsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? verse = null,Object? translations = null,Object? mediaList = null,}) {
  return _then(_self.copyWith(
verse: null == verse ? _self.verse : verse // ignore: cast_nullable_to_non_nullable
as VerseEntity,translations: null == translations ? _self.translations : translations // ignore: cast_nullable_to_non_nullable
as List<TranslationEntity>,mediaList: null == mediaList ? _self.mediaList : mediaList // ignore: cast_nullable_to_non_nullable
as List<VerseMediaEntity>,
  ));
}
/// Create a copy of VerseWithDetailsEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VerseEntityCopyWith<$Res> get verse {
  
  return $VerseEntityCopyWith<$Res>(_self.verse, (value) {
    return _then(_self.copyWith(verse: value));
  });
}
}


/// Adds pattern-matching-related methods to [VerseWithDetailsEntity].
extension VerseWithDetailsEntityPatterns on VerseWithDetailsEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerseWithDetailsEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerseWithDetailsEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerseWithDetailsEntity value)  $default,){
final _that = this;
switch (_that) {
case _VerseWithDetailsEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerseWithDetailsEntity value)?  $default,){
final _that = this;
switch (_that) {
case _VerseWithDetailsEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( VerseEntity verse,  List<TranslationEntity> translations,  List<VerseMediaEntity> mediaList)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerseWithDetailsEntity() when $default != null:
return $default(_that.verse,_that.translations,_that.mediaList);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( VerseEntity verse,  List<TranslationEntity> translations,  List<VerseMediaEntity> mediaList)  $default,) {final _that = this;
switch (_that) {
case _VerseWithDetailsEntity():
return $default(_that.verse,_that.translations,_that.mediaList);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( VerseEntity verse,  List<TranslationEntity> translations,  List<VerseMediaEntity> mediaList)?  $default,) {final _that = this;
switch (_that) {
case _VerseWithDetailsEntity() when $default != null:
return $default(_that.verse,_that.translations,_that.mediaList);case _:
  return null;

}
}

}

/// @nodoc


class _VerseWithDetailsEntity implements VerseWithDetailsEntity {
  const _VerseWithDetailsEntity({required this.verse, required final  List<TranslationEntity> translations, required final  List<VerseMediaEntity> mediaList}): _translations = translations,_mediaList = mediaList;
  

@override final  VerseEntity verse;
 final  List<TranslationEntity> _translations;
@override List<TranslationEntity> get translations {
  if (_translations is EqualUnmodifiableListView) return _translations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_translations);
}

 final  List<VerseMediaEntity> _mediaList;
@override List<VerseMediaEntity> get mediaList {
  if (_mediaList is EqualUnmodifiableListView) return _mediaList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mediaList);
}


/// Create a copy of VerseWithDetailsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerseWithDetailsEntityCopyWith<_VerseWithDetailsEntity> get copyWith => __$VerseWithDetailsEntityCopyWithImpl<_VerseWithDetailsEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerseWithDetailsEntity&&(identical(other.verse, verse) || other.verse == verse)&&const DeepCollectionEquality().equals(other._translations, _translations)&&const DeepCollectionEquality().equals(other._mediaList, _mediaList));
}


@override
int get hashCode => Object.hash(runtimeType,verse,const DeepCollectionEquality().hash(_translations),const DeepCollectionEquality().hash(_mediaList));

@override
String toString() {
  return 'VerseWithDetailsEntity(verse: $verse, translations: $translations, mediaList: $mediaList)';
}


}

/// @nodoc
abstract mixin class _$VerseWithDetailsEntityCopyWith<$Res> implements $VerseWithDetailsEntityCopyWith<$Res> {
  factory _$VerseWithDetailsEntityCopyWith(_VerseWithDetailsEntity value, $Res Function(_VerseWithDetailsEntity) _then) = __$VerseWithDetailsEntityCopyWithImpl;
@override @useResult
$Res call({
 VerseEntity verse, List<TranslationEntity> translations, List<VerseMediaEntity> mediaList
});


@override $VerseEntityCopyWith<$Res> get verse;

}
/// @nodoc
class __$VerseWithDetailsEntityCopyWithImpl<$Res>
    implements _$VerseWithDetailsEntityCopyWith<$Res> {
  __$VerseWithDetailsEntityCopyWithImpl(this._self, this._then);

  final _VerseWithDetailsEntity _self;
  final $Res Function(_VerseWithDetailsEntity) _then;

/// Create a copy of VerseWithDetailsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? verse = null,Object? translations = null,Object? mediaList = null,}) {
  return _then(_VerseWithDetailsEntity(
verse: null == verse ? _self.verse : verse // ignore: cast_nullable_to_non_nullable
as VerseEntity,translations: null == translations ? _self._translations : translations // ignore: cast_nullable_to_non_nullable
as List<TranslationEntity>,mediaList: null == mediaList ? _self._mediaList : mediaList // ignore: cast_nullable_to_non_nullable
as List<VerseMediaEntity>,
  ));
}

/// Create a copy of VerseWithDetailsEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VerseEntityCopyWith<$Res> get verse {
  
  return $VerseEntityCopyWith<$Res>(_self.verse, (value) {
    return _then(_self.copyWith(verse: value));
  });
}
}

// dart format on
