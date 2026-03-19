import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter_list_event.freezed.dart';

@freezed
sealed class ChapterListEvent with _$ChapterListEvent {
  const factory ChapterListEvent.load() = _Load;
}
