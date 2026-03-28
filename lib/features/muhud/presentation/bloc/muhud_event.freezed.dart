// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'muhud_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MuhudEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MuhudEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MuhudEvent()';
}


}

/// @nodoc
class $MuhudEventCopyWith<$Res>  {
$MuhudEventCopyWith(MuhudEvent _, $Res Function(MuhudEvent) __);
}


/// Adds pattern-matching-related methods to [MuhudEvent].
extension MuhudEventPatterns on MuhudEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _LoadChapter value)?  loadChapter,TResult Function( _ToggleTranslation value)?  toggleTranslation,TResult Function( _ToggleBookmark value)?  toggleBookmark,TResult Function( _PlayVerse value)?  playVerse,TResult Function( _StopAudio value)?  stopAudio,TResult Function( _ToggleArabic value)?  toggleArabic,TResult Function( _ToggleTransliteration value)?  toggleTransliteration,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoadChapter() when loadChapter != null:
return loadChapter(_that);case _ToggleTranslation() when toggleTranslation != null:
return toggleTranslation(_that);case _ToggleBookmark() when toggleBookmark != null:
return toggleBookmark(_that);case _PlayVerse() when playVerse != null:
return playVerse(_that);case _StopAudio() when stopAudio != null:
return stopAudio(_that);case _ToggleArabic() when toggleArabic != null:
return toggleArabic(_that);case _ToggleTransliteration() when toggleTransliteration != null:
return toggleTransliteration(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _LoadChapter value)  loadChapter,required TResult Function( _ToggleTranslation value)  toggleTranslation,required TResult Function( _ToggleBookmark value)  toggleBookmark,required TResult Function( _PlayVerse value)  playVerse,required TResult Function( _StopAudio value)  stopAudio,required TResult Function( _ToggleArabic value)  toggleArabic,required TResult Function( _ToggleTransliteration value)  toggleTransliteration,}){
final _that = this;
switch (_that) {
case _LoadChapter():
return loadChapter(_that);case _ToggleTranslation():
return toggleTranslation(_that);case _ToggleBookmark():
return toggleBookmark(_that);case _PlayVerse():
return playVerse(_that);case _StopAudio():
return stopAudio(_that);case _ToggleArabic():
return toggleArabic(_that);case _ToggleTransliteration():
return toggleTransliteration(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _LoadChapter value)?  loadChapter,TResult? Function( _ToggleTranslation value)?  toggleTranslation,TResult? Function( _ToggleBookmark value)?  toggleBookmark,TResult? Function( _PlayVerse value)?  playVerse,TResult? Function( _StopAudio value)?  stopAudio,TResult? Function( _ToggleArabic value)?  toggleArabic,TResult? Function( _ToggleTransliteration value)?  toggleTransliteration,}){
final _that = this;
switch (_that) {
case _LoadChapter() when loadChapter != null:
return loadChapter(_that);case _ToggleTranslation() when toggleTranslation != null:
return toggleTranslation(_that);case _ToggleBookmark() when toggleBookmark != null:
return toggleBookmark(_that);case _PlayVerse() when playVerse != null:
return playVerse(_that);case _StopAudio() when stopAudio != null:
return stopAudio(_that);case _ToggleArabic() when toggleArabic != null:
return toggleArabic(_that);case _ToggleTransliteration() when toggleTransliteration != null:
return toggleTransliteration(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int chapterId)?  loadChapter,TResult Function()?  toggleTranslation,TResult Function( int verseId)?  toggleBookmark,TResult Function( int verseId,  String hadiId,  VerseMediaType recitationType,  int mediaId)?  playVerse,TResult Function()?  stopAudio,TResult Function()?  toggleArabic,TResult Function()?  toggleTransliteration,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoadChapter() when loadChapter != null:
return loadChapter(_that.chapterId);case _ToggleTranslation() when toggleTranslation != null:
return toggleTranslation();case _ToggleBookmark() when toggleBookmark != null:
return toggleBookmark(_that.verseId);case _PlayVerse() when playVerse != null:
return playVerse(_that.verseId,_that.hadiId,_that.recitationType,_that.mediaId);case _StopAudio() when stopAudio != null:
return stopAudio();case _ToggleArabic() when toggleArabic != null:
return toggleArabic();case _ToggleTransliteration() when toggleTransliteration != null:
return toggleTransliteration();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int chapterId)  loadChapter,required TResult Function()  toggleTranslation,required TResult Function( int verseId)  toggleBookmark,required TResult Function( int verseId,  String hadiId,  VerseMediaType recitationType,  int mediaId)  playVerse,required TResult Function()  stopAudio,required TResult Function()  toggleArabic,required TResult Function()  toggleTransliteration,}) {final _that = this;
switch (_that) {
case _LoadChapter():
return loadChapter(_that.chapterId);case _ToggleTranslation():
return toggleTranslation();case _ToggleBookmark():
return toggleBookmark(_that.verseId);case _PlayVerse():
return playVerse(_that.verseId,_that.hadiId,_that.recitationType,_that.mediaId);case _StopAudio():
return stopAudio();case _ToggleArabic():
return toggleArabic();case _ToggleTransliteration():
return toggleTransliteration();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int chapterId)?  loadChapter,TResult? Function()?  toggleTranslation,TResult? Function( int verseId)?  toggleBookmark,TResult? Function( int verseId,  String hadiId,  VerseMediaType recitationType,  int mediaId)?  playVerse,TResult? Function()?  stopAudio,TResult? Function()?  toggleArabic,TResult? Function()?  toggleTransliteration,}) {final _that = this;
switch (_that) {
case _LoadChapter() when loadChapter != null:
return loadChapter(_that.chapterId);case _ToggleTranslation() when toggleTranslation != null:
return toggleTranslation();case _ToggleBookmark() when toggleBookmark != null:
return toggleBookmark(_that.verseId);case _PlayVerse() when playVerse != null:
return playVerse(_that.verseId,_that.hadiId,_that.recitationType,_that.mediaId);case _StopAudio() when stopAudio != null:
return stopAudio();case _ToggleArabic() when toggleArabic != null:
return toggleArabic();case _ToggleTransliteration() when toggleTransliteration != null:
return toggleTransliteration();case _:
  return null;

}
}

}

/// @nodoc


class _LoadChapter implements MuhudEvent {
  const _LoadChapter({required this.chapterId});
  

 final  int chapterId;

/// Create a copy of MuhudEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadChapterCopyWith<_LoadChapter> get copyWith => __$LoadChapterCopyWithImpl<_LoadChapter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadChapter&&(identical(other.chapterId, chapterId) || other.chapterId == chapterId));
}


@override
int get hashCode => Object.hash(runtimeType,chapterId);

@override
String toString() {
  return 'MuhudEvent.loadChapter(chapterId: $chapterId)';
}


}

/// @nodoc
abstract mixin class _$LoadChapterCopyWith<$Res> implements $MuhudEventCopyWith<$Res> {
  factory _$LoadChapterCopyWith(_LoadChapter value, $Res Function(_LoadChapter) _then) = __$LoadChapterCopyWithImpl;
@useResult
$Res call({
 int chapterId
});




}
/// @nodoc
class __$LoadChapterCopyWithImpl<$Res>
    implements _$LoadChapterCopyWith<$Res> {
  __$LoadChapterCopyWithImpl(this._self, this._then);

  final _LoadChapter _self;
  final $Res Function(_LoadChapter) _then;

/// Create a copy of MuhudEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? chapterId = null,}) {
  return _then(_LoadChapter(
chapterId: null == chapterId ? _self.chapterId : chapterId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _ToggleTranslation implements MuhudEvent {
  const _ToggleTranslation();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToggleTranslation);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MuhudEvent.toggleTranslation()';
}


}




/// @nodoc


class _ToggleBookmark implements MuhudEvent {
  const _ToggleBookmark({required this.verseId});
  

 final  int verseId;

/// Create a copy of MuhudEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ToggleBookmarkCopyWith<_ToggleBookmark> get copyWith => __$ToggleBookmarkCopyWithImpl<_ToggleBookmark>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToggleBookmark&&(identical(other.verseId, verseId) || other.verseId == verseId));
}


@override
int get hashCode => Object.hash(runtimeType,verseId);

@override
String toString() {
  return 'MuhudEvent.toggleBookmark(verseId: $verseId)';
}


}

/// @nodoc
abstract mixin class _$ToggleBookmarkCopyWith<$Res> implements $MuhudEventCopyWith<$Res> {
  factory _$ToggleBookmarkCopyWith(_ToggleBookmark value, $Res Function(_ToggleBookmark) _then) = __$ToggleBookmarkCopyWithImpl;
@useResult
$Res call({
 int verseId
});




}
/// @nodoc
class __$ToggleBookmarkCopyWithImpl<$Res>
    implements _$ToggleBookmarkCopyWith<$Res> {
  __$ToggleBookmarkCopyWithImpl(this._self, this._then);

  final _ToggleBookmark _self;
  final $Res Function(_ToggleBookmark) _then;

/// Create a copy of MuhudEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? verseId = null,}) {
  return _then(_ToggleBookmark(
verseId: null == verseId ? _self.verseId : verseId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _PlayVerse implements MuhudEvent {
  const _PlayVerse({required this.verseId, required this.hadiId, required this.recitationType, required this.mediaId});
  

 final  int verseId;
 final  String hadiId;
 final  VerseMediaType recitationType;
 final  int mediaId;

/// Create a copy of MuhudEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayVerseCopyWith<_PlayVerse> get copyWith => __$PlayVerseCopyWithImpl<_PlayVerse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayVerse&&(identical(other.verseId, verseId) || other.verseId == verseId)&&(identical(other.hadiId, hadiId) || other.hadiId == hadiId)&&(identical(other.recitationType, recitationType) || other.recitationType == recitationType)&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId));
}


@override
int get hashCode => Object.hash(runtimeType,verseId,hadiId,recitationType,mediaId);

@override
String toString() {
  return 'MuhudEvent.playVerse(verseId: $verseId, hadiId: $hadiId, recitationType: $recitationType, mediaId: $mediaId)';
}


}

/// @nodoc
abstract mixin class _$PlayVerseCopyWith<$Res> implements $MuhudEventCopyWith<$Res> {
  factory _$PlayVerseCopyWith(_PlayVerse value, $Res Function(_PlayVerse) _then) = __$PlayVerseCopyWithImpl;
@useResult
$Res call({
 int verseId, String hadiId, VerseMediaType recitationType, int mediaId
});




}
/// @nodoc
class __$PlayVerseCopyWithImpl<$Res>
    implements _$PlayVerseCopyWith<$Res> {
  __$PlayVerseCopyWithImpl(this._self, this._then);

  final _PlayVerse _self;
  final $Res Function(_PlayVerse) _then;

/// Create a copy of MuhudEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? verseId = null,Object? hadiId = null,Object? recitationType = null,Object? mediaId = null,}) {
  return _then(_PlayVerse(
verseId: null == verseId ? _self.verseId : verseId // ignore: cast_nullable_to_non_nullable
as int,hadiId: null == hadiId ? _self.hadiId : hadiId // ignore: cast_nullable_to_non_nullable
as String,recitationType: null == recitationType ? _self.recitationType : recitationType // ignore: cast_nullable_to_non_nullable
as VerseMediaType,mediaId: null == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _StopAudio implements MuhudEvent {
  const _StopAudio();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StopAudio);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MuhudEvent.stopAudio()';
}


}




/// @nodoc


class _ToggleArabic implements MuhudEvent {
  const _ToggleArabic();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToggleArabic);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MuhudEvent.toggleArabic()';
}


}




/// @nodoc


class _ToggleTransliteration implements MuhudEvent {
  const _ToggleTransliteration();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToggleTransliteration);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'MuhudEvent.toggleTransliteration()';
}


}




// dart format on
