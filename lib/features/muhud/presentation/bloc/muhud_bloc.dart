import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/features/muhud/domain/entities/verse_media_type.dart';
import 'package:ishari/features/muhud/domain/usecases/get_bookmarked_verse_ids.dart';
import 'package:ishari/features/muhud/domain/usecases/get_chapter_by_id.dart';
import 'package:ishari/features/muhud/domain/usecases/get_verses_by_chapter.dart';
import 'package:ishari/features/muhud/domain/usecases/toggle_bookmark.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_event.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_state.dart';
import 'package:just_audio/just_audio.dart';

@injectable
class MuhudBloc extends Bloc<MuhudEvent, MuhudState> {
  MuhudBloc({
    required this.getVersesByChapter,
    required this.toggleBookmark,
    required this.getBookmarkedVerseIds,
    required this.getChapterById,
  }) : super(const MuhudState.initial()) {
    on<MuhudEvent>((event, emit) async {
      await event.when(
        loadChapter: (chapterId) => _onLoadChapter(chapterId, emit),
        toggleTranslation: () async => _onToggleTranslation(emit),
        toggleBookmark: (verseId) async => _onToggleBookmark(verseId, emit),
        playVerse: (verseId, hadiId, recitationType) =>
            _onPlayVerse(verseId, hadiId, recitationType, emit),
        stopAudio: () => _onStopAudio(emit),
      );
    });
  }

  final GetVersesByChapter getVersesByChapter;
  final ToggleBookmark toggleBookmark;
  final GetBookmarkedVerseIds getBookmarkedVerseIds;
  final GetChapterById getChapterById;

  final _audioPlayer = AudioPlayer();

  @override
  Future<void> close() async {
    await _audioPlayer.dispose();
    return super.close();
  }

  Future<void> _onLoadChapter(int chapterId, Emitter<MuhudState> emit) async {
    debugPrint('[MuhudBloc] _onLoadChapter START - chapterId: $chapterId');
    emit(const MuhudState.loading());

    try {
      debugPrint('[MuhudBloc] Starting chapter and verses requests...');
      final chapterFuture = getChapterById(chapterId);
      final versesFuture = getVersesByChapter(chapterId);

      debugPrint('[MuhudBloc] Waiting for chapter result...');
      final chapterResult = await chapterFuture;
      debugPrint('[MuhudBloc] Chapter result received: $chapterResult');

      debugPrint('[MuhudBloc] Waiting for verses result...');
      final versesResult = await versesFuture;
      debugPrint('[MuhudBloc] Verses result received: ${versesResult.fold((f) => 'Error: ${f.message}', (v) => '${v.length} verses')}');

      chapterResult.fold(
        (failure) {
          debugPrint('[MuhudBloc] Chapter error: ${failure.message}');
          emit(MuhudState.error(message: failure.message));
        },
        (chapter) {
          debugPrint('[MuhudBloc] Chapter loaded: ${chapter.title}');
          versesResult.fold(
            (failure) {
              debugPrint('[MuhudBloc] Verses error: ${failure.message}');
              emit(MuhudState.error(message: failure.message));
            },
            (verses) {
              debugPrint('[MuhudBloc] Both chapter and verses loaded, emitting loaded state...');
              emit(
                MuhudState.loaded(
                  chapter: chapter,
                  verses: verses,
                  bookmarkedVerseIds: const {},
                  showTranslation: true,
                ),
              );
              debugPrint('[MuhudBloc] Loaded state emitted successfully');
            },
          );
        },
      );
    } catch (e, stackTrace) {
      debugPrint('[MuhudBloc] Exception in _onLoadChapter: $e');
      debugPrint('[MuhudBloc] StackTrace: $stackTrace');
      emit(MuhudState.error(message: 'Error: $e'));
    }
  }

  void _onToggleTranslation(Emitter<MuhudState> emit) {
    state.mapOrNull(
      loaded: (l) => emit(l.copyWith(showTranslation: !l.showTranslation)),
    );
  }

  void _onToggleBookmark(int verseId, Emitter<MuhudState> emit) {
    state.mapOrNull(
      loaded: (l) {
        final updated = Set<int>.from(l.bookmarkedVerseIds);
        if (updated.contains(verseId)) {
          updated.remove(verseId);
        } else {
          updated.add(verseId);
        }
        emit(l.copyWith(bookmarkedVerseIds: updated));
      },
    );
  }

  Future<void> _onPlayVerse(
    int verseId,
    String hadiId,
    VerseMediaType recitationType,
    Emitter<MuhudState> emit,
  ) async {
    final future = state.mapOrNull(
      loaded: (l) async {
        final verse = l.verses.firstWhere((v) => v.verse.id == verseId);
        final media = verse.mediaList
            .where((m) => m.hadi.id == hadiId && m.type == recitationType)
            .firstOrNull;
        if (media == null) return;

        emit(l.copyWith(playingVerseId: verseId, isAudioLoading: true));
        try {
          await _audioPlayer.stop();
          await _audioPlayer.setUrl(media.mediaUrl);
          _audioPlayer.play().ignore();
          emit(l.copyWith(playingVerseId: verseId, isAudioLoading: false));
        } on Exception catch (_) {
          emit(l.copyWith(playingVerseId: null, isAudioLoading: false));
        }
      },
    );
    if (future != null) await future;
  }

  Future<void> _onStopAudio(Emitter<MuhudState> emit) async {
    final future = state.mapOrNull(
      loaded: (l) async {
        await _audioPlayer.stop();
        emit(l.copyWith(playingVerseId: null, isAudioLoading: false));
      },
    );
    if (future != null) await future;
  }
}
