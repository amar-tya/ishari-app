// A tapped "audio baru" notification has to show the recording it announces,
// so these run the real audio page and bloc and count the repository calls.
// Fewer than 5 tracks keeps the native ad (a platform channel) out.
import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/core/audio/audio_session_coordinator.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/router/app_router.dart';
import 'package:ishari/features/audio/domain/entities/audio_track_entity.dart';
import 'package:ishari/features/audio/domain/repositories/audio_repository.dart';
import 'package:ishari/features/audio/domain/usecases/get_all_audio_tracks.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_list_bloc.dart';
import 'package:ishari/features/audio/presentation/pages/audio_list_page.dart';
import 'package:ishari/features/push_notification/data/services/notification_permission_prompter.dart';
import 'package:ishari/features/push_notification/presentation/notification_tap_navigator.dart';
import 'package:ishari/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../audio/fakes/fake_audio_playback_service.dart';
import 'fakes.dart';

typedef _Result = Either<Failure, List<AudioTrackEntity>>;

AudioTrackEntity _track(String title, int month) => AudioTrackEntity(
  id: title,
  title: title,
  mediaUrl: 'https://example.com/$month.mp3',
  createdAt: DateTime(2024, month),
);

const _oldTitle = 'Marhaban';
const _newTitle = 'Rekaman Baru';
final _before = [_track(_oldTitle, 1)];
final _after = [_track(_oldTitle, 1), _track(_newTitle, 2)];

class _CountingRepository implements AudioRepository {
  /// What the server has; read when a call is made, not when it completes.
  _Result published = right(_before);

  int calls = 0;

  /// While true, calls stay pending until [answer].
  bool hold = false;
  final _held = <int, void Function()>{};

  @override
  Future<_Result> getAllAudioTracks() {
    final call = ++calls;
    final result = published;
    if (!hold) return Future.value(result);
    final completer = Completer<_Result>();
    _held[call] = () => completer.complete(result);
    return completer.future;
  }

  /// Completes the held call number [call], counted from 1.
  void answer(int call) => _held.remove(call)!();
}

void main() {
  late _CountingRepository repository;
  late AudioListBloc bloc;
  late NotificationTapNavigator navigator;
  late GoRouter router;

  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  setUp(() async {
    // Reset here, not in tearDown: the audio page still looks its bloc up
    // while the previous test's tree is being unmounted.
    await sl.reset();
    SharedPreferences.setMockInitialValues({});
    sl.registerSingleton<NotificationPermissionPrompter>(
      NotificationPermissionPrompter(
        FakePushMessagingClient()..status = AuthorizationStatus.authorized,
        await SharedPreferences.getInstance(),
      ),
    );
  });

  tearDown(() => navigator.dispose());

  Future<void> pumpApp(WidgetTester tester) async {
    // Made inside the test so that their futures run on its fake clock.
    repository = _CountingRepository();
    bloc = AudioListBloc(
      getAllAudioTracks: GetAllAudioTracks(repository),
      playbackService: FakeAudioPlaybackService(),
      sessionCoordinator: AudioSessionCoordinator(),
    );
    sl.registerSingleton<AudioListBloc>(bloc);
    navigator = NotificationTapNavigator(bloc);
    GoRoute plain(String path) => GoRoute(
      path: path,
      builder: (_, __) => Scaffold(body: Text(path)),
    );
    router = GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: '/home',
      routes: [
        plain('/home'),
        plain('/chapter/:chapterId'),
        GoRoute(path: '/audio', builder: (_, __) => const AudioListPage()),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
  }

  /// Frames only: a loading spinner would keep `pumpAndSettle` waiting.
  Future<void> frames(WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> openFromApp(WidgetTester tester) async {
    unawaited(router.push('/audio'));
    await frames(tester);
  }

  Future<void> visitAndLeave(WidgetTester tester) async {
    await openFromApp(tester);
    router.pop();
    await frames(tester);
  }

  Future<void> tapNotification(
    WidgetTester tester, [
    String path = '/audio',
  ]) async {
    navigator.open(path);
    await frames(tester);
  }

  testWidgets('fetches again after an earlier visit and shows the new '
      'recording', (tester) async {
    await pumpApp(tester);
    await visitAndLeave(tester);
    repository.published = right(_after);

    await tapNotification(tester);

    expect(repository.calls, 2);
    expect(find.text(_newTitle), findsWidgets);
  });

  testWidgets('fetches again when the audio list is already on top', (
    tester,
  ) async {
    await pumpApp(tester);
    await openFromApp(tester);
    repository.published = right(_after);

    await tapNotification(tester);

    expect(repository.calls, 2);
    expect(find.text(_newTitle), findsWidgets);
  });

  testWidgets('keeps the loaded list on screen while fetching', (tester) async {
    await pumpApp(tester);
    await visitAndLeave(tester);
    repository
      ..published = right(_after)
      ..hold = true;

    await tapNotification(tester);

    expect(repository.calls, 2);
    expect(find.text(_oldTitle), findsWidgets);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    repository.answer(2);
    await frames(tester);
    expect(find.text(_newTitle), findsWidgets);
  });

  testWidgets('keeps the loaded list when the fetch fails', (tester) async {
    await pumpApp(tester);
    await visitAndLeave(tester);
    repository.published = left(const NetworkFailure());

    await tapNotification(tester);

    expect(repository.calls, 2);
    expect(find.text(_oldTitle), findsWidgets);
  });

  testWidgets('a load already in flight does not stand in for the new one, '
      'nor overwrite it when it finishes last', (tester) async {
    await pumpApp(tester);
    repository.hold = true;
    await openFromApp(tester);
    expect(repository.calls, 1);
    repository.published = right(_after);

    await tapNotification(tester);
    expect(repository.calls, 2);

    repository.answer(2);
    await frames(tester);
    expect(find.text(_newTitle), findsWidgets);

    // The older request still carries the list from before the upload.
    repository.answer(1);
    await frames(tester);
    expect(find.text(_newTitle), findsWidgets);
  });

  testWidgets('an older load that finishes first does not end the wait', (
    tester,
  ) async {
    await pumpApp(tester);
    repository.hold = true;
    await openFromApp(tester);
    repository.published = right(_after);
    await tapNotification(tester);

    repository.answer(1);
    await frames(tester);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    repository.answer(2);
    await frames(tester);
    expect(find.text(_newTitle), findsWidgets);
  });

  testWidgets('the first visit through a notification fetches once', (
    tester,
  ) async {
    await pumpApp(tester);

    await tapNotification(tester);

    expect(repository.calls, 1);
    expect(find.text(_oldTitle), findsWidgets);
  });

  testWidgets('opening the list from inside the app still uses what is '
      'loaded', (tester) async {
    await pumpApp(tester);
    await visitAndLeave(tester);
    repository.published = right(_after);

    await openFromApp(tester);

    expect(repository.calls, 1);
    expect(find.text(_newTitle), findsNothing);
  });

  testWidgets('a notification for a verse leaves the audio list alone', (
    tester,
  ) async {
    await pumpApp(tester);

    await tapNotification(tester, '/chapter/3?verseId=9');

    expect(repository.calls, 0);
  });
}
