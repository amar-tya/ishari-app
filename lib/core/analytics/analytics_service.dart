import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AnalyticsService {
  AnalyticsService() : _analytics = FirebaseAnalytics.instance;

  final FirebaseAnalytics _analytics;

  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> logLogin() async {
    if (kDebugMode) return;
    await _analytics.logLogin(loginMethod: 'google');
  }

  Future<void> logChapterOpened({
    required String chapterId,
    required String chapterTitle,
  }) async {
    if (kDebugMode) return;
    await _analytics.logEvent(
      name: 'select_content',
      parameters: {
        'content_type': 'chapter',
        'item_id': chapterId,
        'item_name': chapterTitle,
      },
    );
  }

  Future<void> logCategorySelected({
    required String category,
    required String listName,
  }) async {
    if (kDebugMode) return;
    await _analytics.logEvent(
      name: 'select_item',
      parameters: {'item_list_name': listName, 'item_id': category},
    );
  }

  Future<void> logSearch({required String searchTerm}) async {
    if (kDebugMode) return;
    await _analytics.logSearch(searchTerm: searchTerm);
  }

  Future<void> logVerseAudioPlayed({
    required String chapterId,
    required int verseId,
    required String recitationType,
  }) async {
    if (kDebugMode) return;
    await _analytics.logEvent(
      name: 'verse_audio_played',
      parameters: {
        'chapter_id': chapterId,
        'verse_id': verseId,
        'recitation_type': recitationType,
      },
    );
  }

  Future<void> logVerseBookmarked({
    required String chapterId,
    required int verseId,
    required bool hasNote,
  }) async {
    if (kDebugMode) return;
    await _analytics.logEvent(
      name: 'verse_bookmarked',
      parameters: {
        'chapter_id': chapterId,
        'verse_id': verseId,
        'has_note': hasNote ? 1 : 0,
      },
    );
  }

}
