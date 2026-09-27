import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/audio/audio_session_coordinator.dart';
import 'package:ishari/core/usecases/usecase.dart';
import 'package:ishari/core/utils/app_logger.dart';
import 'package:ishari/features/audio/domain/entities/audio_category.dart';
import 'package:ishari/features/audio/domain/entities/audio_playback_request.dart';
import 'package:ishari/features/audio/domain/services/audio_playback_service.dart';
import 'package:ishari/features/audio/domain/usecases/get_all_audio_tracks.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_list_event.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_list_state.dart';

@lazySingleton
class AudioListBloc extends Bloc<AudioListEvent, AudioListState> {
  AudioListBloc({
    required this.getAllAudioTracks,
    required this.playbackService,
    required this.sessionCoordinator,
  }) : super(const AudioListState()) {
    on<AudioListEvent>((event, emit) async {
      await event.when(
        loadAll: (forceRefresh) => _onLoadAll(emit, forceRefresh: forceRefresh),
        searchChanged: (query) async => emit(state.copyWith(query: query)),
        sortChanged: (sort) async => emit(state.copyWith(sort: sort)),
        openFilterSheet: () async => emit(
          state.copyWith(draftSelected: _cloneSelected(state.appliedSelected)),
        ),
        resetFilterDraft: () async =>
            emit(state.copyWith(draftSelected: const {})),
        applyFilter: () async => emit(
          state.copyWith(
            appliedSelected: _cloneSelected(state.draftSelected),
          ),
        ),
        toggleDraftChip: (category, value) async =>
            _onToggleDraftChip(category, value, emit),
        playTrack: (trackId) => _onPlayTrack(trackId, emit),
        stopAudio: () => _onStopAudio(emit),
        ownershipLost: () async => _onOwnershipLost(emit),
        seekBy: (offset) => _onSeekBy(offset, emit),
        seekTo: (position) => _onSeekTo(position, emit),
        positionChanged: (position) async =>
            emit(state.copyWith(position: position)),
        durationChanged: (duration) async =>
            emit(state.copyWith(duration: duration)),
        playingChanged: (isPlaying) async =>
            emit(state.copyWith(isPlaying: isPlaying)),
      );
    });

    _positionSubscription = playbackService.positionStream.listen((position) {
      if (_isOwner) add(AudioListEvent.positionChanged(position));
    });
    _durationSubscription = playbackService.durationStream.listen((duration) {
      if (_isOwner) add(AudioListEvent.durationChanged(duration));
    });
    _playingSubscription = playbackService.playingStream.listen((isPlaying) {
      if (_isOwner) add(AudioListEvent.playingChanged(isPlaying: isPlaying));
    });
    _completedSubscription = playbackService.completedStream.listen((_) {
      if (_isOwner) add(const AudioListEvent.stopAudio());
    });
    _ownerListener = () {
      if (!_isOwner && state.playingId != null) {
        add(const AudioListEvent.ownershipLost());
      }
    };
    sessionCoordinator.owner.addListener(_ownerListener);
  }

  final GetAllAudioTracks getAllAudioTracks;
  final AudioPlaybackService playbackService;
  final AudioSessionCoordinator sessionCoordinator;

  late final StreamSubscription<Duration> _positionSubscription;
  late final StreamSubscription<Duration?> _durationSubscription;
  late final StreamSubscription<bool> _playingSubscription;
  late final StreamSubscription<void> _completedSubscription;
  late final VoidCallback _ownerListener;

  bool get _isOwner =>
      sessionCoordinator.owner.value == AudioSessionOwner.audioCatalog;

  @override
  Future<void> close() async {
    sessionCoordinator.owner.removeListener(_ownerListener);
    await _positionSubscription.cancel();
    await _durationSubscription.cancel();
    await _playingSubscription.cancel();
    await _completedSubscription.cancel();
    return super.close();
  }

  Map<AudioCategory, Set<String>> _cloneSelected(
    Map<AudioCategory, Set<String>> selected,
  ) => {
    for (final e in selected.entries) e.key: {...e.value},
  };

  Future<void> _onLoadAll(
    Emitter<AudioListState> emit, {
    required bool forceRefresh,
  }) async {
    if (!forceRefresh &&
        (state.status == AudioListStatus.loaded ||
            state.status == AudioListStatus.loading)) {
      return;
    }
    if (state.status != AudioListStatus.loaded) {
      emit(state.copyWith(status: AudioListStatus.loading));
    }

    final result = await getAllAudioTracks(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AudioListStatus.error,
          errorMessage: failure.message,
          refreshTick: state.refreshTick + 1,
        ),
      ),
      (tracks) => emit(
        state.copyWith(
          status: AudioListStatus.loaded,
          tracks: tracks,
          errorMessage: null,
          refreshTick: state.refreshTick + 1,
        ),
      ),
    );
  }

  void _onToggleDraftChip(
    AudioCategory category,
    String value,
    Emitter<AudioListState> emit,
  ) {
    final current = state.draftSelected[category] ?? const <String>{};
    final next = {...current};
    if (!next.remove(value)) next.add(value);
    emit(
      state.copyWith(draftSelected: {...state.draftSelected, category: next}),
    );
  }

  /// Loads [trackId] if it isn't already current; otherwise toggles
  /// pause/resume in place — `isPlaying` itself updates via [playbackService]
  /// stream once the player actually reacts, not optimistically here.
  Future<void> _onPlayTrack(
    String trackId,
    Emitter<AudioListState> emit,
  ) async {
    if (state.playingId == trackId) {
      if (state.isPlaying) {
        await playbackService.pause();
      } else {
        await playbackService.resume();
      }
      return;
    }

    final matches = state.tracks.where((t) => t.id == trackId);
    if (matches.isEmpty) return;
    final track = matches.first;

    sessionCoordinator.claim(AudioSessionOwner.audioCatalog);
    emit(
      state.copyWith(
        playingId: trackId,
        isAudioLoading: true,
        isPlaying: false,
        position: Duration.zero,
        duration: null,
      ),
    );
    try {
      await playbackService.load(
        AudioPlaybackRequest(
          id: track.id,
          url: track.mediaUrl,
          title: track.title,
          subtitle: track.facetSubtitle,
        ),
      );
      emit(state.copyWith(isAudioLoading: false));
    } on Exception catch (e, stackTrace) {
      appLogger.e(
        '[AudioListBloc] Audio playback failed',
        error: e,
        stackTrace: stackTrace,
      );
      sessionCoordinator.release(AudioSessionOwner.audioCatalog);
      emit(
        state.copyWith(
          playingId: null,
          isAudioLoading: false,
          isPlaying: false,
        ),
      );
    }
  }

  Future<void> _onSeekBy(Duration offset, Emitter<AudioListState> emit) async {
    if (state.playingId == null) return;
    await playbackService.seek(_clampToDuration(state.position + offset));
  }

  /// Absolute seek from the mini player's progress bar (tap or drag).
  Future<void> _onSeekTo(
    Duration position,
    Emitter<AudioListState> emit,
  ) async {
    if (state.playingId == null) return;
    await playbackService.seek(_clampToDuration(position));
  }

  Duration _clampToDuration(Duration target) {
    if (target < Duration.zero) return Duration.zero;
    final total = state.duration;
    if (total != null && target > total) return total;
    return target;
  }

  Future<void> _onStopAudio(Emitter<AudioListState> emit) async {
    await playbackService.stop();
    sessionCoordinator.release(AudioSessionOwner.audioCatalog);
    emit(
      state.copyWith(
        playingId: null,
        isAudioLoading: false,
        isPlaying: false,
        position: Duration.zero,
        duration: null,
      ),
    );
  }

  /// The shared player was claimed by chapter-reader verse audio — just
  /// clear local state, the player itself is already mid-replacement.
  void _onOwnershipLost(Emitter<AudioListState> emit) {
    if (state.playingId == null) return;
    emit(
      state.copyWith(
        playingId: null,
        isAudioLoading: false,
        isPlaying: false,
        position: Duration.zero,
        duration: null,
      ),
    );
  }
}
