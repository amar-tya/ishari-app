part of 'kitab_bloc.dart';

@freezed
class KitabState with _$KitabState {
  const factory KitabState.initial() = _Initial;
  const factory KitabState.loading() = _Loading;
  const factory KitabState.loaded(List<BookEntity> books) = _Loaded;
  const factory KitabState.error(String message) = _Error;
}
