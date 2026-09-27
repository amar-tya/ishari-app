import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/audio/audio_session_coordinator.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/audio/domain/entities/audio_category.dart';
import 'package:ishari/features/audio/domain/entities/audio_track_entity.dart';
import 'package:ishari/features/audio/domain/repositories/audio_repository.dart';
import 'package:ishari/features/audio/domain/usecases/get_all_audio_tracks.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_list_bloc.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_list_event.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_list_state.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_sort.dart';

import '../../fakes/fake_audio_playback_service.dart';

class _FakeAudioRepository implements AudioRepository {
  _FakeAudioRepository(this._result);
  final Either<Failure, List<AudioTrackEntity>> _result;

  @override
  Future<Either<Failure, List<AudioTrackEntity>>> getAllAudioTracks() async =>
      _result;
}

final _sampleTrack = AudioTrackEntity(
  id: 'a',
  title: 'Sample',
  mediaUrl: 'https://example.com/a.mp3',
  createdAt: DateTime(2024),
  hadiName: 'Hadi Amir',
);

final _otherTrack = AudioTrackEntity(
  id: 'b',
  title: 'Other',
  mediaUrl: 'https://example.com/b.mp3',
  createdAt: DateTime(2024, 2),
);

AudioListBloc _bloc(
  Either<Failure, List<AudioTrackEntity>> result, {
  FakeAudioPlaybackService? playbackService,
  AudioSessionCoordinator? sessionCoordinator,
}) => AudioListBloc(
  getAllAudioTracks: GetAllAudioTracks(_FakeAudioRepository(result)),
  playbackService: playbackService ?? FakeAudioPlaybackService(),
  sessionCoordinator: sessionCoordinator ?? AudioSessionCoordinator(),
);

void main() {
  group('loadAll', () {
    test('emits loading then loaded on success', () async {
      final bloc = _bloc(right([_sampleTrack]));
      addTearDown(bloc.close);

      unawaited(
        expectLater(
          bloc.stream,
          emitsInOrder([
            predicate<AudioListState>(
              (s) => s.status == AudioListStatus.loading,
            ),
            predicate<AudioListState>(
              (s) => s.status == AudioListStatus.loaded && s.tracks.length == 1,
            ),
          ]),
        ),
      );
      bloc.add(const AudioListEvent.loadAll());
    });

    test('emits loading then error on failure', () async {
      final bloc = _bloc(left(const ServerFailure(message: 'boom')));
      addTearDown(bloc.close);

      unawaited(
        expectLater(
          bloc.stream,
          emitsInOrder([
            predicate<AudioListState>(
              (s) => s.status == AudioListStatus.loading,
            ),
            predicate<AudioListState>(
              (s) =>
                  s.status == AudioListStatus.error && s.errorMessage == 'boom',
            ),
          ]),
        ),
      );
      bloc.add(const AudioListEvent.loadAll());
    });

    test('does not refetch when already loaded unless forceRefresh', () async {
      final bloc = _bloc(right([_sampleTrack]));
      addTearDown(bloc.close);
      bloc.add(const AudioListEvent.loadAll());
      await bloc.stream.firstWhere((s) => s.status == AudioListStatus.loaded);
      final tickAfterFirstLoad = bloc.state.refreshTick;

      bloc.add(const AudioListEvent.loadAll());
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state.refreshTick, tickAfterFirstLoad);
    });
  });

  group('search / sort', () {
    test('searchChanged updates query', () async {
      final bloc = _bloc(right(const []));
      addTearDown(bloc.close);
      bloc.add(const AudioListEvent.searchChanged('shalawat'));
      await bloc.stream.first;
      expect(bloc.state.query, 'shalawat');
    });

    test('sortChanged updates sort', () async {
      final bloc = _bloc(right(const []));
      addTearDown(bloc.close);
      bloc.add(const AudioListEvent.sortChanged(AudioSort.az));
      await bloc.stream.first;
      expect(bloc.state.sort, AudioSort.az);
    });
  });

  group('filter draft lifecycle', () {
    test('toggleDraftChip adds then removes the same value', () async {
      final bloc = _bloc(right(const []));
      addTearDown(bloc.close);
      bloc.add(const AudioListEvent.toggleDraftChip(AudioCategory.muhud, 'X'));
      await bloc.stream.first;
      expect(bloc.state.draftSelected[AudioCategory.muhud], {'X'});

      bloc.add(const AudioListEvent.toggleDraftChip(AudioCategory.muhud, 'X'));
      await bloc.stream.first;
      expect(bloc.state.draftSelected[AudioCategory.muhud], isEmpty);
    });

    test('applyFilter commits draft into applied', () async {
      final bloc = _bloc(right(const []));
      addTearDown(bloc.close);
      bloc.add(
        const AudioListEvent.toggleDraftChip(AudioCategory.hadi, 'Hadi Amir'),
      );
      await bloc.stream.first;
      bloc.add(const AudioListEvent.applyFilter());
      await bloc.stream.first;
      expect(bloc.state.appliedSelected[AudioCategory.hadi], {'Hadi Amir'});
    });

    test('openFilterSheet resets draft to a fresh clone of applied', () async {
      final bloc = _bloc(right(const []));
      addTearDown(bloc.close);
      bloc.add(
        const AudioListEvent.toggleDraftChip(AudioCategory.hadi, 'Hadi Amir'),
      );
      await bloc.stream.first;
      bloc.add(const AudioListEvent.applyFilter());
      await bloc.stream.first;

      // Mutate draft away from applied first — otherwise the clone below
      // would be value-equal to the current state and Bloc would skip
      // emitting entirely (no change to observe via .stream.first).
      bloc.add(
        const AudioListEvent.toggleDraftChip(AudioCategory.muhud, 'Other'),
      );
      await bloc.stream.first;
      expect(bloc.state.draftSelected[AudioCategory.muhud], {'Other'});

      bloc.add(const AudioListEvent.openFilterSheet());
      await bloc.stream.first;
      expect(bloc.state.draftSelected[AudioCategory.hadi], {'Hadi Amir'});
      expect(
        bloc.state.draftSelected.containsKey(AudioCategory.muhud),
        isFalse,
      );
    });

    test('resetFilterDraft clears draft without touching applied', () async {
      final bloc = _bloc(right(const []));
      addTearDown(bloc.close);
      bloc.add(
        const AudioListEvent.toggleDraftChip(AudioCategory.hadi, 'Hadi Amir'),
      );
      await bloc.stream.first;
      bloc.add(const AudioListEvent.applyFilter());
      await bloc.stream.first;

      bloc.add(const AudioListEvent.toggleDraftChip(AudioCategory.muhud, 'Y'));
      await bloc.stream.first;
      bloc.add(const AudioListEvent.resetFilterDraft());
      await bloc.stream.first;

      expect(bloc.state.draftSelected, isEmpty);
      expect(bloc.state.appliedSelected[AudioCategory.hadi], {'Hadi Amir'});
    });
  });

  group('play / pause / seek', () {
    test('playTrack loads and claims audioCatalog ownership', () async {
      final playback = FakeAudioPlaybackService();
      final coordinator = AudioSessionCoordinator();
      final bloc = _bloc(
        right([_sampleTrack]),
        playbackService: playback,
        sessionCoordinator: coordinator,
      );
      addTearDown(bloc.close);
      bloc.add(const AudioListEvent.loadAll());
      await bloc.stream.firstWhere((s) => s.status == AudioListStatus.loaded);

      bloc.add(const AudioListEvent.playTrack('a'));
      await bloc.stream.firstWhere((s) => s.playingId == 'a');

      expect(playback.loadedRequests.single.id, 'a');
      expect(coordinator.owner.value, AudioSessionOwner.audioCatalog);
    });

    test('tapping the same track again toggles pause then resume', () async {
      final playback = FakeAudioPlaybackService();
      final bloc = _bloc(right([_sampleTrack]), playbackService: playback);
      addTearDown(bloc.close);
      bloc.add(const AudioListEvent.loadAll());
      await bloc.stream.firstWhere((s) => s.status == AudioListStatus.loaded);
      bloc.add(const AudioListEvent.playTrack('a'));
      await bloc.stream.firstWhere((s) => s.isPlaying);

      bloc.add(const AudioListEvent.playTrack('a'));
      await bloc.stream.firstWhere((s) => !s.isPlaying);
      expect(playback.pauseCalls, 1);
      expect(bloc.state.playingId, 'a'); // still loaded, just paused

      bloc.add(const AudioListEvent.playTrack('a'));
      await bloc.stream.firstWhere((s) => s.isPlaying);
      expect(playback.resumeCalls, 1);
    });

    test('seekBy clamps within [0, duration]', () async {
      final playback = FakeAudioPlaybackService();
      final bloc = _bloc(right([_sampleTrack]), playbackService: playback);
      addTearDown(bloc.close);
      bloc.add(const AudioListEvent.loadAll());
      await bloc.stream.firstWhere((s) => s.status == AudioListStatus.loaded);
      bloc.add(const AudioListEvent.playTrack('a'));
      await bloc.stream.firstWhere((s) => s.playingId == 'a');

      playback.emitDuration(const Duration(seconds: 30));
      await bloc.stream.firstWhere((s) => s.duration != null);
      playback.emitPosition(const Duration(seconds: 25));
      await bloc.stream.firstWhere((s) => s.position.inSeconds == 25);

      bloc.add(const AudioListEvent.seekBy(Duration(seconds: 10)));
      await Future<void>.delayed(Duration.zero);
      expect(playback.seekedTo.last, const Duration(seconds: 30));

      bloc.add(const AudioListEvent.seekBy(Duration(seconds: -100)));
      await Future<void>.delayed(Duration.zero);
      expect(playback.seekedTo.last, Duration.zero);
    });

    test(
      'seekTo (progress bar tap/drag) clamps within [0, duration]',
      () async {
        final playback = FakeAudioPlaybackService();
        final bloc = _bloc(right([_sampleTrack]), playbackService: playback);
        addTearDown(bloc.close);
        bloc.add(const AudioListEvent.loadAll());
        await bloc.stream.firstWhere((s) => s.status == AudioListStatus.loaded);
        bloc.add(const AudioListEvent.playTrack('a'));
        await bloc.stream.firstWhere((s) => s.playingId == 'a');
        playback.emitDuration(const Duration(seconds: 30));
        await bloc.stream.firstWhere((s) => s.duration != null);

        bloc.add(const AudioListEvent.seekTo(Duration(seconds: 12)));
        await Future<void>.delayed(Duration.zero);
        expect(playback.seekedTo.last, const Duration(seconds: 12));

        bloc.add(const AudioListEvent.seekTo(Duration(seconds: 999)));
        await Future<void>.delayed(Duration.zero);
        expect(playback.seekedTo.last, const Duration(seconds: 30));
      },
    );

    test('losing ownership to muhudVerse clears playback state', () async {
      final playback = FakeAudioPlaybackService();
      final coordinator = AudioSessionCoordinator();
      final bloc = _bloc(
        right([_sampleTrack, _otherTrack]),
        playbackService: playback,
        sessionCoordinator: coordinator,
      );
      addTearDown(bloc.close);
      bloc.add(const AudioListEvent.loadAll());
      await bloc.stream.firstWhere((s) => s.status == AudioListStatus.loaded);
      bloc.add(const AudioListEvent.playTrack('a'));
      await bloc.stream.firstWhere((s) => s.playingId == 'a');

      coordinator.claim(AudioSessionOwner.muhudVerse);
      await bloc.stream.firstWhere((s) => s.playingId == null);
      expect(bloc.state.isPlaying, isFalse);
      // Ownership loss must not call stop() — the other source already
      // replaced the shared player's source.
      expect(playback.stopCalls, 0);
    });

    test('natural completion stops and releases ownership', () async {
      final playback = FakeAudioPlaybackService();
      final coordinator = AudioSessionCoordinator();
      final bloc = _bloc(
        right([_sampleTrack]),
        playbackService: playback,
        sessionCoordinator: coordinator,
      );
      addTearDown(bloc.close);
      bloc.add(const AudioListEvent.loadAll());
      await bloc.stream.firstWhere((s) => s.status == AudioListStatus.loaded);
      bloc.add(const AudioListEvent.playTrack('a'));
      await bloc.stream.firstWhere((s) => s.playingId == 'a');

      playback.emitCompleted();
      await bloc.stream.firstWhere((s) => s.playingId == null);
      expect(playback.stopCalls, 1);
      expect(coordinator.owner.value, AudioSessionOwner.none);
    });
  });
}
