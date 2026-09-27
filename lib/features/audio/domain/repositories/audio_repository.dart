import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/audio/domain/entities/audio_track_entity.dart';

abstract interface class AudioRepository {
  /// Returns all audio tracks across the 3 sources (Hadi/Muhud/Rodad
  /// Cabang). Dataset is small so this fetches everything in one call —
  /// search/filter/sort are derived client-side.
  Future<Either<Failure, List<AudioTrackEntity>>> getAllAudioTracks();
}
