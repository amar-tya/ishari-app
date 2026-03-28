import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/network/network_info.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/muhud/data/datasources/muhud_remote_datasource.dart';
import 'package:ishari/features/muhud/domain/entities/bookmarked_verse_entity.dart';
import 'package:ishari/features/muhud/domain/entities/verse_with_details_entity.dart';
import 'package:ishari/features/muhud/domain/repositories/muhud_repository.dart';

@LazySingleton(as: MuhudRepository)
class MuhudRepositoryImpl implements MuhudRepository {
  const MuhudRepositoryImpl(this._remote, this._networkInfo);

  final MuhudRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, List<ChapterEntity>>> getAllChapters() async {
    if (!await _networkInfo.isConnected) {
      return left(const NetworkFailure());
    }
    try {
      final result = await _remote.getAllChapters();
      return right(result);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, ChapterEntity>> getChapterById(int chapterId) async {
    if (!await _networkInfo.isConnected) {
      return left(const NetworkFailure());
    }
    try {
      final result = await _remote.getChapterById(chapterId);
      return right(result);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<VerseWithDetailsEntity>>> getVersesByChapter(
    int chapterId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return left(const NetworkFailure());
    }
    try {
      final models = await _remote.getVersesByChapter(chapterId);
      return right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleBookmark(
    int verseId,
    String userId, {
    String? note,
  }) async {
    if (!await _networkInfo.isConnected) {
      return left(const NetworkFailure());
    }
    try {
      final result = await _remote.toggleBookmark(verseId, userId, note: note);
      return right(result);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<int>>> getBookmarkedVerseIds(
    String userId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return left(const NetworkFailure());
    }
    try {
      final result = await _remote.getBookmarkedVerseIds(userId);
      return right(result);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<BookmarkedVerseEntity>>> getBookmarkedVerses(
    String userId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return left(const NetworkFailure());
    }
    try {
      final result = await _remote.getBookmarkedVerses(userId);
      return right(result);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }
}
