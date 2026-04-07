import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/network/network_info.dart';
import 'package:ishari/features/home/data/datasources/home_remote_datasource.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/home/domain/entities/hadi_entity.dart';
import 'package:ishari/features/home/domain/repositories/home_repository.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(this._remote, this._networkInfo);

  final HomeRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, ChapterEntity>> getFeaturedChapter(
    String? lastChapterId,
  ) async {
    if (!await _networkInfo.isConnected) {
      return left(const NetworkFailure());
    }
    try {
      final model = await _remote.getFeaturedChapter(lastChapterId);
      return right(model.toEntity());
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<ChapterEntity>>> getChaptersByCategory(
    String category,
  ) async {
    if (!await _networkInfo.isConnected) {
      return left(const NetworkFailure());
    }
    try {
      final models = await _remote.getChaptersByCategory(category);
      return right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, List<HadiEntity>>> getHadiList() async {
    if (!await _networkInfo.isConnected) {
      return left(const NetworkFailure());
    }
    try {
      final models = await _remote.getHadiList();
      return right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }
}
