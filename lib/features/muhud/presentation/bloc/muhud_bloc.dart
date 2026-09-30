import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ishari/core/analytics/analytics_service.dart';
import 'package:ishari/core/audio/audio_session_coordinator.dart';
import 'package:ishari/core/utils/app_logger.dart';
import 'package:ishari/features/audio/domain/entities/audio_playback_request.dart';
import 'package:ishari/features/audio/domain/services/audio_playback_service.dart';
import 'package:ishari/features/muhud/domain/usecases/get_bookmarked_verse_ids.dart';
import 'package:ishari/features/muhud/domain/usecases/get_chapter_by_id.dart';
import 'package:ishari/features/muhud/domain/usecases/get_verses_by_chapter.dart';
import 'package:ishari/features/muhud/domain/usecases/toggle_bookmark.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_event.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_state.dart';
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
    required this.analytics,
    required this.playbackService,
    required this.sessionCoordinator,
  }) : super(const MuhudState.initial()) {
    on<MuhudEvent>((event, emit) async {
      await event.when(
        loadChapter: (chapterId, userId) =>
            _onLoadChapter(chapterId, userId, emit),
        toggleTranslation: () async => _onToggleTranslation(emit),
        toggleBookmark: (verseId, note) async =>
            _onToggleBookmark(verseId, note, emit),
        playVerse: (verseId, hadiId, recitationType, mediaId) =>
            _onPlayVerse(verseId, mediaId, recitationType.name, emit),
        stopAudio: () => _onStopAudio(emit),
        ownershipLost: () async => _onOwnershipLost(emit),
        toggleArabic: () async => _onToggleArabic(emit),
        toggleTransliteration: () async => _onToggleTransliteration(emit),
        setArabFontSize: (size) async => _onSetArabFontSize(size, emit),
        setTransliterationFontSize: (size) async =>
            _onSetTransliterationFontSize(size, emit),
        setTranslationFontSize: (size) async =>
            _onSetTranslationFontSize(size, emit),
        resetFontSizes: () async => _onResetFontSizes(emit),
        clearSnackbar: () async => state.mapOrNull(
          loaded: (l) => emit(l.copyWith(snackbarMessage: null)),
        ),
      );
    });

    _completedSubscription = playbackService.completedStream.listen((_) {
      if (_isOwner) add(const MuhudEvent.stopAudio());
    });
    _ownerListener = () {
      if (!_isOwner) add(const MuhudEvent.ownershipLost());
    };
    sessionCoordinator.owner.addListener(_ownerListener);
  }

  final GetVersesByChapter getVersesByChapter;
  final ToggleBookmark toggleBookmark;
  final GetBookmarkedVerseIds getBookmarkedVerseIds;
  final GetChapterById getChapterById;
  final SharedPreferences prefs;
  final AnalyticsService analytics;
  final AudioPlaybackService playbackService;
  final AudioSessionCoordinator sessionCoordinator;

  late final StreamSubscription<void> _completedSubscription;
  late final VoidCallback _ownerListener;
  String _userId = '';

  bool get _isOwner =>
      sessionCoordinator.owner.value == AudioSessionOwner.muhudVerse;

  @override
  Future<void> close() async {
    sessionCoordinator.owner.removeListener(_ownerListener);
    await _completedSubscription.cancel();
    return super.close();
  }

  Future<void> _onLoadChapter(
    int chapterId,
    String userId,
    Emitter<MuhudState> emit,
  ) async {
    appLogger.d('[MuhudBloc] _onLoadChapter START - chapterId: $chapterId');
    _userId = userId;
    emit(const MuhudState.loading());

    try {
      final chapterFuture = getChapterById(chapterId);
      final versesFuture = getVersesByChapter(chapterId);

      final chapterResult = await chapterFuture;
      final versesResult = await versesFuture;

      chapterResult.fold(
        (failure) {
          appLogger.w('[MuhudBloc] Chapter error: ${failure.message}');
          emit(MuhudState.error(message: failure.message));
        },
        (chapter) {
          versesResult.fold(
            (failure) {
              appLogger.w('[MuhudBloc] Verses error: ${failure.message}');
              emit(MuhudState.error(message: failure.message));
            },
            (verses) {
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
              unawaited(
                analytics.logChapterOpened(
                  chapterId: chapter.id.toString(),
                  chapterTitle: chapter.title,
                ),
              );
            },
          );
        },
      );

      // Load bookmarks after initial state is emitted (non-blocking for UI)
      if (userId.isNotEmpty) {
        final bookmarksResult = await getBookmarkedVerseIds(userId);
        bookmarksResult.fold(
          (failure) => appLogger.w(
            '[MuhudBloc] Bookmark load failed: ${failure.message}',
          ),
          (ids) => state.mapOrNull(
            loaded: (l) => emit(l.copyWith(bookmarkedVerseIds: ids.toSet())),
          ),
        );
      }
    } catch (e, stackTrace) {
      appLogger.e(
        '[MuhudBloc] Exception in _onLoadChapter',
        error: e,
        stackTrace: stackTrace,
      );
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
      (failure) {
        appLogger.w('[MuhudBloc] Bookmark toggle failed: ${failure.message}');
        state.mapOrNull(
          loaded: (l) {
            final reverted = Set<int>.from(l.bookmarkedVerseIds);
            if (wasBookmarked) {
              reverted.add(verseId);
            } else {
              reverted.remove(verseId);
            }
            emit(
              l.copyWith(
                bookmarkedVerseIds: reverted,
                snackbarMessage: 'Gagal menyimpan bookmark. Coba lagi.',
              ),
            );
          },
        );
      },
      (_) {
        if (!wasBookmarked) {
          final chapterId =
              state.mapOrNull(loaded: (l) => l.chapter.id.toString()) ?? '';
          unawaited(
            analytics.logVerseBookmarked(
              chapterId: chapterId,
              verseId: verseId,
              hasNote: note != null && note.isNotEmpty,
            ),
          );
        }
      },
    );
  }

  Future<void> _onPlayVerse(
    int verseId,
    int mediaId,
    String recitationType,
    Emitter<MuhudState> emit,
  ) async {
    final future = state.mapOrNull(
      loaded: (l) async {
        final verse = l.verses.firstWhere((v) => v.verse.id == verseId);
        final media = verse.mediaList.where((m) => m.id == mediaId).firstOrNull;
        if (media == null) return;

        sessionCoordinator.claim(AudioSessionOwner.muhudVerse);
        emit(l.copyWith(playingVerseId: verseId, isAudioLoading: true));
        try {
          await playbackService.load(
            AudioPlaybackRequest(
              id: 'muhud-verse-$verseId-$mediaId',
              url: media.mediaUrl,
              title: l.chapter.title,
              subtitle: 'Ayat $verseId',
            ),
          );
          emit(l.copyWith(playingVerseId: verseId, isAudioLoading: false));
          unawaited(
            analytics.logVerseAudioPlayed(
              chapterId: l.chapter.id.toString(),
              verseId: verseId,
              recitationType: recitationType,
            ),
          );
        } on Exception catch (e, stackTrace) {
          appLogger.e(
            '[MuhudBloc] Audio playback failed',
            error: e,
            stackTrace: stackTrace,
          );
          sessionCoordinator.release(AudioSessionOwner.muhudVerse);
          emit(
            l.copyWith(
              playingVerseId: null,
              isAudioLoading: false,
              snackbarMessage: 'Gagal memutar audio. Periksa koneksi internet.',
            ),
          );
        }
      },
    );
    if (future != null) await future;
  }

  Future<void> _onStopAudio(Emitter<MuhudState> emit) async {
    final future = state.mapOrNull(
      loaded: (l) async {
        await playbackService.stop();
        sessionCoordinator.release(AudioSessionOwner.muhudVerse);
        emit(l.copyWith(playingVerseId: null, isAudioLoading: false));
      },
    );
    if (future != null) await future;
  }

  /// The shared player was claimed by an audio-catalog track — just clear
  /// local state, the player itself is already mid-replacement.
  void _onOwnershipLost(Emitter<MuhudState> emit) {
    state.mapOrNull(
      loaded: (l) {
        if (l.playingVerseId == null) return;
        emit(l.copyWith(playingVerseId: null, isAudioLoading: false));
      },
    );
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
