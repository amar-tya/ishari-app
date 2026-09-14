import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/features/hadi/data/models/hadi_audio_model.dart';
import 'package:ishari/features/hadi/data/models/hadi_summary_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class HadiRemoteDataSource {
  Future<List<HadiSummaryModel>> getAllHadi();
  Future<List<HadiAudioModel>> getAllHadiAudio();
}

@LazySingleton(as: HadiRemoteDataSource)
class HadiRemoteDataSourceImpl implements HadiRemoteDataSource {
  const HadiRemoteDataSourceImpl(this._supabaseClient);

  final SupabaseClient _supabaseClient;

  @override
  Future<List<HadiSummaryModel>> getAllHadi() async {
    try {
      final data = await _supabaseClient.from('hadi').select();
      return (data as List<dynamic>)
          .map(
            (item) => HadiSummaryModel.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<HadiAudioModel>> getAllHadiAudio() async {
    try {
      final data = await _supabaseClient
          .from('verse_media')
          .select('*, verses(verse_number, arabic_text, chapters(title))')
          .eq('media_type', 'audio')
          .isFilter('deleted_at', null);
      return (data as List<dynamic>)
          .map((item) => HadiAudioModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
