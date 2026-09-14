import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/usecases/usecase.dart';
import 'package:ishari/features/hadi/domain/entities/hadi_summary_entity.dart';
import 'package:ishari/features/hadi/domain/repositories/hadi_repository.dart';

@injectable
class GetAllHadi implements UseCase<List<HadiSummaryEntity>, NoParams> {
  const GetAllHadi(this._repository);

  final HadiRepository _repository;

  @override
  Future<Either<Failure, List<HadiSummaryEntity>>> call(NoParams params) =>
      _repository.getAllHadi();
}
