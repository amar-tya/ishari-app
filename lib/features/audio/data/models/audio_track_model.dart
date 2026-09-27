import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ishari/features/audio/domain/entities/audio_track_entity.dart';

part 'audio_track_model.freezed.dart';

int _toInt(dynamic v) => v is int ? v : int.parse(v.toString());

@freezed
abstract class AudioTrackModel with _$AudioTrackModel {
  const factory AudioTrackModel({
    required String id,
    required String title,
    required String mediaUrl,
    required DateTime createdAt,
    String? hadiName,
    String? rodadCabang,
    int? duration,
    String? description,
  }) = _AudioTrackModel;

  const AudioTrackModel._();

  /// Built from a `chapter_media` row joined with `hadi(name), chapters
  /// (title)`. This is the Audio catalog's only data source — `verse_media`
  /// belongs to the per-Hadi audio tab (`HadiDetailPage`), not this catalog.
  ///
  /// `title` (the chapter's title) drives the "Muhud" filter section in
  /// this app's own terminology (filter by chapter) — it is NOT gated by
  /// `chapters.category`, which is a separate, unrelated column not read
  /// here. `hadiName` and `rodadCabang` are independent, optional facets
  /// read straight off the row/joins — a row can carry both, one, or
  /// neither at once.
  factory AudioTrackModel.fromChapterMediaJson(Map<String, dynamic> json) {
    final hadi = json['hadi'] as Map<String, dynamic>?;
    final chapter = json['chapters'] as Map<String, dynamic>;
    final rodadCabang = json['rodad_cabang'] as String?;
    return AudioTrackModel(
      id: _toInt(json['id']).toString(),
      title: chapter['title'] as String,
      hadiName: hadi?['name'] as String?,
      rodadCabang: (rodadCabang != null && rodadCabang.isNotEmpty)
          ? rodadCabang
          : null,
      mediaUrl: json['media_url'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      duration: json['duration'] == null ? null : _toInt(json['duration']),
      description: json['description'] as String?,
    );
  }

  AudioTrackEntity toEntity() => AudioTrackEntity(
    id: id,
    title: title,
    mediaUrl: mediaUrl,
    createdAt: createdAt,
    hadiName: hadiName,
    rodadCabang: rodadCabang,
    duration: duration,
    description: description,
  );
}
