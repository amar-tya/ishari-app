import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/features/audio/data/models/audio_track_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AudioRemoteDataSource {
  Future<List<AudioTrackModel>> getAllAudioTracks();
}

/// The Audio catalog reads only from `chapter_media` — `verse_media` is a
/// separate data source that belongs to the per-Hadi audio tab
/// (`HadiDetailPage`), not this global catalog.
@LazySingleton(as: AudioRemoteDataSource)
class AudioRemoteDataSourceImpl implements AudioRemoteDataSource {
  const AudioRemoteDataSourceImpl(this._supabaseClient);

  final SupabaseClient _supabaseClient;

  @override
  Future<List<AudioTrackModel>> getAllAudioTracks() async {
    try {
      final data = await _supabaseClient
          .from('chapter_media')
          .select('*, hadi(name), chapters(title)')
          .isFilter('deleted_at', null);
      return (data as List<dynamic>)
          .map(
            (item) => AudioTrackModel.fromChapterMediaJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
