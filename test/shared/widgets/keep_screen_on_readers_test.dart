import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/wakelock/screen_wakelock.dart';
import 'package:ishari/features/kitab/domain/entities/book_page_entity.dart';
import 'package:ishari/features/kitab/domain/repositories/kitab_repository.dart';
import 'package:ishari/features/kitab/domain/usecases/get_pages_by_chapter.dart';
import 'package:ishari/features/kitab/presentation/pages/kitab_page_reader_page.dart';
import 'package:ishari/features/muhud/presentation/pages/chapter_reader_page.dart';
import 'package:ishari/features/tatanan/presentation/pages/tatanan_detail_page.dart';
import 'package:ishari/injection_container.dart';
import 'package:ishari/shared/widgets/keep_screen_on.dart';

class _LoadingKitabRepository extends Fake implements KitabRepository {
  @override
  Future<Either<Failure, List<BookPageEntity>>> getPagesByChapter(
    int chapterId,
  ) => Completer<Either<Failure, List<BookPageEntity>>>().future;
}

void main() {
  // Their blocs are only created once the providers are mounted, so the root
  // widget can be checked without the dependencies behind them.
  testWidgets('chapter and tatanan readers keep the screen on', (tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    final context = tester.element(find.byType(SizedBox));

    expect(
      const ChapterReaderPage(chapterId: 1).build(context),
      isA<KeepScreenOn>(),
    );
    expect(
      const TatananDetailPage(tatananId: '1').build(context),
      isA<KeepScreenOn>(),
    );
  });

  testWidgets('kitab page reader holds the wakelock while mounted', (
    tester,
  ) async {
    final toggles = <bool>[];
    final original = ScreenWakelock.instance;
    ScreenWakelock.instance = ScreenWakelock(
      toggle: ({required enable}) async => toggles.add(enable),
    );
    sl.registerSingleton(GetPagesByChapter(_LoadingKitabRepository()));
    addTearDown(() async {
      ScreenWakelock.instance = original;
      await sl.reset();
    });

    await tester.pumpWidget(
      const MaterialApp(home: KitabPageReaderPage(chapterId: 1)),
    );
    expect(toggles, [true]);

    await tester.pumpWidget(const SizedBox.shrink());
    expect(toggles, [true, false]);
  });
}
