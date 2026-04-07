import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/tatanan/domain/entities/tatanan_entity.dart';
import 'package:ishari/features/tatanan/domain/entities/tatanan_verse_entity.dart';

class VersePositionUpdate {
  const VersePositionUpdate({required this.verseId, required this.position});

  final int verseId;
  final int position;
}

abstract interface class TatananRepository {
  Future<Either<Failure, List<TatananEntity>>> getTatananList(String userId);

  Future<Either<Failure, TatananEntity>> getTatananById(String tatananId);

  Future<Either<Failure, List<TatananVerseEntity>>> getTatananDetail(
    String tatananId,
  );

  Future<Either<Failure, String>> createTatanan({
    required String userId,
    required int chapterId,
    required String name,
    String? description,
  });

  Future<Either<Failure, void>> deleteTatanan(String tatananId);

  Future<Either<Failure, void>> addVerseToTatanan({
    required String tatananId,
    required int verseId,
    required int position,
  });

  Future<Either<Failure, void>> removeVerseFromTatanan({
    required String tatananId,
    required int verseId,
  });

  Future<Either<Failure, void>> reorderTatananVerses({
    required String tatananId,
    required List<VersePositionUpdate> updates,
  });
}
