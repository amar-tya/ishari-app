// Characterization tests for the chapter reader (issue #40). They record what
// the reader does today, including behaviour that looks wrong, so a refactor
// cannot change it unnoticed.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/wizard/wizard_cubit.dart';
import 'package:ishari/core/wizard/wizard_state.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/muhud/domain/entities/verse_media_type.dart';
import 'package:ishari/features/muhud/domain/entities/verse_with_details_entity.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_bloc.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_event.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_state.dart';
import 'package:ishari/features/muhud/presentation/bloc/split_panel_cubit.dart';
import 'package:ishari/features/muhud/presentation/widgets/chapter_app_bar.dart';
import 'package:ishari/features/muhud/presentation/widgets/chapter_reader_body.dart';
import 'package:ishari/features/muhud/presentation/widgets/verse_card.dart';

import '../../../../shared/reader/reader_test_harness.dart';

class _RecordingMuhudBloc extends Fake implements MuhudBloc {
  final events = <MuhudEvent>[];

  @override
  void add(MuhudEvent event) => events.add(event);

  @override
  MuhudState get state => const MuhudState.initial();

  @override
  Stream<MuhudState> get stream => const Stream.empty();

  @override
  bool get isClosed => false;

  @override
  Future<void> close() async {}
}

const _chapter = ChapterEntity(
  id: '1',
  title: 'Bab Satu',
  category: 'Diwan',
  description: 'judul-arab',
  verseCount: 10,
  number: 3,
);

const _appBarBottom = statusBarHeight + 52;
const _headerHeight = 170.0;

class _Settings {
  const _Settings({
    this.showArabic = true,
    this.showTransliteration = true,
    this.showTranslation = true,
  });

  final bool showArabic;
  final bool showTransliteration;
  final bool showTranslation;
}

void main() {
  late _RecordingMuhudBloc bloc;
  late ReaderRepository repository;
  late WizardCubit wizard;
  late GoRouter router;

  setUp(() {
    bloc = _RecordingMuhudBloc();
    repository = ReaderRepository(
      chapters: const [pairedDibaChapter],
      verses: [verseWithDetails(901), verseWithDetails(902, withAudio: true)],
    );
    wizard = inactiveWizard();
  });

  Future<void> pumpReader(
    WidgetTester tester, {
    ChapterEntity chapter = _chapter,
    List<VerseWithDetailsEntity>? verses,
    Set<int> bookmarked = const {},
    int? playingVerseId,
    int? initialVerseId,
    bool isEmbeddedInTab = false,
    _Settings settings = const _Settings(),
  }) async {
    useReaderScreen(tester);
    final cubit = splitPanelCubit(repository);
    addTearDown(cubit.close);
    addTearDown(wizard.close);

    router = GoRouter(
      initialLocation: '/home/reader',
      routes: [
        GoRoute(
          path: '/home',
          builder: (_, _) => const Scaffold(body: Text('halaman-home')),
          routes: [
            GoRoute(
              path: 'reader',
              builder: (_, _) => MultiBlocProvider(
                providers: [
                  BlocProvider<MuhudBloc>.value(value: bloc),
                  BlocProvider<SplitPanelCubit>.value(value: cubit),
                ],
                child: ChapterReaderBody(
                  chapter: chapter,
                  verses:
                      verses ??
                      [
                        verseWithDetails(1, withAudio: true),
                        for (var id = 2; id <= 10; id++) verseWithDetails(id),
                      ],
                  initialVerseId: initialVerseId,
                  bookmarkedVerseIds: bookmarked,
                  showTranslation: settings.showTranslation,
                  showArabic: settings.showArabic,
                  showTransliteration: settings.showTransliteration,
                  arabFontSize: 23,
                  transliterationFontSize: 13,
                  translationFontSize: 15,
                  playingVerseId: playingVerseId,
                  isEmbeddedInTab: isEmbeddedInTab,
                ),
              ),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      BlocProvider<WizardCubit>.value(
        value: wizard,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pump();
  }

  Finder card(int verseId) => find.byWidgetPredicate(
    (w) => w is VerseCard && w.verse.verse.id == verseId,
    description: 'VerseCard $verseId',
  );

  Finder inCard(int verseId, Finder matching) =>
      find.descendant(of: card(verseId), matching: matching);

  VerseCard cardWidget(WidgetTester tester, int verseId) =>
      tester.widget<VerseCard>(card(verseId));

  final verseSheet = find.byType(CustomScrollView);
  final splitButton = find.text('Diba / Diwan');
  final divider = find.byWidgetPredicate(
    (w) => w is GestureDetector && w.onPanUpdate != null,
    description: 'split divider',
  );

  double titleOpacity(WidgetTester tester) => tester
      .widget<AnimatedOpacity>(
        find.descendant(
          of: find.byType(ChapterAppBar),
          matching: find.byType(AnimatedOpacity),
        ),
      )
      .opacity;

  Future<void> openSplit(WidgetTester tester) async {
    await tester.tap(splitButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  group('header and verse list', () {
    testWidgets('shows the header above the verse sheet', (tester) async {
      await pumpReader(tester);

      expect(find.text('DIWAN • 10 BAIT'), findsOneWidget);
      expect(find.text('judul-arab'), findsOneWidget);
      expect(find.text('Kitab Diwan'), findsOneWidget);
      expect(
        tester.getTopLeft(verseSheet),
        const Offset(0, _appBarBottom + _headerHeight),
      );
      expect(tester.getBottomLeft(verseSheet).dy, screenSize.height);
      expect(
        tester.widget<CustomScrollView>(verseSheet).physics,
        isA<ClampingScrollPhysics>(),
      );
    });

    testWidgets('header kicker says DIWAN for every category', (tester) async {
      await pumpReader(
        tester,
        chapter: _chapter.copyWith(category: 'Diba'),
      );

      expect(find.text('DIWAN • 10 BAIT'), findsOneWidget);
      expect(find.text('Kitab Diba'), findsOneWidget);
    });

    testWidgets('scrolling collapses the header and reveals the title', (
      tester,
    ) async {
      await pumpReader(tester);
      final controller = tester
          .widget<CustomScrollView>(verseSheet)
          .controller!;
      expect(titleOpacity(tester), 0);

      controller.jumpTo(100);
      await tester.pump();
      expect(
        tester.getTopLeft(verseSheet).dy,
        _appBarBottom + _headerHeight - 100,
      );
      expect(titleOpacity(tester), 0);

      controller.jumpTo(300);
      await tester.pump();
      expect(tester.getTopLeft(verseSheet).dy, _appBarBottom);
      expect(titleOpacity(tester), 1);
      final clip = tester.widget<ClipRRect>(
        find.ancestor(of: verseSheet, matching: find.byType(ClipRRect)),
      );
      expect(clip.borderRadius, BorderRadius.zero);
    });

    testWidgets('passes display settings to every verse', (tester) async {
      await pumpReader(
        tester,
        settings: const _Settings(
          showArabic: false,
          showTransliteration: false,
          showTranslation: false,
        ),
      );

      final first = cardWidget(tester, 1);
      expect(first.showArabic, isFalse);
      expect(first.showTransliteration, isFalse);
      expect(first.showTranslation, isFalse);
      expect(first.arabFontSize, 23);
      expect(first.transliterationFontSize, 13);
      expect(first.translationFontSize, 15);
      expect(find.text('arab-1'), findsNothing);
      expect(find.text('latin-1'), findsNothing);
      expect(find.text('arti-1'), findsNothing);
    });

    testWidgets('shows the translation when enabled', (tester) async {
      await pumpReader(tester);

      expect(inCard(1, find.text('TERJEMAHAN')), findsOneWidget);
      expect(inCard(1, find.text('arti-1')), findsOneWidget);
    });

    testWidgets('scrolls once to the deep-linked verse', (tester) async {
      await pumpReader(tester, initialVerseId: 8);
      await tester.pumpAndSettle();

      final top = tester.getTopLeft(card(8)).dy;
      expect(top, greaterThan(_appBarBottom));
      expect(top, lessThan(screenSize.height / 2));
      expect(titleOpacity(tester), 1);
    });

    testWidgets('stays at the top without a deep-linked verse', (tester) async {
      await pumpReader(tester);
      await tester.pumpAndSettle();

      expect(
        tester.getTopLeft(card(1)).dy,
        _appBarBottom + _headerHeight,
      );
    });
  });

  group('app bar', () {
    testWidgets('back pops to the page below', (tester) async {
      await pumpReader(tester);

      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      await tester.pumpAndSettle();

      expect(find.text('halaman-home'), findsOneWidget);
    });

    testWidgets('hides back when embedded in a tab', (tester) async {
      await pumpReader(tester, isEmbeddedInTab: true);

      expect(find.byIcon(Icons.arrow_back_ios_new), findsNothing);
    });

    testWidgets('has no split button outside Diwan and Diba', (tester) async {
      await pumpReader(
        tester,
        chapter: _chapter.copyWith(category: 'Muhud'),
      );

      expect(splitButton, findsNothing);
    });
  });

  group('bookmarking', () {
    testWidgets('marks only bookmarked verses', (tester) async {
      await pumpReader(tester, bookmarked: {2});

      expect(cardWidget(tester, 1).isBookmarked, isFalse);
      expect(cardWidget(tester, 2).isBookmarked, isTrue);
      expect(inCard(2, find.byIcon(Icons.bookmark)), findsOneWidget);
    });

    testWidgets('removes a bookmark without asking', (tester) async {
      await pumpReader(tester, bookmarked: {1});

      await tester.tap(inCard(1, find.byIcon(Icons.bookmark)));
      await tester.pump();

      expect(bloc.events, [const MuhudEvent.toggleBookmark(verseId: 1)]);
    });

    testWidgets('adds a bookmark with the note from the sheet', (tester) async {
      await pumpReader(tester);

      await tester.tap(inCard(1, find.byIcon(Icons.bookmark_outline)));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), ' catatan ');
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(bloc.events, [
        const MuhudEvent.toggleBookmark(verseId: 1, note: 'catatan'),
      ]);
    });

    testWidgets('adds nothing when the sheet is cancelled', (tester) async {
      await pumpReader(tester);

      await tester.tap(inCard(1, find.byIcon(Icons.bookmark_outline)));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();

      expect(bloc.events, isEmpty);
    });
  });

  group('audio', () {
    testWidgets('offers play only for verses with audio', (tester) async {
      await pumpReader(tester);

      expect(inCard(1, find.byIcon(Icons.play_arrow_rounded)), findsOneWidget);
      expect(inCard(2, find.byIcon(Icons.play_arrow_rounded)), findsNothing);
    });

    testWidgets('plays the recitation picked in the sheet', (tester) async {
      await pumpReader(tester);

      await tester.tap(inCard(1, find.byIcon(Icons.play_arrow_rounded)));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Putar'));
      await tester.pumpAndSettle();

      expect(bloc.events, [
        const MuhudEvent.playVerse(
          verseId: 1,
          hadiId: 'h1',
          recitationType: VerseMediaType.yahum,
          mediaId: 101,
        ),
      ]);
    });

    testWidgets('shows the playing verse as pausable', (tester) async {
      await pumpReader(tester, playingVerseId: 1);

      expect(cardWidget(tester, 1).isPlaying, isTrue);
      expect(cardWidget(tester, 2).isPlaying, isFalse);

      await tester.tap(inCard(1, find.byIcon(Icons.pause_rounded)));
      await tester.pump();

      expect(bloc.events, [const MuhudEvent.stopAudio()]);
    });
  });

  group('quick tools', () {
    Future<void> openPanel(WidgetTester tester) async {
      await tester.tap(find.byIcon(Icons.tune_rounded));
      await tester.pump();
    }

    Finder switchFor(String label) => find.descendant(
      of: find
          .ancestor(of: find.text(label), matching: find.byType(Container))
          .first,
      matching: find.byType(Switch),
    );

    testWidgets('lists three toggles and three font sliders', (tester) async {
      await pumpReader(tester);
      await openPanel(tester);

      for (final text in [
        'Quick Tools',
        'Konten',
        'Arab',
        'Tampilkan teks Arab',
        'Transliterasi',
        'Tampilkan latin',
        'Terjemahan',
        'ID',
        'Pengaturan Font',
        'Font Arab',
        'Scheherazade New',
        'Ukuran Font Arab',
        'Ukuran Font Transliterasi',
        'Ukuran Font Terjemahan',
        'Reset ke Default',
      ]) {
        expect(find.text(text), findsOneWidget, reason: text);
      }
      expect(find.byType(Divider), findsNWidgets(4));
      final sliders = tester.widgetList<Slider>(find.byType(Slider)).toList();
      expect(
        [for (final s in sliders) (s.value, s.min, s.max, s.divisions)],
        [(23, 16, 36, 20), (13, 8, 18, 10), (15, 10, 22, 12)],
      );
    });

    testWidgets('sends every change to MuhudBloc', (tester) async {
      await pumpReader(tester);
      await openPanel(tester);

      await tester.tap(switchFor('Arab'));
      await tester.tap(switchFor('Transliterasi'));
      await tester.tap(switchFor('Terjemahan'));
      final sliders = tester.widgetList<Slider>(find.byType(Slider)).toList();
      sliders[0].onChanged!(30);
      sliders[1].onChanged!(14);
      sliders[2].onChanged!(18);
      await tester.tap(find.text('Reset ke Default'));

      expect(bloc.events, [
        const MuhudEvent.toggleArabic(),
        const MuhudEvent.toggleTransliteration(),
        const MuhudEvent.toggleTranslation(),
        const MuhudEvent.setArabFontSize(30),
        const MuhudEvent.setTransliterationFontSize(14),
        const MuhudEvent.setTranslationFontSize(18),
        const MuhudEvent.resetFontSizes(),
      ]);
    });

    testWidgets('covers the screen and closes from scrim and button', (
      tester,
    ) async {
      await pumpReader(tester);
      await openPanel(tester);

      await tester.tapAt(const Offset(20, 450));
      await tester.pump();
      expect(find.text('Quick Tools'), findsNothing);

      await openPanel(tester);
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();
      expect(find.text('Quick Tools'), findsNothing);
    });

    testWidgets('keeps taps inside the panel', (tester) async {
      await pumpReader(tester);
      await openPanel(tester);

      await tester.tap(find.text('Konten'));
      await tester.pump();

      expect(find.text('Quick Tools'), findsOneWidget);
    });
  });

  group('split view', () {
    testWidgets('shows both chapters with headings', (tester) async {
      await pumpReader(tester);
      await openSplit(tester);

      expect(find.text('judul-arab'), findsNothing);
      expect(find.text('DIWAN'), findsOneWidget);
      expect(find.text('10 bait'), findsOneWidget);
      expect(find.text('DIBA'), findsOneWidget);
      expect(find.text('2 bait'), findsOneWidget);
      expect(repository.requestedChapterIds, [9]);
      expect(card(1), findsOneWidget);
      expect(card(901), findsOneWidget);
      expect(titleOpacity(tester), 1);
    });

    testWidgets('closes back to the header and keeps the paired chapter', (
      tester,
    ) async {
      await pumpReader(tester);
      await openSplit(tester);
      await openSplit(tester);
      expect(find.text('judul-arab'), findsOneWidget);
      expect(card(901), findsNothing);

      await openSplit(tester);

      expect(card(901), findsOneWidget);
      expect(repository.requestedChapterIds, [9]);
    });

    testWidgets('paired verses follow settings but ignore taps', (
      tester,
    ) async {
      await pumpReader(tester);
      await openSplit(tester);

      final paired = cardWidget(tester, 902);
      expect(paired.showTranslation, isTrue);
      expect(paired.arabFontSize, 23);
      expect(paired.transliterationFontSize, 13);
      expect(paired.translationFontSize, 15);
      expect(paired.isBookmarked, isFalse);
      expect(paired.isPlaying, isFalse);

      await tester.tap(inCard(902, find.byIcon(Icons.play_arrow_rounded)));
      await tester.tap(inCard(902, find.byIcon(Icons.bookmark_outline)));
      await tester.pumpAndSettle();

      expect(bloc.events, isEmpty);
      expect(find.byType(BottomSheet), findsNothing);

      final list = tester.widget<ListView>(find.byType(ListView));
      expect(list.padding, isNull);
      expect(list.physics, isA<ClampingScrollPhysics>());
    });

    testWidgets('top pane keeps bookmarking and audio', (tester) async {
      await pumpReader(tester, bookmarked: {1}, playingVerseId: 1);
      await openSplit(tester);

      await tester.tap(inCard(1, find.byIcon(Icons.bookmark)));
      await tester.tap(inCard(1, find.byIcon(Icons.pause_rounded)));
      await tester.pump();

      expect(bloc.events, [
        const MuhudEvent.toggleBookmark(verseId: 1),
        const MuhudEvent.stopAudio(),
      ]);
    });

    testWidgets('divider drags between 15% and 85%', (tester) async {
      const area = 900 - _appBarBottom;
      await pumpReader(tester);
      await openSplit(tester);

      expect(tester.getTopLeft(divider).dy, _appBarBottom + area / 2 - 5);
      expect(tester.getSize(divider), const Size(600, 10));

      await tester.drag(divider, const Offset(0, 2000));
      await tester.pump();
      expect(
        tester.getTopLeft(divider).dy,
        moreOrLessEquals(_appBarBottom + area * 0.85 - 5),
      );

      await tester.drag(divider, const Offset(0, -2000));
      await tester.pump();
      expect(
        tester.getTopLeft(divider).dy,
        moreOrLessEquals(_appBarBottom + area * 0.15 - 5),
      );
    });

    testWidgets('divider keeps its position across close and reopen', (
      tester,
    ) async {
      await pumpReader(tester);
      await openSplit(tester);
      await tester.drag(divider, const Offset(0, 2000));
      await tester.pump();
      final dragged = tester.getTopLeft(divider).dy;

      await openSplit(tester);
      await openSplit(tester);

      expect(tester.getTopLeft(divider).dy, dragged);
    });

    testWidgets('divider is a row of seven dots', (tester) async {
      await pumpReader(tester);
      await openSplit(tester);

      final dots = find.descendant(
        of: divider,
        matching: find.byWidgetPredicate(
          (w) => w is Container && w.constraints?.maxWidth == 3,
        ),
      );
      expect(dots, findsNWidgets(7));
    });

    testWidgets('shows a thin spinner while loading', (tester) async {
      final pending = Completer<Either<Failure, List<ChapterEntity>>>();
      repository = ReaderRepository(pendingChapters: pending);
      await pumpReader(tester);
      await openSplit(tester);

      final spinner = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(spinner.color, const Color(0xFFCAFF00));
      expect(spinner.strokeWidth, 2);

      pending.complete(right(const []));
    });

    testWidgets('shows the failure message centred', (tester) async {
      repository = ReaderRepository(
        chapters: const [pairedDibaChapter],
        versesFailure: const ServerFailure(message: 'gagal-muat'),
      );
      await pumpReader(tester);
      await openSplit(tester);

      final text = tester.widget<Text>(find.text('gagal-muat'));
      expect(text.textAlign, TextAlign.center);
      expect(text.style!.fontSize, 13);
      expect(text.style!.color, const Color(0xFF777777));
      expect(text.style!.fontFamily, isNull);
    });
  });

  group('wizard', () {
    testWidgets('step A points at the split button', (
      tester,
    ) async {
      wizard = await wizardAt(WizardStep.muhudSplit);
      await pumpReader(tester);
      await pumpCoachMark(tester);

      expect(find.text('1/4'), findsOneWidget);
      expect(find.text('Split Screen'), findsOneWidget);
      expect(
        find.text(
          'Buka split screen untuk membaca teks Arab dan terjemahan secara '
          'berdampingan.',
        ),
        findsOneWidget,
      );
      expect(
        find.text('Tap tombol "Diba / Diwan" untuk membuka'),
        findsOneWidget,
      );
    });

    testWidgets('SKIP ends the whole wizard', (tester) async {
      wizard = await wizardAt(WizardStep.muhudSplit);
      await pumpReader(tester);
      await pumpCoachMark(tester);

      await tester.tap(find.text('SKIP'));
      await pumpCoachMark(tester);

      expect(wizard.state, isA<WizardDone>());
      expect(find.text('Split Screen'), findsNothing);
    });

    testWidgets('step A also starts when the wizard activates later', (
      tester,
    ) async {
      await pumpReader(tester);
      expect(find.text('Split Screen'), findsNothing);

      await wizard.init();
      await tester.pump();
      await pumpCoachMark(tester);

      expect(find.text('Split Screen'), findsOneWidget);
    });

    testWidgets('stays quiet on other steps', (tester) async {
      wizard = await wizardAt(WizardStep.tabCari);
      await pumpReader(tester);
      await pumpCoachMark(tester);

      expect(find.text('Split Screen'), findsNothing);
    });

    testWidgets('step A swallows the tap, then step B follows the split view', (
      tester,
    ) async {
      wizard = await wizardAt(WizardStep.muhudSplit);
      await pumpReader(tester);
      await pumpCoachMark(tester);

      await tester.tapAt(tester.getCenter(splitButton));
      await pumpCoachMark(tester);

      expect(stepOf(wizard), WizardStep.muhudAudio);
      // The overlay does not forward the tap to the real button.
      expect(card(901), findsNothing);
      expect(find.text('Putar Audio'), findsNothing);

      await openSplit(tester);
      await tester.pump();
      await pumpCoachMark(tester);

      expect(find.text('2/4'), findsOneWidget);
      expect(find.text('Putar Audio'), findsOneWidget);
      expect(
        find.text(
          'Dengarkan shalawat sambil membaca. Tap tombol ▶ di bait ini untuk '
          'memulai.',
        ),
        findsOneWidget,
      );
      expect(find.text('Tap bait untuk memilih audio'), findsOneWidget);
    });

    testWidgets('finishing step B leaves the reader, then advances', (
      tester,
    ) async {
      wizard = await wizardAt(WizardStep.muhudSplit);
      await pumpReader(tester);
      await pumpCoachMark(tester);
      await tester.tapAt(tester.getCenter(splitButton));
      await pumpCoachMark(tester);
      await openSplit(tester);
      await tester.pump();
      await pumpCoachMark(tester);

      await tester.tapAt(tester.getCenter(card(1)));
      await pumpCoachMark(tester);

      expect(find.text('halaman-home'), findsOneWidget);
      expect(stepOf(wizard), WizardStep.tabBeranda);
    });
  });
}
