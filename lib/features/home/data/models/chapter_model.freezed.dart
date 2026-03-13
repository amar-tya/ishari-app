// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chapter_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChapterModel {

@JsonKey(fromJson: _idToString) String get id; String get title; String get category;@JsonKey(name: 'total_verses') int get verseCount;@JsonKey(name: 'chapter_number') int? get number;
/// Create a copy of ChapterModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterModelCopyWith<ChapterModel> get copyWith => _$ChapterModelCopyWithImpl<ChapterModel>(this as ChapterModel, _$identity);

  /// Serializes this ChapterModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChapterModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.verseCount, verseCount) || other.verseCount == verseCount)&&(identical(other.number, number) || other.number == number));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,category,verseCount,number);

@override
String toString() {
  return 'ChapterModel(id: $id, title: $title, category: $category, verseCount: $verseCount, number: $number)';
}


}

/// @nodoc
abstract mixin class $ChapterModelCopyWith<$Res>  {
  factory $ChapterModelCopyWith(ChapterModel value, $Res Function(ChapterModel) _then) = _$ChapterModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _idToString) String id, String title, String category,@JsonKey(name: 'total_verses') int verseCount,@JsonKey(name: 'chapter_number') int? number
});




}
/// @nodoc
class _$ChapterModelCopyWithImpl<$Res>
    implements $ChapterModelCopyWith<$Res> {
  _$ChapterModelCopyWithImpl(this._self, this._then);

  final ChapterModel _self;
  final $Res Function(ChapterModel) _then;

/// Create a copy of ChapterModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? category = null,Object? verseCount = null,Object? number = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,verseCount: null == verseCount ? _self.verseCount : verseCount // ignore: cast_nullable_to_non_nullable
as int,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChapterModel].
extension ChapterModelPatterns on ChapterModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChapterModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChapterModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChapterModel value)  $default,){
final _that = this;
switch (_that) {
case _ChapterModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChapterModel value)?  $default,){
final _that = this;
switch (_that) {
case _ChapterModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idToString)  String id,  String title,  String category, @JsonKey(name: 'total_verses')  int verseCount, @JsonKey(name: 'chapter_number')  int? number)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChapterModel() when $default != null:
return $default(_that.id,_that.title,_that.category,_that.verseCount,_that.number);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _idToString)  String id,  String title,  String category, @JsonKey(name: 'total_verses')  int verseCount, @JsonKey(name: 'chapter_number')  int? number)  $default,) {final _that = this;
switch (_that) {
case _ChapterModel():
return $default(_that.id,_that.title,_that.category,_that.verseCount,_that.number);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _idToString)  String id,  String title,  String category, @JsonKey(name: 'total_verses')  int verseCount, @JsonKey(name: 'chapter_number')  int? number)?  $default,) {final _that = this;
switch (_that) {
case _ChapterModel() when $default != null:
return $default(_that.id,_that.title,_that.category,_that.verseCount,_that.number);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChapterModel extends ChapterModel {
  const _ChapterModel({@JsonKey(fromJson: _idToString) required this.id, required this.title, required this.category, @JsonKey(name: 'total_verses') this.verseCount = 0, @JsonKey(name: 'chapter_number') this.number}): super._();
  factory _ChapterModel.fromJson(Map<String, dynamic> json) => _$ChapterModelFromJson(json);

@override@JsonKey(fromJson: _idToString) final  String id;
@override final  String title;
@override final  String category;
@override@JsonKey(name: 'total_verses') final  int verseCount;
@override@JsonKey(name: 'chapter_number') final  int? number;

/// Create a copy of ChapterModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChapterModelCopyWith<_ChapterModel> get copyWith => __$ChapterModelCopyWithImpl<_ChapterModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChapterModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChapterModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.verseCount, verseCount) || other.verseCount == verseCount)&&(identical(other.number, number) || other.number == number));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,category,verseCount,number);

@override
String toString() {
  return 'ChapterModel(id: $id, title: $title, category: $category, verseCount: $verseCount, number: $number)';
}


}

/// @nodoc
abstract mixin class _$ChapterModelCopyWith<$Res> implements $ChapterModelCopyWith<$Res> {
  factory _$ChapterModelCopyWith(_ChapterModel value, $Res Function(_ChapterModel) _then) = __$ChapterModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _idToString) String id, String title, String category,@JsonKey(name: 'total_verses') int verseCount,@JsonKey(name: 'chapter_number') int? number
});




}
/// @nodoc
class __$ChapterModelCopyWithImpl<$Res>
    implements _$ChapterModelCopyWith<$Res> {
  __$ChapterModelCopyWithImpl(this._self, this._then);

  final _ChapterModel _self;
  final $Res Function(_ChapterModel) _then;

/// Create a copy of ChapterModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? category = null,Object? verseCount = null,Object? number = freezed,}) {
  return _then(_ChapterModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,verseCount: null == verseCount ? _self.verseCount : verseCount // ignore: cast_nullable_to_non_nullable
as int,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
