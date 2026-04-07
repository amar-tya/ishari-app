import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/features/kitab/data/models/book_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class KitabRemoteDataSource {
  Future<List<BookModel>> getAllBooks();
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
}
