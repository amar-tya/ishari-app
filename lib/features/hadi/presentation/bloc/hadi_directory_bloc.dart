import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/usecases/usecase.dart';
import 'package:ishari/core/utils/app_logger.dart';
import 'package:ishari/features/hadi/domain/usecases/get_all_hadi.dart';
import 'package:ishari/features/hadi/domain/usecases/get_all_hadi_audio.dart';
import 'package:ishari/features/hadi/presentation/bloc/hadi_directory_event.dart';
import 'package:ishari/features/hadi/presentation/bloc/hadi_directory_state.dart';
import 'package:just_audio/just_audio.dart';

@lazySingleton
class HadiDirectoryBloc extends Bloc<HadiDirectoryEvent, HadiDirectoryState> {
  HadiDirectoryBloc({
    required this.getAllHadi,
    required this.getAllHadiAudio,
  }) : super(const HadiDirectoryState()) {
    on<HadiDirectoryEvent>((event, emit) async {
      await event.when(
        loadAll: (forceRefresh) => _onLoadAll(emit, forceRefresh: forceRefresh),
        searchChanged: (query) async =>
            emit(state.copyWith(searchQuery: query)),
        playTrack: (audioId) => _onPlayTrack(audioId, emit),
        stopAudio: () => _onStopAudio(emit),
      );
    });
  }

  final GetAllHadi getAllHadi;
  final GetAllHadiAudio getAllHadiAudio;

  final _audioPlayer = AudioPlayer();
  StreamSubscription<PlayerState>? _playerStateSubscription;

  @override
  Future<void> close() async {
    await _playerStateSubscription?.cancel();
    await _audioPlayer.dispose();
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

  Future<void> _onPlayTrack(
    int audioId,
    Emitter<HadiDirectoryState> emit,
  ) async {
    if (state.playingAudioId == audioId) {
      await _audioPlayer.stop();
      emit(state.copyWith(playingAudioId: null, isAudioLoading: false));
      return;
    }

    final matches = state.audioList.where((a) => a.id == audioId);
    if (matches.isEmpty) return;
    final track = matches.first;

    emit(state.copyWith(playingAudioId: audioId, isAudioLoading: true));
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setUrl(track.mediaUrl);

      await _playerStateSubscription?.cancel();
      _playerStateSubscription = _audioPlayer.playerStateStream.listen((
        playerState,
      ) {
        if (playerState.processingState == ProcessingState.completed) {
          add(const HadiDirectoryEvent.stopAudio());
        }
      });

      _audioPlayer.play().ignore();
      emit(state.copyWith(playingAudioId: audioId, isAudioLoading: false));
    } on Exception catch (e, stackTrace) {
      appLogger.e(
        '[HadiDirectoryBloc] Audio playback failed',
        error: e,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(playingAudioId: null, isAudioLoading: false));
    }
  }

  Future<void> _onStopAudio(Emitter<HadiDirectoryState> emit) async {
    await _audioPlayer.stop();
    emit(state.copyWith(playingAudioId: null, isAudioLoading: false));
  }
}
