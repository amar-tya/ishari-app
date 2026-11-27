import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/analytics/analytics_service.dart';
import 'package:ishari/core/audio/audio_session_coordinator.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/muhud/domain/usecases/get_bookmarked_verse_ids.dart';
import 'package:ishari/features/muhud/domain/usecases/get_chapter_by_id.dart';
import 'package:ishari/features/muhud/domain/usecases/get_verses_by_chapter.dart';
import 'package:ishari/features/muhud/domain/usecases/toggle_bookmark.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_bloc.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_event.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../audio/fakes/fake_audio_playback_service.dart';
import '../../fakes/fake_muhud_repository.dart';

class _FakeAnalytics implements AnalyticsService {
  final bookmarkedVerseIds = <int>[];

  @override
  Future<void> logChapterOpened({
    required String chapterId,
    required String chapterTitle,
  }) async {}

  @override
  Future<void> logVerseBookmarked({
    required String chapterId,
    required int verseId,
    required bool hasNote,
  }) async => bookmarkedVerseIds.add(verseId);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _FakeAnalytics analytics;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    analytics = _FakeAnalytics();
  });

  Future<MuhudBloc> loadedBloc(FakeMuhudRepository repository) async {
    final bloc = MuhudBloc(
      getVersesByChapter: GetVersesByChapter(repository),
      toggleBookmark: ToggleBookmark(repository),
      getBookmarkedVerseIds: GetBookmarkedVerseIds(repository),
      getChapterById: GetChapterById(repository),
      prefs: await SharedPreferences.getInstance(),
      analytics: analytics,
      playbackService: FakeAudioPlaybackService(),
      sessionCoordinator: AudioSessionCoordinator(),
    );
    addTearDown(bloc.close);
    bloc.add(const MuhudEvent.loadChapter(chapterId: 1, userId: 'u'));
    await pump();
    return bloc;
  }

  Set<int> ids(MuhudBloc bloc) =>
      bloc.state.mapOrNull(loaded: (l) => l.bookmarkedVerseIds)!;

  String? snackbar(MuhudBloc bloc) =>
      bloc.state.mapOrNull(loaded: (l) => l.snackbarMessage);

  Future<void> tap(MuhudBloc bloc, int verseId) async {
    bloc.add(MuhudEvent.toggleBookmark(verseId: verseId));
    await pump();
  }

  test('ignores a second tap while the first toggle is in flight', () async {
    final repository = FakeMuhudRepository();
    final bloc = await loadedBloc(repository);

    await tap(bloc, 5);
    await tap(bloc, 5);

    expect(repository.toggledVerseIds, [5]);
    expect(ids(bloc), {5});

    repository.toggles.single.complete(right(true));
    await pump();

    expect(ids(bloc), {5});
    expect(snackbar(bloc), isNull);
    expect(analytics.bookmarkedVerseIds, [5]);
  });

  test('allows toggles for different verses at the same time', () async {
    final repository = FakeMuhudRepository();
    final bloc = await loadedBloc(repository);

    await tap(bloc, 5);
    await tap(bloc, 6);

    expect(repository.toggledVerseIds, [5, 6]);
    expect(ids(bloc), {5, 6});
  });

  test('accepts a new toggle once the previous one succeeded', () async {
    final repository = FakeMuhudRepository();
    final bloc = await loadedBloc(repository);

    await tap(bloc, 5);
    repository.toggles.single.complete(right(true));
    await pump();
    await tap(bloc, 5);

    expect(repository.toggledVerseIds, [5, 5]);
    expect(ids(bloc), isEmpty);
  });

  test('rolls back a failed add and accepts a retry', () async {
    final repository = FakeMuhudRepository();
    final bloc = await loadedBloc(repository);

    await tap(bloc, 5);
    repository.toggles.single.complete(left(const ServerFailure()));
    await pump();

    expect(ids(bloc), isEmpty);
    expect(snackbar(bloc), isNotNull);

    await tap(bloc, 5);
    expect(repository.toggledVerseIds, [5, 5]);
  });

  test('rolls back a failed removal', () async {
    final repository = FakeMuhudRepository(bookmarkedIds: [5]);
    final bloc = await loadedBloc(repository);

    await tap(bloc, 5);
    expect(ids(bloc), isEmpty);

    repository.toggles.single.complete(left(const ServerFailure()));
    await pump();

    expect(ids(bloc), {5});
  });

  test('releases the in-flight entry when the use case throws', () async {
    final repository = FakeMuhudRepository();
    final errors = <Object>[];
    late MuhudBloc bloc;
    // The bloc rethrows handler errors into the zone it was created in.
    await runZonedGuarded(() async {
      bloc = await loadedBloc(repository);
      await tap(bloc, 5);
      repository.toggles.single.completeError(StateError('boom'));
      await pump();
      await tap(bloc, 5);
    }, (error, _) => errors.add(error));

    expect(errors.single, isStateError);
    expect(repository.toggledVerseIds, [5, 5]);
  });

  test('follows the server when an add turns out to be a removal', () async {
    final repository = FakeMuhudRepository();
    final bloc = await loadedBloc(repository);

    await tap(bloc, 5);
    repository.toggles.single.complete(right(false));
    await pump();

    expect(ids(bloc), isEmpty);
    expect(analytics.bookmarkedVerseIds, isEmpty);
  });

  test('follows the server when a removal turns out to be an add', () async {
    final repository = FakeMuhudRepository(bookmarkedIds: [5]);
    final bloc = await loadedBloc(repository);

    await tap(bloc, 5);
    repository.toggles.single.complete(right(true));
    await pump();

    expect(ids(bloc), {5});
    expect(analytics.bookmarkedVerseIds, isEmpty);
  });
}
