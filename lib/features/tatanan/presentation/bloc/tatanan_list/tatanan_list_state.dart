part of 'tatanan_list_bloc.dart';

@freezed
sealed class TatananListState with _$TatananListState {
  const factory TatananListState.initial() = _Initial;

  const factory TatananListState.loading() = _Loading;

  const factory TatananListState.loaded({
    required List<TatananEntity> tatanans,
  }) = _Loaded;

  const factory TatananListState.created({
    required String tatananId,
  }) = _Created;

  const factory TatananListState.error({required String message}) = _Error;
}
