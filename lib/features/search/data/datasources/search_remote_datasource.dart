import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/features/home/data/models/chapter_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class SearchRemoteDataSource {
  /// Search chapters whose title contains [query] (case-insensitive),
  /// optionally filtered to a single [category].
  ///
  /// Pass `'Semua'` for [category] to skip the category filter.
  Future<List<ChapterModel>> searchChapters({
    required String query,
    required String category,
  });
}

@LazySingleton(as: SearchRemoteDataSource)
class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  const SearchRemoteDataSourceImpl(this._supabaseClient);

  final SupabaseClient _supabaseClient;

  @override
  Future<List<ChapterModel>> searchChapters({
    required String query,
    required String category,
  }) async {
    try {
      var q = _supabaseClient
          .from('chapters')
          .select()
          .ilike('title', '%$query%');

      if (category != 'Semua') {
        q = q.eq('category', category);
      }

      final data = await q.order('chapter_number', ascending: true);
      return data.map(ChapterModel.fromJson).toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
