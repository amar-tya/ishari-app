// Characterization tests for the tatanan reader (issue #40). They record what
// the reader does today, including behaviour that looks wrong, so a refactor
// cannot change it unnoticed.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/wizard/wizard_cubit.dart';
import 'package:ishari/core/wizard/wizard_state.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/muhud/domain/usecases/get_verses_by_chapter.dart';
import 'package:ishari/features/muhud/presentation/bloc/split_panel_cubit.dart';
import 'package:ishari/features/muhud/presentation/widgets/verse_card.dart';
import 'package:ishari/features/tatanan/domain/entities/tatanan_entity.dart';
import 'package:ishari/features/tatanan/domain/entities/tatanan_verse_entity.dart';
import 'package:ishari/features/tatanan/presentation/bloc/tatanan_detail/tatanan_detail_bloc.dart';
import 'package:ishari/features/tatanan/presentation/bloc/tatanan_settings_cubit.dart';
import 'package:ishari/features/tatanan/presentation/widgets/add_verses_sheet.dart';
import 'package:ishari/features/tatanan/presentation/widgets/tatanan_reader_body.dart';
import 'package:ishari/features/tatanan/presentation/widgets/tatanan_verse_item.dart';
import 'package:ishari/injection_container.dart';
import 'package:ishari/shared/widgets/banner_ad_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../shared/reader/reader_test_harness.dart';

class _RecordingDetailBloc extends Fake implements TatananDetailBloc {
  _RecordingDetailBloc(this._state);

  TatananDetailState _state;
  final _states = StreamController<TatananDetailState>.broadcast(sync: true);
  final events = <TatananDetailEvent>[];

  void push(TatananDetailState state) {
    _state = state;
    _states.add(state);
  }

  @override
  TatananDetailState get state => _state;

  @override
  Stream<TatananDetailState> get stream => _states.stream;

  @override
  void add(TatananDetailEvent event) => events.add(event);

  @override
  bool get isClosed => false;

  @override
  Future<void> close() async {}
}

TatananEntity _tatanan({String category = 'Diwan'}) => TatananEntity(
  id: 't1',
  userId: 'u1',
  chapterId: 4,
  name: 'Tatanan Saya',
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
  chapterTitle: 'Bab Satu',
  category: category,
  chapterNumber: 3,
);

List<TatananVerseEntity> _verses(int count) => [
  for (var i = 1; i <= count; i++)
    TatananVerseEntity(
      id: 'row-$i',
      tatananId: 't1',
      verseId: 10 + i,
      position: i,
      verseNumber: i,
      arabicText: 'arab-$i',
      transliteration: 'latin-$i',
    ),
];

TatananDetailState _loaded({
  int verseCount = 3,
  bool isEditMode = false,
  String category = 'Diwan',
}) => TatananDetailState.loaded(
  tatanan: _tatanan(category: category),
  verses: _verses(verseCount),
  isEditMode: isEditMode,
);

void main() {
  late _RecordingDetailBloc bloc;
  late ReaderRepository repository;
  late TatananSettingsCubit settings;
  late WizardCubit wizard;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = ReaderRepository(
      chapters: const [pairedDibaChapter],
      verses: [verseWithDetails(901), verseWithDetails(902, withAudio: true)],
    );
    wizard = inactiveWizard();
    sl.registerSingleton(GetVersesByChapter(repository));
  });

  tearDown(sl.reset);

  Future<void> pumpReader(
    WidgetTester tester, {
    TatananDetailState? state,
  }) async {
    useReaderScreen(tester);
    // The banner asks the ads plugin to load; answer so nothing is thrown.
    tester.binding.defaultBinaryMessenger.setMockMessageHandler(
      'plugins.flutter.io/google_mobile_ads',
      (_) async => const StandardMethodCodec().encodeSuccessEnvelope(null),
    );
    bloc = _RecordingDetailBloc(state ?? _loaded());
    final cubit = splitPanelCubit(repository);
    settings = TatananSettingsCubit();
    addTearDown(cubit.close);
    addTearDown(settings.close);
    addTearDown(wizard.close);

    await tester.pumpWidget(
      BlocProvider<WizardCubit>.value(
        value: wizard,
        child: MaterialApp(
          home: MultiBlocProvider(
            providers: [
              BlocProvider<TatananDetailBloc>.value(value: bloc),
              BlocProvider<SplitPanelCubit>.value(value: cubit),
              BlocProvider<TatananSettingsCubit>.value(value: settings),
            ],
            child: const TatananReaderBody(tatananId: 't1'),
          ),
        ),
      ),
    );
    await tester.pump();
  }

  final splitButton = find.text('Buka Diba');
  final editButton = find.byIcon(Icons.edit_outlined);
  final fab = find.byType(FloatingActionButton);
  final banner = find.byType(BannerAdWidget);
  final divider = find.byWidgetPredicate(
    (w) => w is GestureDetector && w.onVerticalDragUpdate != null,
    description: 'split divider',
  );

  List<TatananVerseItem> items(WidgetTester tester) => tester
      .widgetList<TatananVerseItem>(find.byType(TatananVerseItem))
      .toList();

  Future<void> openSplit(WidgetTester tester) async {
    await tester.tap(splitButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  group('bloc states', () {
    testWidgets('initial is blank', (tester) async {
      await pumpReader(tester, state: const TatananDetailState.initial());

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(BackButton), findsNothing);
    });

    testWidgets('loading shows a spinner', (tester) async {
      await pumpReader(tester, state: const TatananDetailState.loading());

      final spinner = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(spinner.color, const Color(0xFFCAFF00));
      expect(spinner.strokeWidth, isNull);
    });

    testWidgets('error can be retried', (tester) async {
      await pumpReader(
        tester,
        state: const TatananDetailState.error(message: 'rusak'),
      );

      expect(find.text('rusak'), findsOneWidget);
      expect(find.byType(BackButton), findsOneWidget);
      await tester.tap(find.text('Coba Lagi'));

      expect(bloc.events, [const TatananDetailEvent.load(tatananId: 't1')]);
    });
  });

  group('app bar', () {
    testWidgets('shows name, chapter and verse count', (tester) async {
      await pumpReader(tester);

      expect(find.text('Tatanan Saya'), findsOneWidget);
      expect(find.text('Bab Satu · 3 ayat'), findsOneWidget);
      expect(find.byType(BackButton), findsOneWidget);
      expect(splitButton, findsOneWidget);
      expect(find.byIcon(Icons.vertical_split_rounded), findsOneWidget);
    });

    testWidgets('offers "Buka Diba" even on a Diba tatanan', (tester) async {
      await pumpReader(tester, state: _loaded(category: 'Diba'));

      expect(splitButton, findsOneWidget);
    });

    testWidgets('has no split button outside Diwan and Diba', (tester) async {
      await pumpReader(tester, state: _loaded(category: 'Muhud'));

      expect(splitButton, findsNothing);
    });

    testWidgets('edit button toggles edit mode through the bloc', (
      tester,
    ) async {
      await pumpReader(tester);

      await tester.tap(editButton);

      expect(bloc.events, [const TatananDetailEvent.toggleEditMode()]);
    });
  });

  group('verse list', () {
    testWidgets('lists verses with the settings defaults', (tester) async {
      await pumpReader(tester);

      expect(items(tester), hasLength(3));
      final first = items(tester).first;
      expect(first.isEditMode, isFalse);
      expect(first.showArabic, isTrue);
      expect(first.showTransliteration, isTrue);
      expect(first.arabFontSize, 20);
      expect(first.transliterationFontSize, 12);
      expect(
        tester.widget<ListView>(find.byType(ListView)).padding,
        const EdgeInsets.fromLTRB(16, 8, 16, 100),
      );
    });

    testWidgets('edit list stays above the navigation bar', (tester) async {
      await pumpReader(tester, state: _loaded(isEditMode: true));

      expect(
        tester.getBottomLeft(find.byType(ReorderableListView)).dy,
        screenSize.height - navigationBarHeight,
      );
    });

    testWidgets('reading list runs under the navigation bar', (tester) async {
      // The banner slot is a bottom bar even before an ad loads, so the
      // Scaffold hands the body no bottom inset.
      await pumpReader(tester);

      expect(
        tester.getBottomLeft(find.byType(ListView)).dy,
        screenSize.height,
      );
    });

    testWidgets('shows the banner and add button when reading', (tester) async {
      await pumpReader(tester);

      expect(banner, findsOneWidget);
      expect(fab, findsOneWidget);
    });

    testWidgets('empty tatanan offers to add verses', (tester) async {
      await pumpReader(tester, state: _loaded(verseCount: 0));

      expect(find.text('Tatanan masih kosong'), findsOneWidget);
      expect(
        find.text('Tap tombol + untuk menambahkan ayat.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Tambah Ayat'));
      await tester.pumpAndSettle();

      expect(find.byType(AddVersesSheet), findsOneWidget);
    });

    testWidgets('add button opens the sheet and adds the picked verses', (
      tester,
    ) async {
      await pumpReader(tester);

      await tester.tap(fab);
      await tester.pumpAndSettle();
      final sheet = tester.widget<AddVersesSheet>(find.byType(AddVersesSheet));

      expect(sheet.chapterId, 4);
      expect(sheet.addedVerseIds, {11, 12, 13});
      sheet.onConfirm([901]);
      expect(bloc.events, [
        const TatananDetailEvent.addVerses(tatananId: 't1', verseIds: [901]),
      ]);
    });

    testWidgets('follows new bloc states', (tester) async {
      await pumpReader(tester);

      bloc.push(_loaded(verseCount: 1));
      await tester.pump();

      expect(items(tester), hasLength(1));
      expect(find.text('Bab Satu · 1 ayat'), findsOneWidget);
    });
  });

  group('edit mode', () {
    testWidgets('hides the banner and add button', (tester) async {
      await pumpReader(tester, state: _loaded(isEditMode: true));

      expect(banner, findsNothing);
      expect(fab, findsNothing);
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
      expect(items(tester).every((i) => i.isEditMode), isTrue);
    });

    testWidgets('removes a verse', (tester) async {
      await pumpReader(tester, state: _loaded(isEditMode: true));

      await tester.tap(find.byIcon(Icons.remove_circle_outline).at(1));

      expect(bloc.events, [
        const TatananDetailEvent.removeVerse(tatananId: 't1', verseId: 12),
      ]);
    });

    for (final (from, to, order) in [
      (0, 3, [12, 13, 11]),
      (2, 0, [13, 11, 12]),
    ]) {
      testWidgets('renumbers after moving item $from to $to', (tester) async {
        await pumpReader(tester, state: _loaded(isEditMode: true));

        tester
            .widget<ReorderableListView>(find.byType(ReorderableListView))
            .onReorder!(from, to);

        final event = bloc.events.single;
        final updates = event.mapOrNull(reorder: (e) => e.updates)!;
        expect(event.mapOrNull(reorder: (e) => e.tatananId), 't1');
        expect([for (final u in updates) u.verseId], order);
        expect([for (final u in updates) u.position], [1, 2, 3]);
      });
    }
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

    testWidgets('lists two toggles and two font sliders', (tester) async {
      await pumpReader(tester);
      await openPanel(tester);

      for (final text in [
        'Quick Tools',
        'Konten',
        'Arab',
        'Tampilkan teks Arab',
        'Transliterasi',
        'Tampilkan latin',
        'Pengaturan Font',
        'Ukuran Font Arab',
        'Ukuran Font Transliterasi',
        'Reset ke Default',
      ]) {
        expect(find.text(text), findsOneWidget, reason: text);
      }
      for (final text in [
        'Terjemahan',
        'ID',
        'Font Arab',
        'Scheherazade New',
        'Ukuran Font Terjemahan',
      ]) {
        expect(find.text(text), findsNothing, reason: text);
      }
      expect(find.byType(Switch), findsNWidgets(2));
      expect(find.byType(Divider), findsNWidgets(3));
      final sliders = tester.widgetList<Slider>(find.byType(Slider)).toList();
      expect(
        [for (final s in sliders) (s.value, s.min, s.max, s.divisions)],
        [(20, 16, 36, 20), (12, 8, 18, 10)],
      );
    });

    testWidgets('changes the verses through the settings cubit', (
      tester,
    ) async {
      await pumpReader(tester);
      await openPanel(tester);

      await tester.tap(switchFor('Arab'));
      await tester.tap(switchFor('Transliterasi'));
      final sliders = tester.widgetList<Slider>(find.byType(Slider)).toList();
      sliders[0].onChanged!(30);
      sliders[1].onChanged!(14);
      await tester.pump();

      final first = items(tester).first;
      expect(first.showArabic, isFalse);
      expect(first.showTransliteration, isFalse);
      expect(first.arabFontSize, 30);
      expect(first.transliterationFontSize, 14);
      expect(
        tester.widgetList<Slider>(find.byType(Slider)).map((s) => s.value),
        [30, 14],
      );

      await tester.tap(find.text('Reset ke Default'));
      await tester.pump();

      expect(items(tester).first.arabFontSize, 20);
      expect(items(tester).first.transliterationFontSize, 12);
    });

    testWidgets('leaves the add button above the scrim', (tester) async {
      await pumpReader(tester);
      await openPanel(tester);

      final scrim = find.byWidgetPredicate(
        (w) => w is ColoredBox && w.color == const Color(0x80000000),
      );
      expect(tester.getTopLeft(scrim), Offset.zero);
      expect(
        tester.getBottomRight(scrim),
        Offset(screenSize.width, screenSize.height),
      );
      expect(fab.hitTestable(), findsOneWidget);
    });

    testWidgets('stops above the navigation bar in edit mode', (tester) async {
      await pumpReader(tester, state: _loaded(isEditMode: true));
      await openPanel(tester);

      final scrim = find.byWidgetPredicate(
        (w) => w is ColoredBox && w.color == const Color(0x80000000),
      );
      expect(
        tester.getBottomRight(scrim).dy,
        screenSize.height - navigationBarHeight,
      );
    });

    testWidgets('closes from the scrim and the close button', (tester) async {
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
    testWidgets('pairs the tatanan chapter, without banner', (tester) async {
      await pumpReader(tester);
      await openSplit(tester);

      expect(repository.requestedChapterIds, [9]);
      expect(items(tester), hasLength(3));
      expect(find.byType(VerseCard), findsNWidgets(2));
      expect(find.text('Tutup Diba'), findsOneWidget);
      expect(find.byIcon(Icons.fullscreen_rounded), findsOneWidget);
      expect(banner, findsNothing);
      expect(fab, findsOneWidget);
      // No pane headings in this reader.
      expect(find.text('DIBA'), findsNothing);
    });

    testWidgets('paired verses never show a translation and ignore taps', (
      tester,
    ) async {
      await pumpReader(tester);
      await openSplit(tester);

      final paired = tester.widget<VerseCard>(find.byType(VerseCard).last);
      expect(paired.showTranslation, isFalse);
      expect(paired.arabFontSize, 20);
      expect(paired.transliterationFontSize, 12);
      expect(paired.translationFontSize, 13);
      expect(paired.isBookmarked, isFalse);
      expect(paired.isPlaying, isFalse);

      await tester.tap(find.byIcon(Icons.play_arrow_rounded));
      await tester.tap(find.byIcon(Icons.bookmark_outline).last);
      await tester.pumpAndSettle();
      expect(bloc.events, isEmpty);
      expect(find.byType(BottomSheet), findsNothing);

      for (final list in tester.widgetList<ListView>(find.byType(ListView))) {
        expect(list.padding, const EdgeInsets.fromLTRB(16, 8, 16, 8));
        expect(list.physics, isNot(isA<ClampingScrollPhysics>()));
      }
    });

    testWidgets('paired verses follow the settings', (tester) async {
      await pumpReader(tester);
      await openSplit(tester);

      settings.toggleArabic();
      unawaited(settings.setArabFontSize(30));
      await tester.pump();
      await tester.pump();

      final paired = tester.widget<VerseCard>(find.byType(VerseCard).first);
      expect(paired.showArabic, isFalse);
      expect(paired.arabFontSize, 30);
      expect(items(tester).first.arabFontSize, 30);
    });

    testWidgets('edit mode does not reach the split verse list', (
      tester,
    ) async {
      await pumpReader(tester);
      await openSplit(tester);

      bloc.push(_loaded(isEditMode: true));
      await tester.pumpAndSettle();

      expect(items(tester).every((i) => !i.isEditMode), isTrue);
      expect(find.byType(ReorderableListView), findsNothing);
      expect(fab, findsNothing);
    });

    testWidgets('empty tatanan keeps the empty state on top', (tester) async {
      await pumpReader(tester, state: _loaded(verseCount: 0));
      await openSplit(tester);

      expect(find.text('Tatanan masih kosong'), findsOneWidget);
      expect(find.byType(VerseCard), findsNWidgets(2));
    });

    testWidgets('divider drags between 20% and 80%', (tester) async {
      await pumpReader(tester);
      await openSplit(tester);
      final top = tester.getTopLeft(find.byType(ListView).first).dy;
      final area = screenSize.height - navigationBarHeight - top - 10;

      expect(
        tester.getTopLeft(divider).dy,
        moreOrLessEquals(top + area * 0.5),
      );
      expect(tester.getSize(divider), const Size(600, 10));
      expect(
        find.descendant(of: divider, matching: find.byType(Divider)),
        findsOneWidget,
      );

      await tester.drag(divider, const Offset(0, 2000));
      await tester.pump();
      expect(
        tester.getTopLeft(divider).dy,
        moreOrLessEquals(top + area * 0.8),
      );

      await tester.drag(divider, const Offset(0, -2000));
      await tester.pump();
      expect(
        tester.getTopLeft(divider).dy,
        moreOrLessEquals(top + area * 0.2),
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

      await tester.tap(find.text('Tutup Diba'));
      await tester.pump();
      await openSplit(tester);

      expect(tester.getTopLeft(divider).dy, dragged);
      expect(repository.requestedChapterIds, [9]);
    });

    testWidgets('shows a default spinner while loading', (tester) async {
      final pending = Completer<Either<Failure, List<ChapterEntity>>>();
      repository = ReaderRepository(pendingChapters: pending);
      await pumpReader(tester);
      await openSplit(tester);

      final spinner = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(spinner.color, const Color(0xFFCAFF00));
      expect(spinner.strokeWidth, isNull);

      pending.complete(right(const []));
    });

    testWidgets('shows the failure message in Poppins', (tester) async {
      repository = ReaderRepository(
        chapters: const [pairedDibaChapter],
        versesFailure: const ServerFailure(message: 'gagal-muat'),
      );
      await pumpReader(tester);
      await openSplit(tester);

      final text = tester.widget<Text>(find.text('gagal-muat'));
      expect(text.textAlign, isNull);
      expect(text.style!.fontSize, 12);
      expect(text.style!.color, const Color(0xFF777777));
      expect(text.style!.fontFamily, startsWith('Poppins'));
    });
  });

  group('wizard', () {
    testWidgets('explains editing, then the split view, then completes', (
      tester,
    ) async {
      wizard = await wizardAt(WizardStep.tatananDetail);
      await pumpReader(tester);
      await pumpCoachMark(tester);

      expect(find.text('4/4'), findsOneWidget);
      expect(find.text('Susun Urutan'), findsOneWidget);
      expect(
        find.text(
          'Aktifkan mode edit, lalu tahan dan geser item untuk mengubah urutan '
          'ayat dalam tatanan.',
        ),
        findsOneWidget,
      );
      expect(
        find.text('Tap ikon edit untuk masuk ke mode susun'),
        findsOneWidget,
      );

      await tester.tapAt(tester.getCenter(editButton));
      await pumpCoachMark(tester);

      expect(bloc.events, isEmpty);
      expect(find.text("Buka Diba'"), findsOneWidget);
      expect(
        find.text(
          'Tap "Buka Diba\'" untuk membuka split screen — baca tatananmu '
          "berdampingan dengan teks Diba'.",
        ),
        findsOneWidget,
      );
      expect(find.text('Tap untuk membuka split screen'), findsOneWidget);

      await tester.tapAt(tester.getCenter(splitButton));
      await pumpCoachMark(tester);

      expect(wizard.state, isA<WizardDone>());
      expect(find.text('4/4'), findsNothing);
      expect(find.byType(VerseCard), findsNothing);
    });

    testWidgets('SKIP ends the wizard', (tester) async {
      wizard = await wizardAt(WizardStep.tatananDetail);
      await pumpReader(tester);
      await pumpCoachMark(tester);

      await tester.tap(find.text('SKIP'));
      await pumpCoachMark(tester);

      expect(wizard.state, isA<WizardDone>());
      expect(find.text('Susun Urutan'), findsNothing);
    });

    testWidgets('starts when the wizard reaches the step later', (
      tester,
    ) async {
      wizard = await wizardAt(WizardStep.tatananCreate);
      await pumpReader(tester);
      await pumpCoachMark(tester);
      expect(find.text('Susun Urutan'), findsNothing);

      wizard.advanceToTatananDetail();
      await tester.pump();
      await pumpCoachMark(tester);

      expect(find.text('Susun Urutan'), findsOneWidget);
    });

    testWidgets('is marked done unseen if the tatanan is still loading', (
      tester,
    ) async {
      wizard = await wizardAt(WizardStep.tatananDetail);
      await pumpReader(tester, state: const TatananDetailState.loading());
      await pumpCoachMark(tester);

      expect(wizard.state, isA<WizardDone>());

      bloc.push(_loaded());
      await tester.pump();
      await pumpCoachMark(tester);
      expect(find.text('Susun Urutan'), findsNothing);
    });
  });
}
