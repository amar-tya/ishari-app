import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/audio/audio_session_coordinator.dart';
import 'package:ishari/core/usecases/usecase.dart';
import 'package:ishari/core/utils/app_logger.dart';
import 'package:ishari/features/audio/domain/entities/audio_playback_request.dart';
import 'package:ishari/features/audio/domain/services/audio_playback_service.dart';
import 'package:ishari/features/hadi/domain/usecases/get_all_hadi.dart';
import 'package:ishari/features/hadi/domain/usecases/get_all_hadi_audio.dart';
import 'package:ishari/features/hadi/presentation/bloc/hadi_directory_event.dart';
import 'package:ishari/features/hadi/presentation/bloc/hadi_directory_state.dart';

@lazySingleton
class HadiDirectoryBloc extends Bloc<HadiDirectoryEvent, HadiDirectoryState> {
  HadiDirectoryBloc({
    required this.getAllHadi,
    required this.getAllHadiAudio,
    required this.playbackService,
    required this.sessionCoordinator,
  }) : super(const HadiDirectoryState()) {
    on<HadiDirectoryEvent>((event, emit) async {
      await event.when(
        loadAll: (forceRefresh) => _onLoadAll(emit, forceRefresh: forceRefresh),
        searchChanged: (query) async =>
            emit(state.copyWith(searchQuery: query)),
        playTrack: (audioId) => _onPlayTrack(audioId, emit),
        stopAudio: () => _onStopAudio(emit),
        ownershipLost: () async => _onOwnershipLost(emit),
        playingChanged: (isPlaying) async =>
            _onPlayingChanged(emit, isPlaying: isPlaying),
      );
    });

    _playingSubscription = playbackService.playingStream.listen((isPlaying) {
      if (_isOwner) {
        add(HadiDirectoryEvent.playingChanged(isPlaying: isPlaying));
      }
    });
    _completedSubscription = playbackService.completedStream.listen((_) {
      if (_isOwner) add(const HadiDirectoryEvent.stopAudio());
    });
    _ownerListener = () {
      if (!_isOwner && state.playingAudioId != null) {
        add(const HadiDirectoryEvent.ownershipLost());
      }
    };
    sessionCoordinator.owner.addListener(_ownerListener);
  }

  final GetAllHadi getAllHadi;
  final GetAllHadiAudio getAllHadiAudio;
  final AudioPlaybackService playbackService;
  final AudioSessionCoordinator sessionCoordinator;

  late final StreamSubscription<bool> _playingSubscription;
  late final StreamSubscription<void> _completedSubscription;
  late final VoidCallback _ownerListener;

  // Event handlers run concurrently, so a load can finish after its track was
  // replaced or stopped. Bumped each time that happens to spot stale results.
  int _requestId = 0;
  bool _isClosing = false;

  bool get _isOwner => sessionCoordinator.owner.value == AudioSessionOwner.hadi;

  bool _isCurrent(int requestId) =>
      !_isClosing && requestId == _requestId && _isOwner;

  /// Never disposes [playbackService] — it is shared by the whole app. Audio
  /// still owned by Hadi is stopped, because nothing else in the app could
  /// control it afterwards.
  @override
  Future<void> close() async {
    _isClosing = true;
    sessionCoordinator.owner.removeListener(_ownerListener);
    await _playingSubscription.cancel();
    await _completedSubscription.cancel();
    if (_isOwner) await _stopAndRelease();
    return super.close();
  }

  Future<void> _onLoadAll(
    Emitter<HadiDirectoryState> emit, {
    required bool forceRefresh,
  }) async {
    if (!forceRefresh &&
        (state.status == HadiDirectoryStatus.loaded ||
            state.status == HadiDirectoryStatus.loading)) {
      return;
    }
    // Keep the current list on screen during a pull-to-refresh instead of
    // swapping to the full-page loading spinner (which would hide it).
    if (state.status != HadiDirectoryStatus.loaded) {
      emit(state.copyWith(status: HadiDirectoryStatus.loading));
    }

    final hadiResult = await getAllHadi(const NoParams());
    final audioResult = await getAllHadiAudio(const NoParams());

    hadiResult.fold(
      (failure) => emit(
        state.copyWith(
          status: HadiDirectoryStatus.error,
          errorMessage: failure.message,
          refreshTick: state.refreshTick + 1,
        ),
      ),
      (hadiList) {
        audioResult.fold(
          (failure) => emit(
            state.copyWith(
              status: HadiDirectoryStatus.error,
              errorMessage: failure.message,
              refreshTick: state.refreshTick + 1,
            ),
          ),
          (audioList) => emit(
            state.copyWith(
              status: HadiDirectoryStatus.loaded,
              hadiList: hadiList,
              audioList: audioList,
              errorMessage: null,
              refreshTick: state.refreshTick + 1,
            ),
          ),
        );
      },
    );
  }

  /// Loads [audioId] if it isn't already current; otherwise toggles
  /// pause/resume in place — `isPlaying` itself updates via [playbackService]
  /// stream once the player actually reacts, not optimistically here.
  Future<void> _onPlayTrack(
    int audioId,
    Emitter<HadiDirectoryState> emit,
  ) async {
    if (_isClosing) return;

    if (state.playingAudioId == audioId && _isOwner) {
      if (state.isAudioLoading) return;
      if (state.isPlaying) {
        await playbackService.pause();
      } else {
        await playbackService.resume();
      }
      return;
    }

    final matches = state.audioList.where((a) => a.id == audioId);
    if (matches.isEmpty) return;
    final track = matches.first;
    final hadiName = state.hadiById(track.hadiId)?.name ?? 'Hadi';

    final requestId = ++_requestId;
    sessionCoordinator.claim(AudioSessionOwner.hadi);
    emit(
      state.copyWith(
        playingAudioId: audioId,
        isAudioLoading: true,
        isPlaying: false,
      ),
    );
    try {
      await playbackService.load(
        AudioPlaybackRequest(
          id: 'hadi-audio-${track.id}',
          url: track.mediaUrl,
          title: track.chapterTitle,
          subtitle: '$hadiName · Ayat ${track.verseNumber}',
        ),
      );
    } on Object catch (e, stackTrace) {
      // Errors too, not only Exceptions: whatever is thrown, the spinner must
      // not stay stuck.
      appLogger.e(
        '[HadiDirectoryBloc] Audio playback failed',
        error: e,
        stackTrace: stackTrace,
      );
      if (!_isCurrent(requestId)) return;
      _emitCleared(emit);
      sessionCoordinator.release(AudioSessionOwner.hadi);
      return;
    }

    if (_isCurrent(requestId)) {
      emit(state.copyWith(isAudioLoading: false));
    } else {
      await _stopIfAbandoned();
    }
  }

  /// A stale load that still started playing is stopped if nobody wants it.
  /// The player is left alone when another feature or a newer Hadi track has
  /// it.
  Future<void> _stopIfAbandoned() async {
    final isAbandoned =
        sessionCoordinator.owner.value == AudioSessionOwner.none ||
        (_isOwner && (_isClosing || state.playingAudioId == null));
    if (isAbandoned) await _stopAndRelease();
  }

  Future<void> _stopAndRelease() async {
    final requestId = _requestId;
    await playbackService.stop();
    // A newer track claims the same owner token, so don't release its claim.
    if (requestId == _requestId) {
      sessionCoordinator.release(AudioSessionOwner.hadi);
    }
  }

  Future<void> _onStopAudio(Emitter<HadiDirectoryState> emit) async {
    _requestId++;
    final ownsPlayer = _isOwner;
    _emitCleared(emit);
    if (ownsPlayer) await _stopAndRelease();
  }

  /// Another feature claimed the shared player — just clear local state, the
  /// player itself is already mid-replacement.
  void _onOwnershipLost(Emitter<HadiDirectoryState> emit) {
    if (_isOwner || state.playingAudioId == null) return;
    _requestId++;
    _emitCleared(emit);
  }

  void _onPlayingChanged(
    Emitter<HadiDirectoryState> emit, {
    required bool isPlaying,
  }) {
    if (!_isOwner || state.playingAudioId == null) return;
    emit(state.copyWith(isPlaying: isPlaying));
  }

  void _emitCleared(Emitter<HadiDirectoryState> emit) => emit(
    state.copyWith(
      playingAudioId: null,
      isAudioLoading: false,
      isPlaying: false,
    ),
  );
}
