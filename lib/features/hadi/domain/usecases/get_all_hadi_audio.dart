import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/usecases/usecase.dart';
import 'package:ishari/features/hadi/domain/entities/hadi_audio_entity.dart';
import 'package:ishari/features/hadi/domain/repositories/hadi_repository.dart';

@injectable
class GetAllHadiAudio implements UseCase<List<HadiAudioEntity>, NoParams> {
  const GetAllHadiAudio(this._repository);

  final HadiRepository _repository;

  @override
  Future<Either<Failure, List<HadiAudioEntity>>> call(NoParams params) =>
      _repository.getAllHadiAudio();
}
