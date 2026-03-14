part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.loading() = _Loading;
  const factory HomeState.loaded({
    required ChapterEntity featuredChapter,
    required List<ChapterEntity> chapters,
    required String selectedCategory,
    required List<HadiEntity> hadiList,
  }) = _Loaded;
  const factory HomeState.error(String message) = _Error;
}
