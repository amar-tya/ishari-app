import 'package:ishari/features/audio/domain/entities/audio_playback_request.dart';

/// Playback engine used by `AudioListBloc`.
///
/// Kept as a domain abstraction (instead of the bloc importing `just_audio`
/// directly) so the bloc's play/pause/seek logic can be unit-tested with a
/// fake, and so the background/notification concern (audio_service under the
/// hood) stays a data-layer implementation detail.
abstract class AudioPlaybackService {
  /// Emits on every position tick while a track is loaded.
  Stream<Duration> get positionStream;

  /// Emits when the current track's total duration becomes known (or
  /// changes track), `null` while unknown.
  Stream<Duration?> get durationStream;

  /// Emits `true`/`false` as the player actually starts/stops producing
  /// sound — distinct from "a track is loaded", which is bloc-level state.
  Stream<bool> get playingStream;

  /// Emits once a track finishes playing on its own (not via [stop]).
  Stream<void> get completedStream;

  Duration get position;
  Duration? get duration;

  /// Stops whatever is currently loaded (if anything) and starts playing
  /// [request].
  Future<void> load(AudioPlaybackRequest request);

  Future<void> pause();

  /// Resumes a paused track loaded via [load] — no-op if nothing is loaded.
  Future<void> resume();

  /// Stops and unloads the current track.
  Future<void> stop();

  Future<void> seek(Duration position);

  Future<void> dispose();
}
