import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/hadi/domain/entities/hadi_audio_entity.dart';
import 'package:ishari/features/hadi/domain/entities/hadi_summary_entity.dart';

abstract interface class HadiRepository {
  /// Returns all pimpinan shalawat (hadi).
  Future<Either<Failure, List<HadiSummaryEntity>>> getAllHadi();

  /// Returns all audio media across all hadi. Dataset is small (dozens of
  /// rows) so this fetches everything in one call — grouping/counting per
  /// hadi is derived client-side rather than filtered server-side.
  Future<Either<Failure, List<HadiAudioEntity>>> getAllHadiAudio();
}
