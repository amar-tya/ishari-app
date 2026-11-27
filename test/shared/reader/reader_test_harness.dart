// Doubles and helpers shared by the two reader widget tests.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/wizard/wizard_cubit.dart';
import 'package:ishari/core/wizard/wizard_state.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/muhud/domain/entities/hadi_media_entity.dart';
import 'package:ishari/features/muhud/domain/entities/translation_entity.dart';
import 'package:ishari/features/muhud/domain/entities/verse_entity.dart';
import 'package:ishari/features/muhud/domain/entities/verse_media_entity.dart';
import 'package:ishari/features/muhud/domain/entities/verse_media_type.dart';
import 'package:ishari/features/muhud/domain/entities/verse_with_details_entity.dart';
import 'package:ishari/features/muhud/domain/usecases/get_all_chapters.dart';
import 'package:ishari/features/muhud/domain/usecases/get_verses_by_chapter.dart';
import 'package:ishari/features/muhud/presentation/bloc/split_panel_cubit.dart';

import '../../features/muhud/fakes/fake_muhud_repository.dart';

/// Logical screen used by every reader test. The insets pin how each reader
/// treats the status and navigation bars.
const screenSize = Size(600, 900);
const statusBarHeight = 24.0;
const navigationBarHeight = 20.0;

void useReaderScreen(WidgetTester tester) {
  GoogleFonts.config.allowRuntimeFetching = false;
  tester.view
    ..devicePixelRatio = 1
    ..physicalSize = screenSize
    ..padding = const FakeViewPadding(
      top: statusBarHeight,
      bottom: navigationBarHeight,
    );
  addTearDown(tester.view.reset);
}

/// Long enough for a coach mark to focus, fade its text in, or close. The
/// pulse animation never ends, so pumpAndSettle cannot be used.
Future<void> pumpCoachMark(WidgetTester tester) async {
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

VerseWithDetailsEntity verseWithDetails(
  int id, {
  bool withAudio = false,
  String? translation,
}) => VerseWithDetailsEntity(
  verse: VerseEntity(
    id: id,
    chapterId: 1,
    verseNumber: id,
    arabicText: 'arab-$id',
    transliteration: 'latin-$id',
  ),
  translations: [
    TranslationEntity(
      id: id,
      verseId: id,
      languageCode: 'id',
      translationText: translation ?? 'arti-$id',
    ),
  ],
  mediaList: [
    if (withAudio)
      VerseMediaEntity(
        id: 100 + id,
        verseId: id,
        hadi: const HadiMediaEntity(id: 'h1', name: 'Hadi Satu'),
        mediaUrl: 'https://example.invalid/$id.mp3',
        duration: 10,
        type: VerseMediaType.yahum,
      ),
  ],
);

/// Serves the chapters and verses the split panel and add-verses sheet load.
class ReaderRepository extends FakeMuhudRepository {
  ReaderRepository({
    this.chapters = const [],
    this.verses = const [],
    this.versesFailure,
    this.pendingChapters,
  });

  final List<ChapterEntity> chapters;
  final List<VerseWithDetailsEntity> verses;
  final Failure? versesFailure;

  /// When set, the split panel stays in its loading state until completed.
  final Completer<Either<Failure, List<ChapterEntity>>>? pendingChapters;

  final requestedChapterIds = <int>[];

  @override
  Future<Either<Failure, List<ChapterEntity>>> getAllChapters() =>
      pendingChapters?.future ?? Future.value(right(chapters));

  @override
  Future<Either<Failure, List<VerseWithDetailsEntity>>> getVersesByChapter(
    int chapterId,
  ) async {
    requestedChapterIds.add(chapterId);
    final failure = versesFailure;
    return failure != null ? left(failure) : right(verses);
  }
}

const pairedDibaChapter = ChapterEntity(
  id: '9',
  title: 'Pasangan',
  category: 'Diba',
  description: '',
  verseCount: 2,
  number: 3,
);

SplitPanelCubit splitPanelCubit(ReaderRepository repository) => SplitPanelCubit(
  getAllChapters: GetAllChapters(repository),
  getVersesByChapter: GetVersesByChapter(repository),
);

class _EmptyStorage extends Fake implements FlutterSecureStorage {
  // read returns Future<String?> and write Future<void>; this satisfies both.
  @override
  dynamic noSuchMethod(Invocation invocation) => Future<String?>.value();
}

WizardCubit inactiveWizard() => WizardCubit(_EmptyStorage());

/// A wizard already waiting at [step].
Future<WizardCubit> wizardAt(WizardStep step) async {
  final wizard = inactiveWizard();
  await wizard.init();
  while ((wizard.state as WizardActive).step != step) {
    wizard.advance();
  }
  return wizard;
}

WizardStep? stepOf(WizardCubit wizard) => switch (wizard.state) {
  WizardActive(:final step) => step,
  _ => null,
};
