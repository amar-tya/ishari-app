import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/features/tatanan/data/models/tatanan_model.dart';
import 'package:ishari/features/tatanan/data/models/tatanan_verse_model.dart';
import 'package:ishari/features/tatanan/domain/entities/tatanan_entity.dart';
import 'package:ishari/features/tatanan/domain/entities/tatanan_verse_entity.dart';
import 'package:ishari/features/tatanan/domain/repositories/tatanan_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class TatananRemoteDataSource {
  Future<List<TatananEntity>> getTatananList(String userId);
  Future<TatananEntity> getTatananById(String tatananId);
  Future<List<TatananVerseEntity>> getTatananDetail(String tatananId);
  Future<String> createTatanan({
    required String userId,
    required int chapterId,
    required String name,
    String? description,
  });
  Future<void> deleteTatanan(String tatananId);
  Future<void> addVerseToTatanan({
    required String tatananId,
    required int verseId,
    required int position,
  });
  Future<void> removeVerseFromTatanan({
    required String tatananId,
    required int verseId,
  });
  Future<void> reorderTatananVerses({
    required String tatananId,
    required List<VersePositionUpdate> updates,
  });
}

@LazySingleton(as: TatananRemoteDataSource)
class TatananRemoteDataSourceImpl implements TatananRemoteDataSource {
  const TatananRemoteDataSourceImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<List<TatananEntity>> getTatananList(String userId) async {
    try {
      final data = await _client
          .from('tatanan')
          .select('*, chapters!inner(title, category, chapter_number), tatanan_verses(id)')
          .eq('user_id', userId)
          .order('updated_at', ascending: false);

      return (data as List<dynamic>)
          .map(
            (item) =>
                TatananModel.fromJson(item as Map<String, dynamic>).toEntity(),
          )
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<TatananEntity> getTatananById(String tatananId) async {
    try {
      final data = await _client
          .from('tatanan')
          .select('*, chapters!inner(title, category, chapter_number), tatanan_verses(id)')
          .eq('id', tatananId)
          .single();

      return TatananModel.fromJson(data).toEntity();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<TatananVerseEntity>> getTatananDetail(String tatananId) async {
    try {
      final data = await _client
          .from('tatanan_verses')
          .select(
            'id, tatanan_id, verse_id, position, created_at, verses!inner(verse_number, arabic_text, transliteration)',
          )
          .eq('tatanan_id', tatananId)
          .order('position', ascending: true);

      return (data as List<dynamic>)
          .map(
            (item) => TatananVerseModel.fromJson(
              item as Map<String, dynamic>,
            ).toEntity(),
          )
          .toList();
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> createTatanan({
    required String userId,
    required int chapterId,
    required String name,
    String? description,
  }) async {
    try {
      final data = await _client
          .from('tatanan')
          .insert({
            'user_id': userId,
            'chapter_id': chapterId,
            'name': name,
            if (description != null) 'description': description,
          })
          .select('id')
          .single();

      return (data)['id'] as String;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteTatanan(String tatananId) async {
    try {
      await _client.from('tatanan').delete().eq('id', tatananId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> addVerseToTatanan({
    required String tatananId,
    required int verseId,
    required int position,
  }) async {
    try {
      await _client.from('tatanan_verses').insert({
        'tatanan_id': tatananId,
        'verse_id': verseId,
        'position': position,
      });
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> removeVerseFromTatanan({
    required String tatananId,
    required int verseId,
  }) async {
    try {
      await _client
          .from('tatanan_verses')
          .delete()
          .eq('tatanan_id', tatananId)
          .eq('verse_id', verseId);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> reorderTatananVerses({
    required String tatananId,
    required List<VersePositionUpdate> updates,
  }) async {
    try {
      await Future.wait(
        updates.map(
          (u) => _client
              .from('tatanan_verses')
              .update({'position': u.position})
              .eq('tatanan_id', tatananId)
              .eq('verse_id', u.verseId),
        ),
      );
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
