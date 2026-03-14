import 'package:flutter/rendering.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/muhud/data/models/translation_model.dart';
import 'package:ishari/features/muhud/data/models/verse_media_model.dart';
import 'package:ishari/features/muhud/data/models/verse_model.dart';
import 'package:ishari/features/muhud/data/models/verse_with_details_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class MuhudRemoteDataSource {
  Future<ChapterEntity> getChapterById(int chapterId);
  Future<List<VerseWithDetailsModel>> getVersesByChapter(int chapterId);
  Future<bool> toggleBookmark(int verseId, String userId);
  Future<List<int>> getBookmarkedVerseIds(String userId);
}

@LazySingleton(as: MuhudRemoteDataSource)
class MuhudRemoteDataSourceImpl implements MuhudRemoteDataSource {
  const MuhudRemoteDataSourceImpl(this._supabaseClient);

  final SupabaseClient _supabaseClient;

  @override
  Future<ChapterEntity> getChapterById(int chapterId) async {
    try {
      debugPrint('[RemoteDataSource] getChapterById START - chapterId: $chapterId');
      final data = await _supabaseClient
          .from('chapters')
          .select()
          .eq('id', chapterId)
          .single();
      debugPrint('[RemoteDataSource] Chapter data received: ${data['title']}');
      final chapterNumber = data['chapter_number'];
      int? number;
      if (chapterNumber != null) {
        number = chapterNumber is int ? chapterNumber : int.parse(chapterNumber.toString());
      }
      final totalVerses = data['total_verses'];
      int verseCount = 0;
      if (totalVerses != null) {
        verseCount = totalVerses is int ? totalVerses : int.parse(totalVerses.toString());
      }
      final result = ChapterEntity(
        id: data['id'].toString(),
        title: data['title'] as String,
        category: data['category'] as String,
        description: (data['description'] as String?) ?? '',
        verseCount: verseCount,
        number: number,
      );
      debugPrint('[RemoteDataSource] getChapterById SUCCESS');
      return result;
    } catch (e) {
      debugPrint('[RemoteDataSource] getChapterById ERROR: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<VerseWithDetailsModel>> getVersesByChapter(int chapterId) async {
    try {
      debugPrint('[RemoteDataSource] getVersesByChapter START - chapterId: $chapterId');
      final data = await _supabaseClient
          .from('verses')
          .select('*, translations(*), verse_media(*, hadi(*))')
          .eq('chapter_id', chapterId)
          .order('verse_number', ascending: true);

      debugPrint('[RemoteDataSource] Verses data received: ${(data as List<dynamic>).length} verses');

      final result = (data as List<dynamic>)
          .map((item) {
            final itemMap = item as Map<String, dynamic>;
            final verse = VerseModel.fromJson(itemMap);

            final translationsList =
                (itemMap['translations'] ?? <dynamic>[]) as List<dynamic>;
            final translations = translationsList
                .map((t) => _createTranslationModel(t as Map<String, dynamic>))
                .toList();

            final mediaList =
                (itemMap['verse_media'] ?? <dynamic>[]) as List<dynamic>;
            final media = mediaList
                .map((m) => _createVerseMediaModel(m as Map<String, dynamic>))
                .toList();

            return VerseWithDetailsModel(
              verse: verse,
              translations: translations,
              mediaList: media,
            );
          })
          .toList();
      debugPrint('[RemoteDataSource] getVersesByChapter SUCCESS - parsed ${result.length} verses');
      return result;
    } catch (e, stackTrace) {
      debugPrint('[RemoteDataSource] getVersesByChapter ERROR: $e');
      debugPrint('[RemoteDataSource] StackTrace: $stackTrace');
      throw ServerException(message: e.toString());
    }
  }

  // Helper method to create TranslationModel with proper JSON parsing
  static TranslationModel _createTranslationModel(Map<String, dynamic> json) {
    return TranslationModel.fromJson(json);
  }

  // Helper method to create VerseMediaModel with proper JSON parsing
  static VerseMediaModel _createVerseMediaModel(Map<String, dynamic> json) {
    return VerseMediaModel.fromJson(json);
  }

  @override
  Future<bool> toggleBookmark(int verseId, String userId) async {
    try {
      // Check if bookmark exists
      final existing = await _supabaseClient
          .from('bookmarks')
          .select()
          .eq('verse_id', verseId)
          .eq('user_id', userId);

      if ((existing as List<dynamic>).isNotEmpty) {
        // Delete bookmark
        await _supabaseClient
            .from('bookmarks')
            .delete()
            .eq('verse_id', verseId)
            .eq('user_id', userId);
        return false;
      } else {
        // Create bookmark
        await _supabaseClient.from('bookmarks').insert({
          'verse_id': verseId,
          'user_id': userId,
        });
        return true;
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<int>> getBookmarkedVerseIds(String userId) async {
    try {
      final data = await _supabaseClient
          .from('bookmarks')
          .select('verse_id')
          .eq('user_id', userId);

      return (data as List<dynamic>)
          .map((item) {
            final verseId = (item as Map<String, dynamic>)['verse_id'];
            return verseId is int ? verseId : int.parse(verseId.toString());
          })
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
