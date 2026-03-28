// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bookmark_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BookmarkEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookmarkEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BookmarkEvent()';
}


}

/// @nodoc
class $BookmarkEventCopyWith<$Res>  {
$BookmarkEventCopyWith(BookmarkEvent _, $Res Function(BookmarkEvent) __);
}


/// Adds pattern-matching-related methods to [BookmarkEvent].
extension BookmarkEventPatterns on BookmarkEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Load value)?  load,TResult Function( _FilterChanged value)?  filterChanged,TResult Function( _ToggleSort value)?  toggleSort,TResult Function( _SearchChanged value)?  searchChanged,TResult Function( _RemoveBookmark value)?  removeBookmark,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that);case _FilterChanged() when filterChanged != null:
return filterChanged(_that);case _ToggleSort() when toggleSort != null:
return toggleSort(_that);case _SearchChanged() when searchChanged != null:
return searchChanged(_that);case _RemoveBookmark() when removeBookmark != null:
return removeBookmark(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Load value)  load,required TResult Function( _FilterChanged value)  filterChanged,required TResult Function( _ToggleSort value)  toggleSort,required TResult Function( _SearchChanged value)  searchChanged,required TResult Function( _RemoveBookmark value)  removeBookmark,}){
final _that = this;
switch (_that) {
case _Load():
return load(_that);case _FilterChanged():
return filterChanged(_that);case _ToggleSort():
return toggleSort(_that);case _SearchChanged():
return searchChanged(_that);case _RemoveBookmark():
return removeBookmark(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Load value)?  load,TResult? Function( _FilterChanged value)?  filterChanged,TResult? Function( _ToggleSort value)?  toggleSort,TResult? Function( _SearchChanged value)?  searchChanged,TResult? Function( _RemoveBookmark value)?  removeBookmark,}){
final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that);case _FilterChanged() when filterChanged != null:
return filterChanged(_that);case _ToggleSort() when toggleSort != null:
return toggleSort(_that);case _SearchChanged() when searchChanged != null:
return searchChanged(_that);case _RemoveBookmark() when removeBookmark != null:
return removeBookmark(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String userId)?  load,TResult Function( String category)?  filterChanged,TResult Function()?  toggleSort,TResult Function( String query)?  searchChanged,TResult Function( int verseId,  String userId)?  removeBookmark,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that.userId);case _FilterChanged() when filterChanged != null:
return filterChanged(_that.category);case _ToggleSort() when toggleSort != null:
return toggleSort();case _SearchChanged() when searchChanged != null:
return searchChanged(_that.query);case _RemoveBookmark() when removeBookmark != null:
return removeBookmark(_that.verseId,_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String userId)  load,required TResult Function( String category)  filterChanged,required TResult Function()  toggleSort,required TResult Function( String query)  searchChanged,required TResult Function( int verseId,  String userId)  removeBookmark,}) {final _that = this;
switch (_that) {
case _Load():
return load(_that.userId);case _FilterChanged():
return filterChanged(_that.category);case _ToggleSort():
return toggleSort();case _SearchChanged():
return searchChanged(_that.query);case _RemoveBookmark():
return removeBookmark(_that.verseId,_that.userId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String userId)?  load,TResult? Function( String category)?  filterChanged,TResult? Function()?  toggleSort,TResult? Function( String query)?  searchChanged,TResult? Function( int verseId,  String userId)?  removeBookmark,}) {final _that = this;
switch (_that) {
case _Load() when load != null:
return load(_that.userId);case _FilterChanged() when filterChanged != null:
return filterChanged(_that.category);case _ToggleSort() when toggleSort != null:
return toggleSort();case _SearchChanged() when searchChanged != null:
return searchChanged(_that.query);case _RemoveBookmark() when removeBookmark != null:
return removeBookmark(_that.verseId,_that.userId);case _:
  return null;

}
}

}

/// @nodoc


class _Load implements BookmarkEvent {
  const _Load({required this.userId});
  

 final  String userId;

/// Create a copy of BookmarkEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadCopyWith<_Load> get copyWith => __$LoadCopyWithImpl<_Load>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Load&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,userId);

@override
String toString() {
  return 'BookmarkEvent.load(userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$LoadCopyWith<$Res> implements $BookmarkEventCopyWith<$Res> {
  factory _$LoadCopyWith(_Load value, $Res Function(_Load) _then) = __$LoadCopyWithImpl;
@useResult
$Res call({
 String userId
});




}
/// @nodoc
class __$LoadCopyWithImpl<$Res>
    implements _$LoadCopyWith<$Res> {
  __$LoadCopyWithImpl(this._self, this._then);

  final _Load _self;
  final $Res Function(_Load) _then;

/// Create a copy of BookmarkEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = null,}) {
  return _then(_Load(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _FilterChanged implements BookmarkEvent {
  const _FilterChanged({required this.category});
  

 final  String category;

/// Create a copy of BookmarkEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FilterChangedCopyWith<_FilterChanged> get copyWith => __$FilterChangedCopyWithImpl<_FilterChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FilterChanged&&(identical(other.category, category) || other.category == category));
}


@override
int get hashCode => Object.hash(runtimeType,category);

@override
String toString() {
  return 'BookmarkEvent.filterChanged(category: $category)';
}


}

/// @nodoc
abstract mixin class _$FilterChangedCopyWith<$Res> implements $BookmarkEventCopyWith<$Res> {
  factory _$FilterChangedCopyWith(_FilterChanged value, $Res Function(_FilterChanged) _then) = __$FilterChangedCopyWithImpl;
@useResult
$Res call({
 String category
});




}
/// @nodoc
class __$FilterChangedCopyWithImpl<$Res>
    implements _$FilterChangedCopyWith<$Res> {
  __$FilterChangedCopyWithImpl(this._self, this._then);

  final _FilterChanged _self;
  final $Res Function(_FilterChanged) _then;

/// Create a copy of BookmarkEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? category = null,}) {
  return _then(_FilterChanged(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _ToggleSort implements BookmarkEvent {
  const _ToggleSort();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ToggleSort);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BookmarkEvent.toggleSort()';
}


}




/// @nodoc


class _SearchChanged implements BookmarkEvent {
  const _SearchChanged({required this.query});
  

 final  String query;

/// Create a copy of BookmarkEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchChangedCopyWith<_SearchChanged> get copyWith => __$SearchChangedCopyWithImpl<_SearchChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchChanged&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'BookmarkEvent.searchChanged(query: $query)';
}


}

/// @nodoc
abstract mixin class _$SearchChangedCopyWith<$Res> implements $BookmarkEventCopyWith<$Res> {
  factory _$SearchChangedCopyWith(_SearchChanged value, $Res Function(_SearchChanged) _then) = __$SearchChangedCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class __$SearchChangedCopyWithImpl<$Res>
    implements _$SearchChangedCopyWith<$Res> {
  __$SearchChangedCopyWithImpl(this._self, this._then);

  final _SearchChanged _self;
  final $Res Function(_SearchChanged) _then;

/// Create a copy of BookmarkEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(_SearchChanged(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _RemoveBookmark implements BookmarkEvent {
  const _RemoveBookmark({required this.verseId, required this.userId});
  

 final  int verseId;
 final  String userId;

/// Create a copy of BookmarkEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoveBookmarkCopyWith<_RemoveBookmark> get copyWith => __$RemoveBookmarkCopyWithImpl<_RemoveBookmark>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoveBookmark&&(identical(other.verseId, verseId) || other.verseId == verseId)&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,verseId,userId);

@override
String toString() {
  return 'BookmarkEvent.removeBookmark(verseId: $verseId, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$RemoveBookmarkCopyWith<$Res> implements $BookmarkEventCopyWith<$Res> {
  factory _$RemoveBookmarkCopyWith(_RemoveBookmark value, $Res Function(_RemoveBookmark) _then) = __$RemoveBookmarkCopyWithImpl;
@useResult
$Res call({
 int verseId, String userId
});




}
/// @nodoc
class __$RemoveBookmarkCopyWithImpl<$Res>
    implements _$RemoveBookmarkCopyWith<$Res> {
  __$RemoveBookmarkCopyWithImpl(this._self, this._then);

  final _RemoveBookmark _self;
  final $Res Function(_RemoveBookmark) _then;

/// Create a copy of BookmarkEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? verseId = null,Object? userId = null,}) {
  return _then(_RemoveBookmark(
verseId: null == verseId ? _self.verseId : verseId // ignore: cast_nullable_to_non_nullable
as int,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$BookmarkState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookmarkState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BookmarkState()';
}


}

/// @nodoc
class $BookmarkStateCopyWith<$Res>  {
$BookmarkStateCopyWith(BookmarkState _, $Res Function(BookmarkState) __);
}


/// Adds pattern-matching-related methods to [BookmarkState].
extension BookmarkStatePatterns on BookmarkState {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<BookmarkedVerseEntity> allBookmarks,  List<BookmarkedVerseEntity> filtered,  String selectedCategory,  bool newestFirst,  String searchQuery)?  loaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.allBookmarks,_that.filtered,_that.selectedCategory,_that.newestFirst,_that.searchQuery);case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<BookmarkedVerseEntity> allBookmarks,  List<BookmarkedVerseEntity> filtered,  String selectedCategory,  bool newestFirst,  String searchQuery)  loaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.allBookmarks,_that.filtered,_that.selectedCategory,_that.newestFirst,_that.searchQuery);case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<BookmarkedVerseEntity> allBookmarks,  List<BookmarkedVerseEntity> filtered,  String selectedCategory,  bool newestFirst,  String searchQuery)?  loaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.allBookmarks,_that.filtered,_that.selectedCategory,_that.newestFirst,_that.searchQuery);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements BookmarkState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BookmarkState.initial()';
}


}




/// @nodoc


class _Loading implements BookmarkState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BookmarkState.loading()';
}


}




/// @nodoc


class _Loaded implements BookmarkState {
  const _Loaded({required final  List<BookmarkedVerseEntity> allBookmarks, required final  List<BookmarkedVerseEntity> filtered, required this.selectedCategory, this.newestFirst = true, this.searchQuery = ''}): _allBookmarks = allBookmarks,_filtered = filtered;
  

 final  List<BookmarkedVerseEntity> _allBookmarks;
 List<BookmarkedVerseEntity> get allBookmarks {
  if (_allBookmarks is EqualUnmodifiableListView) return _allBookmarks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allBookmarks);
}

 final  List<BookmarkedVerseEntity> _filtered;
 List<BookmarkedVerseEntity> get filtered {
  if (_filtered is EqualUnmodifiableListView) return _filtered;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filtered);
}

 final  String selectedCategory;
@JsonKey() final  bool newestFirst;
@JsonKey() final  String searchQuery;

/// Create a copy of BookmarkState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._allBookmarks, _allBookmarks)&&const DeepCollectionEquality().equals(other._filtered, _filtered)&&(identical(other.selectedCategory, selectedCategory) || other.selectedCategory == selectedCategory)&&(identical(other.newestFirst, newestFirst) || other.newestFirst == newestFirst)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_allBookmarks),const DeepCollectionEquality().hash(_filtered),selectedCategory,newestFirst,searchQuery);

@override
String toString() {
  return 'BookmarkState.loaded(allBookmarks: $allBookmarks, filtered: $filtered, selectedCategory: $selectedCategory, newestFirst: $newestFirst, searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $BookmarkStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<BookmarkedVerseEntity> allBookmarks, List<BookmarkedVerseEntity> filtered, String selectedCategory, bool newestFirst, String searchQuery
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of BookmarkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? allBookmarks = null,Object? filtered = null,Object? selectedCategory = null,Object? newestFirst = null,Object? searchQuery = null,}) {
  return _then(_Loaded(
allBookmarks: null == allBookmarks ? _self._allBookmarks : allBookmarks // ignore: cast_nullable_to_non_nullable
as List<BookmarkedVerseEntity>,filtered: null == filtered ? _self._filtered : filtered // ignore: cast_nullable_to_non_nullable
as List<BookmarkedVerseEntity>,selectedCategory: null == selectedCategory ? _self.selectedCategory : selectedCategory // ignore: cast_nullable_to_non_nullable
as String,newestFirst: null == newestFirst ? _self.newestFirst : newestFirst // ignore: cast_nullable_to_non_nullable
as bool,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Error implements BookmarkState {
  const _Error({required this.message});
  

 final  String message;

/// Create a copy of BookmarkState
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
  return 'BookmarkState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $BookmarkStateCopyWith<$Res> {
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

/// Create a copy of BookmarkState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
