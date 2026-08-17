import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/network/network_info.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/kitab/data/datasources/kitab_remote_datasource.dart';
import 'package:ishari/features/kitab/domain/entities/book_entity.dart';
import 'package:ishari/features/kitab/domain/entities/book_page_entity.dart';
import 'package:ishari/features/kitab/domain/repositories/kitab_repository.dart';

@LazySingleton(as: KitabRepository)
class KitabRepositoryImpl implements KitabRepository {
  const KitabRepositoryImpl(this._remote, this._networkInfo);

  final KitabRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, List<BookEntity>>> getAllBooks() async {
    if (!await _networkInfo.isConnected) {
      return left(const NetworkFailure());
    }
    try {
      final models = await _remote.getAllBooks();
      return right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<ChapterEntity>>> getChaptersByBook(
    int bookId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return left(const NetworkFailure());
    }
    try {
      final chapters = await _remote.getChaptersByBook(bookId);
      return right(chapters);
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<BookPageEntity>>> getPagesByChapter(
    int chapterId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return left(const NetworkFailure());
    }
    try {
      final models = await _remote.getPagesByChapter(chapterId);
      return right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }
}
