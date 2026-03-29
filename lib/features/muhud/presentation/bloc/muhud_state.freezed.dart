// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'muhud_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MuhudState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MuhudState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MuhudState()';
}


}

/// @nodoc
class $MuhudStateCopyWith<$Res>  {
$MuhudStateCopyWith(MuhudState _, $Res Function(MuhudState) __);
}


/// Adds pattern-matching-related methods to [MuhudState].
extension MuhudStatePatterns on MuhudState {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( ChapterEntity chapter,  List<VerseWithDetailsEntity> verses,  Set<int> bookmarkedVerseIds,  bool showTranslation,  int? playingVerseId,  bool isAudioLoading,  bool showArabic,  bool showTransliteration,  double arabFontSize,  double transliterationFontSize,  double translationFontSize)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.chapter,_that.verses,_that.bookmarkedVerseIds,_that.showTranslation,_that.playingVerseId,_that.isAudioLoading,_that.showArabic,_that.showTransliteration,_that.arabFontSize,_that.transliterationFontSize,_that.translationFontSize);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( ChapterEntity chapter,  List<VerseWithDetailsEntity> verses,  Set<int> bookmarkedVerseIds,  bool showTranslation,  int? playingVerseId,  bool isAudioLoading,  bool showArabic,  bool showTransliteration,  double arabFontSize,  double transliterationFontSize,  double translationFontSize)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.chapter,_that.verses,_that.bookmarkedVerseIds,_that.showTranslation,_that.playingVerseId,_that.isAudioLoading,_that.showArabic,_that.showTransliteration,_that.arabFontSize,_that.transliterationFontSize,_that.translationFontSize);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( ChapterEntity chapter,  List<VerseWithDetailsEntity> verses,  Set<int> bookmarkedVerseIds,  bool showTranslation,  int? playingVerseId,  bool isAudioLoading,  bool showArabic,  bool showTransliteration,  double arabFontSize,  double transliterationFontSize,  double translationFontSize)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.chapter,_that.verses,_that.bookmarkedVerseIds,_that.showTranslation,_that.playingVerseId,_that.isAudioLoading,_that.showArabic,_that.showTransliteration,_that.arabFontSize,_that.transliterationFontSize,_that.translationFontSize);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements MuhudState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MuhudState.initial()';
}


}




/// @nodoc


class _Loading implements MuhudState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MuhudState.loading()';
}


}




/// @nodoc


class _Loaded implements MuhudState {
  const _Loaded({required this.chapter, required final  List<VerseWithDetailsEntity> verses, required final  Set<int> bookmarkedVerseIds, required this.showTranslation, this.playingVerseId, this.isAudioLoading = false, this.showArabic = true, this.showTransliteration = true, this.arabFontSize = 22.0, this.transliterationFontSize = 11.0, this.translationFontSize = 14.0}): _verses = verses,_bookmarkedVerseIds = bookmarkedVerseIds;
  

 final  ChapterEntity chapter;
 final  List<VerseWithDetailsEntity> _verses;
 List<VerseWithDetailsEntity> get verses {
  if (_verses is EqualUnmodifiableListView) return _verses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_verses);
}

 final  Set<int> _bookmarkedVerseIds;
 Set<int> get bookmarkedVerseIds {
  if (_bookmarkedVerseIds is EqualUnmodifiableSetView) return _bookmarkedVerseIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_bookmarkedVerseIds);
}

 final  bool showTranslation;
 final  int? playingVerseId;
@JsonKey() final  bool isAudioLoading;
@JsonKey() final  bool showArabic;
@JsonKey() final  bool showTransliteration;
@JsonKey() final  double arabFontSize;
@JsonKey() final  double transliterationFontSize;
@JsonKey() final  double translationFontSize;

/// Create a copy of MuhudState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.chapter, chapter) || other.chapter == chapter)&&const DeepCollectionEquality().equals(other._verses, _verses)&&const DeepCollectionEquality().equals(other._bookmarkedVerseIds, _bookmarkedVerseIds)&&(identical(other.showTranslation, showTranslation) || other.showTranslation == showTranslation)&&(identical(other.playingVerseId, playingVerseId) || other.playingVerseId == playingVerseId)&&(identical(other.isAudioLoading, isAudioLoading) || other.isAudioLoading == isAudioLoading)&&(identical(other.showArabic, showArabic) || other.showArabic == showArabic)&&(identical(other.showTransliteration, showTransliteration) || other.showTransliteration == showTransliteration)&&(identical(other.arabFontSize, arabFontSize) || other.arabFontSize == arabFontSize)&&(identical(other.transliterationFontSize, transliterationFontSize) || other.transliterationFontSize == transliterationFontSize)&&(identical(other.translationFontSize, translationFontSize) || other.translationFontSize == translationFontSize));
}


@override
int get hashCode => Object.hash(runtimeType,chapter,const DeepCollectionEquality().hash(_verses),const DeepCollectionEquality().hash(_bookmarkedVerseIds),showTranslation,playingVerseId,isAudioLoading,showArabic,showTransliteration,arabFontSize,transliterationFontSize,translationFontSize);

@override
String toString() {
  return 'MuhudState.loaded(chapter: $chapter, verses: $verses, bookmarkedVerseIds: $bookmarkedVerseIds, showTranslation: $showTranslation, playingVerseId: $playingVerseId, isAudioLoading: $isAudioLoading, showArabic: $showArabic, showTransliteration: $showTransliteration, arabFontSize: $arabFontSize, transliterationFontSize: $transliterationFontSize, translationFontSize: $translationFontSize)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $MuhudStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 ChapterEntity chapter, List<VerseWithDetailsEntity> verses, Set<int> bookmarkedVerseIds, bool showTranslation, int? playingVerseId, bool isAudioLoading, bool showArabic, bool showTransliteration, double arabFontSize, double transliterationFontSize, double translationFontSize
});


$ChapterEntityCopyWith<$Res> get chapter;

}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of MuhudState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? chapter = null,Object? verses = null,Object? bookmarkedVerseIds = null,Object? showTranslation = null,Object? playingVerseId = freezed,Object? isAudioLoading = null,Object? showArabic = null,Object? showTransliteration = null,Object? arabFontSize = null,Object? transliterationFontSize = null,Object? translationFontSize = null,}) {
  return _then(_Loaded(
chapter: null == chapter ? _self.chapter : chapter // ignore: cast_nullable_to_non_nullable
as ChapterEntity,verses: null == verses ? _self._verses : verses // ignore: cast_nullable_to_non_nullable
as List<VerseWithDetailsEntity>,bookmarkedVerseIds: null == bookmarkedVerseIds ? _self._bookmarkedVerseIds : bookmarkedVerseIds // ignore: cast_nullable_to_non_nullable
as Set<int>,showTranslation: null == showTranslation ? _self.showTranslation : showTranslation // ignore: cast_nullable_to_non_nullable
as bool,playingVerseId: freezed == playingVerseId ? _self.playingVerseId : playingVerseId // ignore: cast_nullable_to_non_nullable
as int?,isAudioLoading: null == isAudioLoading ? _self.isAudioLoading : isAudioLoading // ignore: cast_nullable_to_non_nullable
as bool,showArabic: null == showArabic ? _self.showArabic : showArabic // ignore: cast_nullable_to_non_nullable
as bool,showTransliteration: null == showTransliteration ? _self.showTransliteration : showTransliteration // ignore: cast_nullable_to_non_nullable
as bool,arabFontSize: null == arabFontSize ? _self.arabFontSize : arabFontSize // ignore: cast_nullable_to_non_nullable
as double,transliterationFontSize: null == transliterationFontSize ? _self.transliterationFontSize : transliterationFontSize // ignore: cast_nullable_to_non_nullable
as double,translationFontSize: null == translationFontSize ? _self.translationFontSize : translationFontSize // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of MuhudState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChapterEntityCopyWith<$Res> get chapter {
  
  return $ChapterEntityCopyWith<$Res>(_self.chapter, (value) {
    return _then(_self.copyWith(chapter: value));
  });
}
}

/// @nodoc


class _Error implements MuhudState {
  const _Error({required this.message});
  

 final  String message;

/// Create a copy of MuhudState
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
  return 'MuhudState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $MuhudStateCopyWith<$Res> {
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

/// Create a copy of MuhudState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
