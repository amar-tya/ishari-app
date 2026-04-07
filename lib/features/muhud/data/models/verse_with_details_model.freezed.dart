// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verse_with_details_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VerseWithDetailsModel {

 VerseModel get verse; List<TranslationModel> get translations; List<VerseMediaModel> get mediaList;
/// Create a copy of VerseWithDetailsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerseWithDetailsModelCopyWith<VerseWithDetailsModel> get copyWith => _$VerseWithDetailsModelCopyWithImpl<VerseWithDetailsModel>(this as VerseWithDetailsModel, _$identity);

  /// Serializes this VerseWithDetailsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerseWithDetailsModel&&(identical(other.verse, verse) || other.verse == verse)&&const DeepCollectionEquality().equals(other.translations, translations)&&const DeepCollectionEquality().equals(other.mediaList, mediaList));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,verse,const DeepCollectionEquality().hash(translations),const DeepCollectionEquality().hash(mediaList));

@override
String toString() {
  return 'VerseWithDetailsModel(verse: $verse, translations: $translations, mediaList: $mediaList)';
}


}

/// @nodoc
abstract mixin class $VerseWithDetailsModelCopyWith<$Res>  {
  factory $VerseWithDetailsModelCopyWith(VerseWithDetailsModel value, $Res Function(VerseWithDetailsModel) _then) = _$VerseWithDetailsModelCopyWithImpl;
@useResult
$Res call({
 VerseModel verse, List<TranslationModel> translations, List<VerseMediaModel> mediaList
});


$VerseModelCopyWith<$Res> get verse;

}
/// @nodoc
class _$VerseWithDetailsModelCopyWithImpl<$Res>
    implements $VerseWithDetailsModelCopyWith<$Res> {
  _$VerseWithDetailsModelCopyWithImpl(this._self, this._then);

  final VerseWithDetailsModel _self;
  final $Res Function(VerseWithDetailsModel) _then;

/// Create a copy of VerseWithDetailsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? verse = null,Object? translations = null,Object? mediaList = null,}) {
  return _then(_self.copyWith(
verse: null == verse ? _self.verse : verse // ignore: cast_nullable_to_non_nullable
as VerseModel,translations: null == translations ? _self.translations : translations // ignore: cast_nullable_to_non_nullable
as List<TranslationModel>,mediaList: null == mediaList ? _self.mediaList : mediaList // ignore: cast_nullable_to_non_nullable
as List<VerseMediaModel>,
  ));
}
/// Create a copy of VerseWithDetailsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VerseModelCopyWith<$Res> get verse {
  
  return $VerseModelCopyWith<$Res>(_self.verse, (value) {
    return _then(_self.copyWith(verse: value));
  });
}
}


/// Adds pattern-matching-related methods to [VerseWithDetailsModel].
extension VerseWithDetailsModelPatterns on VerseWithDetailsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerseWithDetailsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerseWithDetailsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerseWithDetailsModel value)  $default,){
final _that = this;
switch (_that) {
case _VerseWithDetailsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerseWithDetailsModel value)?  $default,){
final _that = this;
switch (_that) {
case _VerseWithDetailsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( VerseModel verse,  List<TranslationModel> translations,  List<VerseMediaModel> mediaList)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerseWithDetailsModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( VerseModel verse,  List<TranslationModel> translations,  List<VerseMediaModel> mediaList)  $default,) {final _that = this;
switch (_that) {
case _VerseWithDetailsModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( VerseModel verse,  List<TranslationModel> translations,  List<VerseMediaModel> mediaList)?  $default,) {final _that = this;
switch (_that) {
case _VerseWithDetailsModel() when $default != null:
return $default(_that.verse,_that.translations,_that.mediaList);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VerseWithDetailsModel extends VerseWithDetailsModel {
  const _VerseWithDetailsModel({required this.verse, final  List<TranslationModel> translations = const [], final  List<VerseMediaModel> mediaList = const []}): _translations = translations,_mediaList = mediaList,super._();
  factory _VerseWithDetailsModel.fromJson(Map<String, dynamic> json) => _$VerseWithDetailsModelFromJson(json);

@override final  VerseModel verse;
 final  List<TranslationModel> _translations;
@override@JsonKey() List<TranslationModel> get translations {
  if (_translations is EqualUnmodifiableListView) return _translations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_translations);
}

 final  List<VerseMediaModel> _mediaList;
@override@JsonKey() List<VerseMediaModel> get mediaList {
  if (_mediaList is EqualUnmodifiableListView) return _mediaList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mediaList);
}


/// Create a copy of VerseWithDetailsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerseWithDetailsModelCopyWith<_VerseWithDetailsModel> get copyWith => __$VerseWithDetailsModelCopyWithImpl<_VerseWithDetailsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VerseWithDetailsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerseWithDetailsModel&&(identical(other.verse, verse) || other.verse == verse)&&const DeepCollectionEquality().equals(other._translations, _translations)&&const DeepCollectionEquality().equals(other._mediaList, _mediaList));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,verse,const DeepCollectionEquality().hash(_translations),const DeepCollectionEquality().hash(_mediaList));

@override
String toString() {
  return 'VerseWithDetailsModel(verse: $verse, translations: $translations, mediaList: $mediaList)';
}


}

/// @nodoc
abstract mixin class _$VerseWithDetailsModelCopyWith<$Res> implements $VerseWithDetailsModelCopyWith<$Res> {
  factory _$VerseWithDetailsModelCopyWith(_VerseWithDetailsModel value, $Res Function(_VerseWithDetailsModel) _then) = __$VerseWithDetailsModelCopyWithImpl;
@override @useResult
$Res call({
 VerseModel verse, List<TranslationModel> translations, List<VerseMediaModel> mediaList
});


@override $VerseModelCopyWith<$Res> get verse;

}
/// @nodoc
class __$VerseWithDetailsModelCopyWithImpl<$Res>
    implements _$VerseWithDetailsModelCopyWith<$Res> {
  __$VerseWithDetailsModelCopyWithImpl(this._self, this._then);

  final _VerseWithDetailsModel _self;
  final $Res Function(_VerseWithDetailsModel) _then;

/// Create a copy of VerseWithDetailsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? verse = null,Object? translations = null,Object? mediaList = null,}) {
  return _then(_VerseWithDetailsModel(
verse: null == verse ? _self.verse : verse // ignore: cast_nullable_to_non_nullable
as VerseModel,translations: null == translations ? _self._translations : translations // ignore: cast_nullable_to_non_nullable
as List<TranslationModel>,mediaList: null == mediaList ? _self._mediaList : mediaList // ignore: cast_nullable_to_non_nullable
as List<VerseMediaModel>,
  ));
}

/// Create a copy of VerseWithDetailsModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VerseModelCopyWith<$Res> get verse {
  
  return $VerseModelCopyWith<$Res>(_self.verse, (value) {
    return _then(_self.copyWith(verse: value));
  });
}
}

// dart format on
