import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/network/network_info.dart';
import 'package:ishari/features/tatanan/data/datasources/tatanan_remote_datasource.dart';
import 'package:ishari/features/tatanan/domain/entities/tatanan_entity.dart';
import 'package:ishari/features/tatanan/domain/entities/tatanan_verse_entity.dart';
import 'package:ishari/features/tatanan/domain/repositories/tatanan_repository.dart';

@LazySingleton(as: TatananRepository)
class TatananRepositoryImpl implements TatananRepository {
  const TatananRepositoryImpl(this._remote, this._networkInfo);

  final TatananRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, List<TatananEntity>>> getTatananList(
    String userId,
  ) async {
    if (!await _networkInfo.isConnected) return left(const NetworkFailure());
    try {
      return right(await _remote.getTatananList(userId));
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, TatananEntity>> getTatananById(
    String tatananId,
  ) async {
    if (!await _networkInfo.isConnected) return left(const NetworkFailure());
    try {
      return right(await _remote.getTatananById(tatananId));
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<TatananVerseEntity>>> getTatananDetail(
    String tatananId,
  ) async {
    if (!await _networkInfo.isConnected) return left(const NetworkFailure());
    try {
      return right(await _remote.getTatananDetail(tatananId));
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, String>> createTatanan({
    required String userId,
    required int chapterId,
    required String name,
    String? description,
  }) async {
    if (!await _networkInfo.isConnected) return left(const NetworkFailure());
    try {
      final id = await _remote.createTatanan(
        userId: userId,
        chapterId: chapterId,
        name: name,
        description: description,
      );
      return right(id);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTatanan(String tatananId) async {
    if (!await _networkInfo.isConnected) return left(const NetworkFailure());
    try {
      await _remote.deleteTatanan(tatananId);
      return right(null);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> addVerseToTatanan({
    required String tatananId,
    required int verseId,
    required int position,
  }) async {
    if (!await _networkInfo.isConnected) return left(const NetworkFailure());
    try {
      await _remote.addVerseToTatanan(
        tatananId: tatananId,
        verseId: verseId,
        position: position,
      );
      return right(null);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> removeVerseFromTatanan({
    required String tatananId,
    required int verseId,
  }) async {
    if (!await _networkInfo.isConnected) return left(const NetworkFailure());
    try {
      await _remote.removeVerseFromTatanan(
        tatananId: tatananId,
        verseId: verseId,
      );
      return right(null);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, void>> reorderTatananVerses({
    required String tatananId,
    required List<VersePositionUpdate> updates,
  }) async {
    if (!await _networkInfo.isConnected) return left(const NetworkFailure());
    try {
      await _remote.reorderTatananVerses(
        tatananId: tatananId,
        updates: updates,
      );
      return right(null);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }
}
