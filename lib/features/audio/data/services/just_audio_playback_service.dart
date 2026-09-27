import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:ishari/features/audio/domain/entities/audio_playback_request.dart';
import 'package:ishari/features/audio/domain/services/audio_playback_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

/// [AudioPlaybackService] backed by a single shared [AudioPlayer].
///
/// `just_audio_background` (wired up in `main()` via
/// `JustAudioBackground.init`) replaces the global just_audio platform
/// bridge with one that "supports only a single player instance" — so this
/// MUST stay the one and only
/// [AudioPlayer] in the app, shared by every feature that plays audio
/// (audio catalog tracks AND chapter-reader verse audio), or the second
/// caller's `setAudioSource` throws. Tagging each source with a [MediaItem]
/// is what makes it show up on the lockscreen/notification with working
/// play/pause/seek controls.
@LazySingleton(as: AudioPlaybackService)
class JustAudioPlaybackService implements AudioPlaybackService {
  JustAudioPlaybackService() {
    _completedSubscription = _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) _completedController.add(null);
    });
  }

  final AudioPlayer _player = AudioPlayer();
  final _completedController = StreamController<void>.broadcast();
  late final StreamSubscription<ProcessingState> _completedSubscription;

  @override
  Stream<Duration> get positionStream => _player.positionStream;

  @override
  Stream<Duration?> get durationStream => _player.durationStream;

  @override
  Stream<bool> get playingStream => _player.playingStream;

  @override
  Stream<void> get completedStream => _completedController.stream;

  @override
  Duration get position => _player.position;

  @override
  Duration? get duration => _player.duration;

  @override
  Future<void> load(AudioPlaybackRequest request) async {
    await _player.stop();
    await _player.setAudioSource(
      AudioSource.uri(
        Uri.parse(request.url),
        tag: MediaItem(
          id: request.id,
          title: request.title,
          artist: request.subtitle,
        ),
      ),
    );
    unawaited(_player.play());
  }

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> resume() => _player.play();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> dispose() async {
    await _completedSubscription.cancel();
    await _completedController.close();
    await _player.dispose();
  }
}
