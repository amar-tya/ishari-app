// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'translation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TranslationModel {

@JsonKey(fromJson: _idToString) String get id;@JsonKey(name: 'verse_id', fromJson: _idToString) String get verseId;@JsonKey(name: 'language_code') String get languageCode;@JsonKey(name: 'translation_text') String get translationText;
/// Create a copy of TranslationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranslationModelCopyWith<TranslationModel> get copyWith => _$TranslationModelCopyWithImpl<TranslationModel>(this as TranslationModel, _$identity);

  /// Serializes this TranslationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TranslationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.verseId, verseId) || other.verseId == verseId)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.translationText, translationText) || other.translationText == translationText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,verseId,languageCode,translationText);

@override
String toString() {
  return 'TranslationModel(id: $id, verseId: $verseId, languageCode: $languageCode, translationText: $translationText)';
}


}

/// @nodoc
abstract mixin class $TranslationModelCopyWith<$Res>  {
  factory $TranslationModelCopyWith(TranslationModel value, $Res Function(TranslationModel) _then) = _$TranslationModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _idToString) String id,@JsonKey(name: 'verse_id', fromJson: _idToString) String verseId,@JsonKey(name: 'language_code') String languageCode,@JsonKey(name: 'translation_text') String translationText
});




}
/// @nodoc
class _$TranslationModelCopyWithImpl<$Res>
    implements $TranslationModelCopyWith<$Res> {
  _$TranslationModelCopyWithImpl(this._self, this._then);

  final TranslationModel _self;
  final $Res Function(TranslationModel) _then;

/// Create a copy of TranslationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? verseId = null,Object? languageCode = null,Object? translationText = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,verseId: null == verseId ? _self.verseId : verseId // ignore: cast_nullable_to_non_nullable
as String,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,translationText: null == translationText ? _self.translationText : translationText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TranslationModel].
extension TranslationModelPatterns on TranslationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TranslationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TranslationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TranslationModel value)  $default,){
final _that = this;
switch (_that) {
case _TranslationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TranslationModel value)?  $default,){
final _that = this;
switch (_that) {
case _TranslationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idToString)  String id, @JsonKey(name: 'verse_id', fromJson: _idToString)  String verseId, @JsonKey(name: 'language_code')  String languageCode, @JsonKey(name: 'translation_text')  String translationText)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TranslationModel() when $default != null:
return $default(_that.id,_that.verseId,_that.languageCode,_that.translationText);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idToString)  String id, @JsonKey(name: 'verse_id', fromJson: _idToString)  String verseId, @JsonKey(name: 'language_code')  String languageCode, @JsonKey(name: 'translation_text')  String translationText)  $default,) {final _that = this;
switch (_that) {
case _TranslationModel():
return $default(_that.id,_that.verseId,_that.languageCode,_that.translationText);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _idToString)  String id, @JsonKey(name: 'verse_id', fromJson: _idToString)  String verseId, @JsonKey(name: 'language_code')  String languageCode, @JsonKey(name: 'translation_text')  String translationText)?  $default,) {final _that = this;
switch (_that) {
case _TranslationModel() when $default != null:
return $default(_that.id,_that.verseId,_that.languageCode,_that.translationText);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TranslationModel extends TranslationModel {
  const _TranslationModel({@JsonKey(fromJson: _idToString) required this.id, @JsonKey(name: 'verse_id', fromJson: _idToString) required this.verseId, @JsonKey(name: 'language_code') required this.languageCode, @JsonKey(name: 'translation_text') required this.translationText}): super._();
  factory _TranslationModel.fromJson(Map<String, dynamic> json) => _$TranslationModelFromJson(json);

@override@JsonKey(fromJson: _idToString) final  String id;
@override@JsonKey(name: 'verse_id', fromJson: _idToString) final  String verseId;
@override@JsonKey(name: 'language_code') final  String languageCode;
@override@JsonKey(name: 'translation_text') final  String translationText;

/// Create a copy of TranslationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TranslationModelCopyWith<_TranslationModel> get copyWith => __$TranslationModelCopyWithImpl<_TranslationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TranslationModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TranslationModel&&(identical(other.id, id) || other.id == id)&&(identical(other.verseId, verseId) || other.verseId == verseId)&&(identical(other.languageCode, languageCode) || other.languageCode == languageCode)&&(identical(other.translationText, translationText) || other.translationText == translationText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,verseId,languageCode,translationText);

@override
String toString() {
  return 'TranslationModel(id: $id, verseId: $verseId, languageCode: $languageCode, translationText: $translationText)';
}


}

/// @nodoc
abstract mixin class _$TranslationModelCopyWith<$Res> implements $TranslationModelCopyWith<$Res> {
  factory _$TranslationModelCopyWith(_TranslationModel value, $Res Function(_TranslationModel) _then) = __$TranslationModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _idToString) String id,@JsonKey(name: 'verse_id', fromJson: _idToString) String verseId,@JsonKey(name: 'language_code') String languageCode,@JsonKey(name: 'translation_text') String translationText
});




}
/// @nodoc
class __$TranslationModelCopyWithImpl<$Res>
    implements _$TranslationModelCopyWith<$Res> {
  __$TranslationModelCopyWithImpl(this._self, this._then);

  final _TranslationModel _self;
  final $Res Function(_TranslationModel) _then;

/// Create a copy of TranslationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? verseId = null,Object? languageCode = null,Object? translationText = null,}) {
  return _then(_TranslationModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,verseId: null == verseId ? _self.verseId : verseId // ignore: cast_nullable_to_non_nullable
as String,languageCode: null == languageCode ? _self.languageCode : languageCode // ignore: cast_nullable_to_non_nullable
as String,translationText: null == translationText ? _self.translationText : translationText // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
