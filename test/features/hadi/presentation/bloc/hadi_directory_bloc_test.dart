import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/audio/audio_session_coordinator.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/audio/domain/entities/audio_playback_request.dart';
import 'package:ishari/features/audio/domain/entities/audio_track_entity.dart';
import 'package:ishari/features/audio/domain/repositories/audio_repository.dart';
import 'package:ishari/features/audio/domain/usecases/get_all_audio_tracks.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_list_bloc.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_list_event.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_list_state.dart';
import 'package:ishari/features/hadi/domain/entities/hadi_audio_entity.dart';
import 'package:ishari/features/hadi/domain/entities/hadi_summary_entity.dart';
import 'package:ishari/features/hadi/domain/repositories/hadi_repository.dart';
import 'package:ishari/features/hadi/domain/usecases/get_all_hadi.dart';
import 'package:ishari/features/hadi/domain/usecases/get_all_hadi_audio.dart';
import 'package:ishari/features/hadi/presentation/bloc/hadi_directory_bloc.dart';
import 'package:ishari/features/hadi/presentation/bloc/hadi_directory_event.dart';
import 'package:ishari/features/hadi/presentation/bloc/hadi_directory_state.dart';
import 'package:ishari/features/muhud/domain/entities/verse_media_type.dart';

import '../../../audio/fakes/fake_audio_playback_service.dart';

const _hadi = HadiSummaryEntity(id: 'h1', name: 'Hadi Amir');

HadiAudioEntity _audio(int id) => HadiAudioEntity(
  id: id,
  hadiId: 'h1',
  verseId: id,
  verseNumber: id,
  chapterTitle: 'Chapter $id',
  arabicText: 'text',
  mediaUrl: 'https://example.com/$id.mp3',
  type: VerseMediaType.joz,
);

class _FakeHadiRepository implements HadiRepository {
  @override
  Future<Either<Failure, List<HadiSummaryEntity>>> getAllHadi() async =>
      right(const [_hadi]);

  @override
  Future<Either<Failure, List<HadiAudioEntity>>> getAllHadiAudio() async =>
      right([_audio(1), _audio(2)]);
}

class _FakeAudioRepository implements AudioRepository {
  @override
  Future<Either<Failure, List<AudioTrackEntity>>> getAllAudioTracks() async =>
      right([
        AudioTrackEntity(
          id: 'a',
          title: 'Catalog',
          mediaUrl: 'https://example.com/a.mp3',
          createdAt: DateTime(2024),
        ),
      ]);
}

/// Holds each [load] open until the test completes (or fails) its gate, so
/// ownership changes can be injected while a load is still in flight.
class _GatedPlaybackService extends FakeAudioPlaybackService {
  final gates = <Completer<void>>[];

  /// Order in which playback actually started or was stopped.
  final log = <String>[];

  bool disposed = false;

  @override
  Future<void> load(AudioPlaybackRequest request) async {
    final gate = Completer<void>();
    gates.add(gate);
    await gate.future;
    log.add('start:${request.id}');
    await super.load(request);
  }

  @override
  Future<void> stop() {
    log.add('stop');
    return super.stop();
  }

  @override
  Future<void> dispose() {
    disposed = true;
    return super.dispose();
  }
}

class _ThrowingPlaybackService extends FakeAudioPlaybackService {
  _ThrowingPlaybackService(this.error);
  final Object error;

  @override
  Future<void> load(AudioPlaybackRequest request) async =>
      // Deliberately throws both Exceptions and Errors.
      // ignore: only_throw_errors
      throw error;
}

Future<HadiDirectoryBloc> _loadedBloc(
  FakeAudioPlaybackService playback,
  AudioSessionCoordinator coordinator,
) async {
  final repository = _FakeHadiRepository();
  final bloc = HadiDirectoryBloc(
    getAllHadi: GetAllHadi(repository),
    getAllHadiAudio: GetAllHadiAudio(repository),
    playbackService: playback,
    sessionCoordinator: coordinator,
  );
  bloc.add(const HadiDirectoryEvent.loadAll());
  await bloc.stream.firstWhere((s) => s.status == HadiDirectoryStatus.loaded);
  return bloc;
}

Future<void> _play(HadiDirectoryBloc bloc, int id) async {
  bloc.add(HadiDirectoryEvent.playTrack(id));
  await pumpEventQueue();
}

void _expectCleared(HadiDirectoryState state) {
  expect(state.playingAudioId, isNull);
  expect(state.isAudioLoading, isFalse);
  expect(state.isPlaying, isFalse);
}

void main() {
  late FakeAudioPlaybackService playback;
  late AudioSessionCoordinator coordinator;

  setUp(() {
    playback = FakeAudioPlaybackService();
    coordinator = AudioSessionCoordinator();
  });

  group('shared player', () {
    test('playTrack claims hadi and loads a tagged request', () async {
      final bloc = await _loadedBloc(playback, coordinator);
      addTearDown(bloc.close);

      await _play(bloc, 1);

      final request = playback.loadedRequests.single;
      expect(request.id, 'hadi-audio-1');
      expect(request.url, 'https://example.com/1.mp3');
      expect(request.title, 'Chapter 1');
      expect(request.subtitle, 'Hadi Amir · Ayat 1');
      expect(coordinator.owner.value, AudioSessionOwner.hadi);
      expect(bloc.state.playingAudioId, 1);
      expect(bloc.state.isAudioLoading, isFalse);
      expect(bloc.state.isPlaying, isTrue);
    });

    test('re-tapping the current track pauses then resumes', () async {
      final bloc = await _loadedBloc(playback, coordinator);
      addTearDown(bloc.close);
      await _play(bloc, 1);

      await _play(bloc, 1);
      expect(playback.pauseCalls, 1);
      expect(bloc.state.playingAudioId, 1);
      expect(bloc.state.isPlaying, isFalse);

      await _play(bloc, 1);
      expect(playback.resumeCalls, 1);
      expect(bloc.state.isPlaying, isTrue);
      expect(playback.loadedRequests, hasLength(1));
    });

    test('follows play/pause coming from the lockscreen controls', () async {
      final bloc = await _loadedBloc(playback, coordinator);
      addTearDown(bloc.close);
      await _play(bloc, 1);

      // The lockscreen drives the player directly, bypassing the bloc.
      await playback.pause();
      await pumpEventQueue();
      expect(bloc.state.isPlaying, isFalse);

      await playback.resume();
      await pumpEventQueue();
      expect(bloc.state.isPlaying, isTrue);
    });

    test('natural completion stops and releases ownership', () async {
      final bloc = await _loadedBloc(playback, coordinator);
      addTearDown(bloc.close);
      await _play(bloc, 1);

      playback.emitCompleted();
      await pumpEventQueue();

      _expectCleared(bloc.state);
      expect(playback.stopCalls, 1);
      expect(coordinator.owner.value, AudioSessionOwner.none);
    });

    test('stopAudio does not stop audio owned by someone else', () async {
      final bloc = await _loadedBloc(playback, coordinator);
      addTearDown(bloc.close);
      await _play(bloc, 1);
      coordinator.claim(AudioSessionOwner.muhudVerse);
      await pumpEventQueue();

      bloc.add(const HadiDirectoryEvent.stopAudio());
      await pumpEventQueue();

      expect(playback.stopCalls, 0);
      expect(coordinator.owner.value, AudioSessionOwner.muhudVerse);
    });

    for (final other in [
      AudioSessionOwner.audioCatalog,
      AudioSessionOwner.muhudVerse,
    ]) {
      test('losing ownership to ${other.name} clears without stop', () async {
        final bloc = await _loadedBloc(playback, coordinator);
        addTearDown(bloc.close);
        await _play(bloc, 1);

        coordinator.claim(other);
        await pumpEventQueue();

        _expectCleared(bloc.state);
        expect(playback.stopCalls, 0);

        // The new owner's player events must not leak into Hadi state.
        await playback.resume();
        playback.emitCompleted();
        await pumpEventQueue();
        _expectCleared(bloc.state);
        expect(playback.stopCalls, 0);
      });
    }

    test('catalog and hadi audio take the player from each other', () async {
      final hadiBloc = await _loadedBloc(playback, coordinator);
      addTearDown(hadiBloc.close);
      final catalogBloc = AudioListBloc(
        getAllAudioTracks: GetAllAudioTracks(_FakeAudioRepository()),
        playbackService: playback,
        sessionCoordinator: coordinator,
      );
      addTearDown(catalogBloc.close);
      catalogBloc.add(const AudioListEvent.loadAll());
      await catalogBloc.stream.firstWhere(
        (s) => s.status == AudioListStatus.loaded,
      );

      await _play(hadiBloc, 1);
      catalogBloc.add(const AudioListEvent.playTrack('a'));
      await pumpEventQueue();

      _expectCleared(hadiBloc.state);
      expect(catalogBloc.state.playingId, 'a');

      await _play(hadiBloc, 2);

      // A null playingTrack is what hides the global mini player.
      expect(catalogBloc.state.playingTrack, isNull);
      expect(catalogBloc.state.isPlaying, isFalse);
      expect(hadiBloc.state.playingAudioId, 2);
      expect(hadiBloc.state.isPlaying, isTrue);
      expect(coordinator.owner.value, AudioSessionOwner.hadi);
      expect(playback.stopCalls, 0);
    });
  });

  group('load failure', () {
    for (final error in <Object>[Exception('boom'), TypeError()]) {
      test('${error.runtimeType} clears the spinner and releases', () async {
        final bloc = await _loadedBloc(
          _ThrowingPlaybackService(error),
          coordinator,
        );
        addTearDown(bloc.close);

        await _play(bloc, 1);

        _expectCleared(bloc.state);
        expect(coordinator.owner.value, AudioSessionOwner.none);
      });
    }
  });

  group('in-flight load', () {
    late _GatedPlaybackService gated;

    setUp(() => gated = _GatedPlaybackService());

    test('re-tap while loading is ignored', () async {
      final bloc = await _loadedBloc(gated, coordinator);
      addTearDown(bloc.close);
      await _play(bloc, 1);

      await _play(bloc, 1);

      expect(gated.gates, hasLength(1));
      expect(gated.pauseCalls, 0);
      expect(gated.resumeCalls, 0);
      expect(bloc.state.isAudioLoading, isTrue);
    });

    for (final fails in [false, true]) {
      final outcome = fails ? 'failure' : 'success';

      test('stale $outcome after ownership loss changes nothing', () async {
        final bloc = await _loadedBloc(gated, coordinator);
        addTearDown(bloc.close);
        await _play(bloc, 1);
        coordinator.claim(AudioSessionOwner.audioCatalog);
        await pumpEventQueue();

        if (fails) {
          gated.gates.single.completeError(Exception('interrupted'));
        } else {
          gated.gates.single.complete();
        }
        await pumpEventQueue();

        _expectCleared(bloc.state);
        expect(gated.stopCalls, 0);
        expect(coordinator.owner.value, AudioSessionOwner.audioCatalog);
      });

      test('stale $outcome of track A leaves track B alone', () async {
        final bloc = await _loadedBloc(gated, coordinator);
        addTearDown(bloc.close);
        await _play(bloc, 1);
        await _play(bloc, 2);

        if (fails) {
          gated.gates.first.completeError(Exception('interrupted'));
        } else {
          gated.gates.first.complete();
        }
        await pumpEventQueue();

        expect(bloc.state.playingAudioId, 2);
        expect(bloc.state.isAudioLoading, isTrue);
        expect(coordinator.owner.value, AudioSessionOwner.hadi);
        expect(gated.stopCalls, 0);
      });
    }

    test('a load finishing after stopAudio is stopped again', () async {
      final bloc = await _loadedBloc(gated, coordinator);
      addTearDown(bloc.close);
      await _play(bloc, 1);
      bloc.add(const HadiDirectoryEvent.stopAudio());
      await pumpEventQueue();

      gated.gates.single.complete();
      await pumpEventQueue();

      expect(gated.log.last, 'stop');
      _expectCleared(bloc.state);
      expect(coordinator.owner.value, AudioSessionOwner.none);
    });
  });

  group('close', () {
    test('stops and releases its own audio without disposing', () async {
      final gated = _GatedPlaybackService();
      final bloc = await _loadedBloc(gated, coordinator);
      await _play(bloc, 1);
      gated.gates.single.complete();
      await pumpEventQueue();

      await bloc.close();

      expect(gated.stopCalls, 1);
      expect(gated.disposed, isFalse);
      expect(coordinator.owner.value, AudioSessionOwner.none);
    });

    test('an in-flight load cannot keep playing after close', () async {
      final gated = _GatedPlaybackService();
      final bloc = await _loadedBloc(gated, coordinator);
      await _play(bloc, 1);

      await bloc.close();
      gated.gates.single.complete();
      await pumpEventQueue();

      expect(gated.log.last, 'stop');
      expect(gated.disposed, isFalse);
      expect(coordinator.owner.value, AudioSessionOwner.none);
    });

    test('a play still queued at close never starts', () async {
      final bloc = await _loadedBloc(playback, coordinator);

      bloc.add(const HadiDirectoryEvent.playTrack(1));
      await bloc.close();
      await pumpEventQueue();

      expect(playback.loadedRequests, isEmpty);
      expect(coordinator.owner.value, AudioSessionOwner.none);
    });

    test('does not stop audio another feature took over', () async {
      final bloc = await _loadedBloc(playback, coordinator);
      await _play(bloc, 1);
      // Close before Hadi has processed the loss, so its state still points
      // at its own track.
      coordinator.claim(AudioSessionOwner.muhudVerse);
      await bloc.close();
      await pumpEventQueue();

      expect(playback.stopCalls, 0);
      expect(coordinator.owner.value, AudioSessionOwner.muhudVerse);
    });

    test('in-flight load after takeover does not stop it', () async {
      final gated = _GatedPlaybackService();
      final bloc = await _loadedBloc(gated, coordinator);
      await _play(bloc, 1);
      coordinator.claim(AudioSessionOwner.audioCatalog);

      await bloc.close();
      gated.gates.single.complete();
      await pumpEventQueue();

      expect(gated.stopCalls, 0);
      expect(coordinator.owner.value, AudioSessionOwner.audioCatalog);
    });
  });
}
