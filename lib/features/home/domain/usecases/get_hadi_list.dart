import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/usecases/usecase.dart';
import 'package:ishari/features/home/domain/entities/hadi_entity.dart';
import 'package:ishari/features/home/domain/repositories/home_repository.dart';

@injectable
class GetHadiList implements UseCase<List<HadiEntity>, NoParams> {
  const GetHadiList(this._repository);

  final HomeRepository _repository;

  @override
  Future<Either<Failure, List<HadiEntity>>> call(NoParams params) =>
      _repository.getHadiList();
}
