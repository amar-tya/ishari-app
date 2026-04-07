part of 'tatanan_detail_bloc.dart';

@freezed
sealed class TatananDetailState with _$TatananDetailState {
  const factory TatananDetailState.initial() = _Initial;

  const factory TatananDetailState.loading() = _Loading;

  const factory TatananDetailState.loaded({
    required TatananEntity tatanan,
    required List<TatananVerseEntity> verses,
    @Default(false) bool isEditMode,
  }) = _Loaded;

  const factory TatananDetailState.error({required String message}) = _Error;
}
