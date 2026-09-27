import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_track_entity.freezed.dart';

/// One audio track from `chapter_media` (joined to `hadi` and `chapters`).
///
/// [title] is the chapter's title — in this app's own terminology that's
/// what the "Muhud" filter section means (filter by which chapter a track
/// belongs to), NOT the DB `chapters.category` enum value (which is a
/// separate, mostly-unrelated column and is not read here at all).
///
/// [hadiName] and [rodadCabang] are independent, optional facets — a track
/// can have both, one, or neither at the same time (e.g. a specific hadi's
/// recording of a specific rodad_cabang branch). The filter sheet's 3
/// sections (Hadi / Muhud / Rodad Cabang) each match against a different
/// facet — [title] for Muhud, [hadiName] for Hadi, [rodadCabang] for Rodad
/// Cabang — independently of one another.
@freezed
abstract class AudioTrackEntity with _$AudioTrackEntity {
  const factory AudioTrackEntity({
    required String id,
    required String title,
    required String mediaUrl,
    required DateTime createdAt,
    String? hadiName,
    String? rodadCabang,
    int? duration,
    String? description,
  }) = _AudioTrackEntity;

  const AudioTrackEntity._();

  /// Joins whichever facets this track actually has (Hadi name and/or Rodad
  /// Cabang branch) — a track can carry both at once. Chapter title (the
  /// "Muhud" facet) is already shown as the row's own bold title elsewhere,
  /// so it's not repeated here.
  String get facetSubtitle {
    final facets = <String>[?hadiName, ?rodadCabang];
    return facets.join(' · ');
  }
}
