import 'dart:async';

import 'package:ishari/features/audio/domain/entities/audio_playback_request.dart';
import 'package:ishari/features/audio/domain/services/audio_playback_service.dart';

/// In-memory [AudioPlaybackService] double — no platform channel involved,
/// so bloc play/pause/seek logic can be exercised in plain `flutter_test`.
/// Tests drive it via [emitPosition]/[emitDuration]/[emitCompleted] and
/// assert against [loadedRequests]/[pauseCalls]/[resumeCalls]/[seekedTo].
class FakeAudioPlaybackService implements AudioPlaybackService {
  final _positionController = StreamController<Duration>.broadcast();
  final _durationController = StreamController<Duration?>.broadcast();
  final _playingController = StreamController<bool>.broadcast();
  final _completedController = StreamController<void>.broadcast();

  final loadedRequests = <AudioPlaybackRequest>[];
  final seekedTo = <Duration>[];
  int pauseCalls = 0;
  int resumeCalls = 0;
  int stopCalls = 0;

  Duration _position = Duration.zero;
  Duration? _duration;

  @override
  Stream<Duration> get positionStream => _positionController.stream;

  @override
  Stream<Duration?> get durationStream => _durationController.stream;

  @override
  Stream<bool> get playingStream => _playingController.stream;

  @override
  Stream<void> get completedStream => _completedController.stream;

  @override
  Duration get position => _position;

  @override
  Duration? get duration => _duration;

  @override
  Future<void> load(AudioPlaybackRequest request) async {
    loadedRequests.add(request);
    _position = Duration.zero;
    _playingController.add(true);
  }

  @override
  Future<void> pause() async {
    pauseCalls++;
    _playingController.add(false);
  }

  @override
  Future<void> resume() async {
    resumeCalls++;
    _playingController.add(true);
  }

  @override
  Future<void> stop() async {
    stopCalls++;
    _playingController.add(false);
  }

  @override
  Future<void> seek(Duration position) async {
    seekedTo.add(position);
    _position = position;
    _positionController.add(position);
  }

  @override
  Future<void> dispose() async {
    await _positionController.close();
    await _durationController.close();
    await _playingController.close();
    await _completedController.close();
  }

  void emitPosition(Duration position) {
    _position = position;
    _positionController.add(position);
  }

  void emitDuration(Duration? duration) {
    _duration = duration;
    _durationController.add(duration);
  }

  void emitCompleted() => _completedController.add(null);
}
