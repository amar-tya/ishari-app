import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/analytics/analytics_service.dart';
import 'package:ishari/core/audio/audio_session_coordinator.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
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
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Breaks outside the Either, as a bug or a platform error would.
class _ThrowingRepository extends FakeMuhudRepository {
  @override
  Future<Either<Failure, ChapterEntity>> getChapterById(int chapterId) async =>
      throw StateError('Bad state: row {"email":"reader@example.com"}');
}

Future<MuhudBloc> _bloc(FakeMuhudRepository repository) async {
  SharedPreferences.setMockInitialValues({});
  final bloc = MuhudBloc(
    getVersesByChapter: GetVersesByChapter(repository),
    toggleBookmark: ToggleBookmark(repository),
    getBookmarkedVerseIds: GetBookmarkedVerseIds(repository),
    getChapterById: GetChapterById(repository),
    prefs: await SharedPreferences.getInstance(),
    analytics: _FakeAnalytics(),
    playbackService: FakeAudioPlaybackService(),
    sessionCoordinator: AudioSessionCoordinator(),
  );
  addTearDown(bloc.close);
  return bloc;
}

void main() {
  test('an unexpected error shows a general text, not the error', () async {
    final bloc = await _bloc(_ThrowingRepository());

    bloc.add(const MuhudEvent.loadChapter(chapterId: 1, userId: 'u'));
    await pumpEventQueue();

    expect(
      bloc.state,
      const MuhudState.error(message: FailureMessages.unknown),
    );
  });

  test('a failure from the repository keeps its own text', () async {
    final bloc = await _bloc(_FailingRepository());

    bloc.add(const MuhudEvent.loadChapter(chapterId: 1, userId: 'u'));
    await pumpEventQueue();

    expect(
      bloc.state,
      const MuhudState.error(message: FailureMessages.forbidden),
    );
  });
}

class _FailingRepository extends FakeMuhudRepository {
  @override
  Future<Either<Failure, ChapterEntity>> getChapterById(int chapterId) async =>
      left(const ServerFailure(message: FailureMessages.forbidden));
}
