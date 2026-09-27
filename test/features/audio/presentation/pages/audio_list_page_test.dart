// Only covers loaded/empty rendering — play/pause/seek behavior is covered
// at the bloc level in audio_list_bloc_test.dart. Keeps the sample dataset
// under 5 items so the native ad slot (AdMob platform channel) never
// renders either.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/core/audio/audio_session_coordinator.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/audio/domain/entities/audio_track_entity.dart';
import 'package:ishari/features/audio/domain/repositories/audio_repository.dart';
import 'package:ishari/features/audio/domain/usecases/get_all_audio_tracks.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_list_bloc.dart';
import 'package:ishari/features/audio/presentation/pages/audio_list_page.dart';
import 'package:ishari/injection_container.dart';

import '../../fakes/fake_audio_playback_service.dart';

class _FakeAudioRepository implements AudioRepository {
  _FakeAudioRepository(this._result);
  final Either<Failure, List<AudioTrackEntity>> _result;

  @override
  Future<Either<Failure, List<AudioTrackEntity>>> getAllAudioTracks() async =>
      _result;
}

final _tracks = [
  AudioTrackEntity(
    id: 'a',
    title: 'Ya Rabbi Bil Mustafa',
    mediaUrl: 'https://example.com/a.mp3',
    createdAt: DateTime(2024),
    hadiName: 'Hadi Amir',
  ),
  AudioTrackEntity(
    id: 'b',
    title: 'Marhaban',
    mediaUrl: 'https://example.com/b.mp3',
    createdAt: DateTime(2024, 2),
  ),
];

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() {
    sl.registerFactory<AudioListBloc>(
      () => AudioListBloc(
        getAllAudioTracks: GetAllAudioTracks(
          _FakeAudioRepository(right(_tracks)),
        ),
        playbackService: FakeAudioPlaybackService(),
        sessionCoordinator: AudioSessionCoordinator(),
      ),
    );
  });

  tearDown(() async {
    if (sl.isRegistered<AudioListBloc>()) {
      await sl.unregister<AudioListBloc>();
    }
  });

  testWidgets('renders track titles once loaded', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AudioListPage()));
    await tester.pump();
    await tester.pump();

    expect(find.text('Ya Rabbi Bil Mustafa'), findsOneWidget);
    expect(find.text('Marhaban'), findsOneWidget);
  });

  testWidgets('shows empty state when search matches nothing', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: AudioListPage()));
    await tester.pump();
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'zzz-no-match');
    await tester.pump();

    expect(find.text('Tidak ada audio yang cocok.'), findsOneWidget);
    expect(find.text('Ya Rabbi Bil Mustafa'), findsNothing);
  });
}
