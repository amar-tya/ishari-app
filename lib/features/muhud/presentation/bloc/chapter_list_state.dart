import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';

part 'chapter_list_state.freezed.dart';

@freezed
sealed class ChapterListState with _$ChapterListState {
  const factory ChapterListState.initial() = _Initial;
  const factory ChapterListState.loading() = _Loading;
  const factory ChapterListState.loaded(List<ChapterEntity> chapters) = _Loaded;
  const factory ChapterListState.error(String message) = _Error;
}
