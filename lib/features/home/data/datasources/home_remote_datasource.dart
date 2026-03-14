import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/features/home/data/models/chapter_model.dart';
import 'package:ishari/features/home/data/models/hadi_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class HomeRemoteDataSource {
  Future<ChapterModel> getFeaturedChapter(String? lastChapterId);
  Future<List<ChapterModel>> getChaptersByCategory(String category);
  Future<List<HadiModel>> getHadiList();
}

@LazySingleton(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl(this._supabaseClient);

  final SupabaseClient _supabaseClient;

  @override
  Future<ChapterModel> getFeaturedChapter(String? lastChapterId) async {
    try {
      final Map<String, dynamic> data;
      if (lastChapterId != null) {
        data = await _supabaseClient
            .from('chapters')
            .select()
            .eq('id', lastChapterId)
            .single();
      } else {
        data = await _supabaseClient
            .from('chapters')
            .select()
            .eq('category', 'Diwan')
            .order('chapter_number')
            .limit(1)
            .single();
      }
      return ChapterModel.fromJson(data);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ChapterModel>> getChaptersByCategory(String category) async {
    try {
      final data = await _supabaseClient
          .from('chapters')
          .select()
          .eq('category', category)
          .order('chapter_number');
      return data.map(ChapterModel.fromJson).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<HadiModel>> getHadiList() async {
    try {
      final data = await _supabaseClient.from('hadi').select();
      return data.map(HadiModel.fromJson).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
