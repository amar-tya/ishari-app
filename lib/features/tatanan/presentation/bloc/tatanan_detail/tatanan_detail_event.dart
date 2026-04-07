part of 'tatanan_detail_bloc.dart';

@freezed
sealed class TatananDetailEvent with _$TatananDetailEvent {
  const factory TatananDetailEvent.load({required String tatananId}) = _Load;

  const factory TatananDetailEvent.toggleEditMode() = _ToggleEditMode;

  const factory TatananDetailEvent.addVerses({
    required String tatananId,
    required List<int> verseIds,
  }) = _AddVerses;

  const factory TatananDetailEvent.removeVerse({
    required String tatananId,
    required int verseId,
  }) = _RemoveVerse;

  const factory TatananDetailEvent.reorder({
    required String tatananId,
    required List<VersePositionUpdate> updates,
  }) = _Reorder;
}
