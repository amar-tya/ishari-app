import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/kitab/data/models/book_model.dart';
import 'package:ishari/features/kitab/data/models/book_page_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class KitabRemoteDataSource {
  Future<List<BookModel>> getAllBooks();
  Future<List<ChapterEntity>> getChaptersByBook(int bookId);
  Future<List<BookPageModel>> getPagesByChapter(int chapterId);
}

@LazySingleton(as: KitabRemoteDataSource)
class KitabRemoteDataSourceImpl implements KitabRemoteDataSource {
  const KitabRemoteDataSourceImpl(this._supabaseClient);

  final SupabaseClient _supabaseClient;

  @override
  Future<List<BookModel>> getAllBooks() async {
    try {
      final data = await _supabaseClient
          .from('books')
          .select()
          .isFilter('deleted_at', null)
          .order('id');
      return data.map(BookModel.fromJson).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ChapterEntity>> getChaptersByBook(int bookId) async {
    try {
      final data = await _supabaseClient
          .from('chapters')
          .select()
          .eq('book_id', bookId)
          .order('chapter_number', ascending: true);
      return (data as List<dynamic>).map((item) {
        final d = item as Map<String, dynamic>;
        final chapterNumber = d['chapter_number'];
        int? number;
        if (chapterNumber != null) {
          number = chapterNumber is int
              ? chapterNumber
              : int.parse(chapterNumber.toString());
        }
        final totalVerses = d['total_verses'];
        var verseCount = 0;
        if (totalVerses != null) {
          verseCount = totalVerses is int
              ? totalVerses
              : int.parse(totalVerses.toString());
        }
        return ChapterEntity(
          id: d['id'].toString(),
          title: d['title'] as String,
          category: d['category'] as String,
          description: (d['description'] as String?) ?? '',
          verseCount: verseCount,
          number: number,
        );
      }).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<BookPageModel>> getPagesByChapter(int chapterId) async {
    try {
      final data = await _supabaseClient
          .from('book_pages')
          .select()
          .eq('chapter_id', chapterId)
          .order('page_number', ascending: true);
      return data.map(BookPageModel.fromJson).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
