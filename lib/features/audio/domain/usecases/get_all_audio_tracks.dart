import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/usecases/usecase.dart';
import 'package:ishari/features/audio/domain/entities/audio_track_entity.dart';
import 'package:ishari/features/audio/domain/repositories/audio_repository.dart';

@injectable
class GetAllAudioTracks implements UseCase<List<AudioTrackEntity>, NoParams> {
  const GetAllAudioTracks(this._repository);

  final AudioRepository _repository;

  @override
  Future<Either<Failure, List<AudioTrackEntity>>> call(NoParams params) =>
      _repository.getAllAudioTracks();
}
