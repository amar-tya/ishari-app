part of 'kitab_bloc.dart';

@freezed
class KitabEvent with _$KitabEvent {
  const factory KitabEvent.load() = _Load;
  const factory KitabEvent.refresh() = _Refresh;
}
