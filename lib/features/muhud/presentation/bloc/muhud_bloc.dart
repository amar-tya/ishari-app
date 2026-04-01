import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/features/muhud/domain/usecases/get_bookmarked_verse_ids.dart';
import 'package:ishari/features/muhud/domain/usecases/get_chapter_by_id.dart';
import 'package:ishari/features/muhud/domain/usecases/get_verses_by_chapter.dart';
import 'package:ishari/features/muhud/domain/usecases/toggle_bookmark.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_event.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_state.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

// SharedPreferences keys for reader font size settings
const _kArabFontSize = 'muhud_arab_font_size';
const _kTransliterationFontSize = 'muhud_transliteration_font_size';
const _kTranslationFontSize = 'muhud_translation_font_size';

@injectable
class MuhudBloc extends Bloc<MuhudEvent, MuhudState> {
  MuhudBloc({
    required this.getVersesByChapter,
    required this.toggleBookmark,
    required this.getBookmarkedVerseIds,
    required this.getChapterById,
    required this.prefs,
  }) : super(const MuhudState.initial()) {
    on<MuhudEvent>((event, emit) async {
      await event.when(
        loadChapter: (chapterId, userId) =>
            _onLoadChapter(chapterId, userId, emit),
        toggleTranslation: () async => _onToggleTranslation(emit),
        toggleBookmark: (verseId, note) async =>
            _onToggleBookmark(verseId, note, emit),
        playVerse: (verseId, hadiId, recitationType, mediaId) =>
            _onPlayVerse(verseId, mediaId, emit),
        stopAudio: () => _onStopAudio(emit),
        toggleArabic: () async => _onToggleArabic(emit),
        toggleTransliteration: () async => _onToggleTransliteration(emit),
        setArabFontSize: (size) async => _onSetArabFontSize(size, emit),
        setTransliterationFontSize: (size) async =>
            _onSetTransliterationFontSize(size, emit),
        setTranslationFontSize: (size) async =>
            _onSetTranslationFontSize(size, emit),
        resetFontSizes: () async => _onResetFontSizes(emit),
      );
    });
  }

  final GetVersesByChapter getVersesByChapter;
  final ToggleBookmark toggleBookmark;
  final GetBookmarkedVerseIds getBookmarkedVerseIds;
  final GetChapterById getChapterById;
  final SharedPreferences prefs;

  final _audioPlayer = AudioPlayer();
  StreamSubscription<PlayerState>? _playerStateSubscription;
  String _userId = '';

  @override
  Future<void> close() async {
    await _playerStateSubscription?.cancel();
    await _audioPlayer.dispose();
    return super.close();
  }

  Future<void> _onLoadChapter(
    int chapterId,
    String userId,
    Emitter<MuhudState> emit,
  ) async {
    debugPrint('[MuhudBloc] _onLoadChapter START - chapterId: $chapterId');
    _userId = userId;
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
      debugPrint(
        '[MuhudBloc] Verses result received: ${versesResult.fold((f) => 'Error: ${f.message}', (v) => '${v.length} verses')}',
      );

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
              debugPrint(
                '[MuhudBloc] Both chapter and verses loaded, emitting loaded state...',
              );
              emit(
                MuhudState.loaded(
                  chapter: chapter,
                  verses: verses,
                  bookmarkedVerseIds: const {},
                  showTranslation: true,
                  arabFontSize: prefs.getDouble(_kArabFontSize) ?? 22.0,
                  transliterationFontSize:
                      prefs.getDouble(_kTransliterationFontSize) ?? 11.0,
                  translationFontSize:
                      prefs.getDouble(_kTranslationFontSize) ?? 14.0,
                ),
              );
              debugPrint('[MuhudBloc] Loaded state emitted successfully');
            },
          );
        },
      );

      // Load bookmarks after initial state is emitted (non-blocking for UI)
      if (userId.isNotEmpty) {
        final bookmarksResult = await getBookmarkedVerseIds(userId);
        bookmarksResult.fold(
          (_) {}, // silent fail — tampil tanpa bookmark
          (ids) => state.mapOrNull(
            loaded: (l) => emit(l.copyWith(bookmarkedVerseIds: ids.toSet())),
          ),
        );
      }
    } on Exception catch (e, stackTrace) {
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

  void _onToggleArabic(Emitter<MuhudState> emit) {
    state.mapOrNull(
      loaded: (l) => emit(l.copyWith(showArabic: !l.showArabic)),
    );
  }

  void _onToggleTransliteration(Emitter<MuhudState> emit) {
    state.mapOrNull(
      loaded: (l) =>
          emit(l.copyWith(showTransliteration: !l.showTransliteration)),
    );
  }

  Future<void> _onToggleBookmark(
    int verseId,
    String? note,
    Emitter<MuhudState> emit,
  ) async {
    // Optimistic update
    final wasBookmarked =
        state.mapOrNull(
          loaded: (l) => l.bookmarkedVerseIds.contains(verseId),
        ) ??
        false;

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

    // Persist to Supabase (skip if guest)
    if (_userId.isEmpty) return;

    final result = await toggleBookmark(verseId, _userId, note: note);
    result.fold(
      (_) {
        // Revert optimistic update on failure
        state.mapOrNull(
          loaded: (l) {
            final reverted = Set<int>.from(l.bookmarkedVerseIds);
            if (wasBookmarked) {
              reverted.add(verseId);
            } else {
              reverted.remove(verseId);
            }
            emit(l.copyWith(bookmarkedVerseIds: reverted));
          },
        );
      },
      (_) {},
    );
  }

  Future<void> _onPlayVerse(
    int verseId,
    int mediaId,
    Emitter<MuhudState> emit,
  ) async {
    final future = state.mapOrNull(
      loaded: (l) async {
        final verse = l.verses.firstWhere((v) => v.verse.id == verseId);
        final media = verse.mediaList.where((m) => m.id == mediaId).firstOrNull;
        if (media == null) return;

        emit(l.copyWith(playingVerseId: verseId, isAudioLoading: true));
        try {
          await _audioPlayer.stop();
          await _audioPlayer.setUrl(media.mediaUrl);

          // Cancel previous listener dan setup baru
          await _playerStateSubscription?.cancel();
          _playerStateSubscription = _audioPlayer.playerStateStream.listen(
            (playerState) {
              if (playerState.processingState == ProcessingState.completed) {
                add(const MuhudEvent.stopAudio());
              }
            },
          );

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

  Future<void> _onSetArabFontSize(double size, Emitter<MuhudState> emit) async {
    state.mapOrNull(loaded: (l) => emit(l.copyWith(arabFontSize: size)));
    await prefs.setDouble(_kArabFontSize, size);
  }

  Future<void> _onSetTransliterationFontSize(
    double size,
    Emitter<MuhudState> emit,
  ) async {
    state.mapOrNull(
      loaded: (l) => emit(l.copyWith(transliterationFontSize: size)),
    );
    await prefs.setDouble(_kTransliterationFontSize, size);
  }

  Future<void> _onSetTranslationFontSize(
    double size,
    Emitter<MuhudState> emit,
  ) async {
    state.mapOrNull(
      loaded: (l) => emit(l.copyWith(translationFontSize: size)),
    );
    await prefs.setDouble(_kTranslationFontSize, size);
  }

  Future<void> _onResetFontSizes(Emitter<MuhudState> emit) async {
    state.mapOrNull(
      loaded: (l) => emit(
        l.copyWith(
          arabFontSize: 22,
          transliterationFontSize: 11,
          translationFontSize: 14,
        ),
      ),
    );
    await prefs.remove(_kArabFontSize);
    await prefs.remove(_kTransliterationFontSize);
    await prefs.remove(_kTranslationFontSize);
  }
}
