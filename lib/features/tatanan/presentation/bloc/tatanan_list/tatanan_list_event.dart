part of 'tatanan_list_bloc.dart';

@freezed
sealed class TatananListEvent with _$TatananListEvent {
  const factory TatananListEvent.load({required String userId}) = _Load;

  const factory TatananListEvent.create({
    required String userId,
    required int chapterId,
    required String name,
    String? description,
  }) = _Create;

  const factory TatananListEvent.delete({
    required String tatananId,
  }) = _Delete;
}
