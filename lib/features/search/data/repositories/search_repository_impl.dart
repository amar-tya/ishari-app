import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/network/network_info.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/search/data/datasources/search_remote_datasource.dart';
import 'package:ishari/features/search/domain/repositories/search_repository.dart';

@LazySingleton(as: SearchRepository)
class SearchRepositoryImpl implements SearchRepository {
  const SearchRepositoryImpl(this._remote, this._networkInfo);

  final SearchRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, List<ChapterEntity>>> searchChapters({
    required String query,
    required String category,
  }) async {
    if (!await _networkInfo.isConnected) {
      return left(const NetworkFailure());
    }
    try {
      final models = await _remote.searchChapters(
        query: query,
        category: category,
      );
      return right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return left(ServerFailure(message: e.message));
    }
  }
}
