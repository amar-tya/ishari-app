import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/analytics/analytics_service.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/search/domain/usecases/search_chapters.dart';
import 'package:ishari/features/search/presentation/bloc/search_bloc.dart';

class _FakeSearchChapters implements SearchChapters {
  final queries = <String>[];

  @override
  Future<Either<Failure, List<ChapterEntity>>> call(SearchParams params) async {
    queries.add(params.query);
    return const Right([]);
  }
}

class _FakeAnalytics implements AnalyticsService {
  @override
  Future<void> logSearch({required String searchTerm}) async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

// Longer than the 400 ms debounce.
const _pastDebounce = Duration(milliseconds: 500);

/// Runs [body] in its own zone and returns the errors nothing else caught,
/// which is where an add() from the debounce timer ends up. The bloc must be
/// created inside [body] so that its handlers and timers belong to the zone.
Future<List<Object>> _uncaughtDuring(Future<void> Function() body) async {
  final errors = <Object>[];
  final done = Completer<void>();
  unawaited(
    runZonedGuarded(() async {
      try {
        await body();
      } finally {
        done.complete();
      }
    }, (error, _) => errors.add(error)),
  );
  await done.future;
  return errors;
}

void main() {
  late _FakeSearchChapters search;

  SearchBloc build() => SearchBloc(search, _FakeAnalytics());

  setUp(() => search = _FakeSearchChapters());

  test('a query still queued at close() does not start a debounce that adds to '
      'the closed bloc', () async {
    final errors = await _uncaughtDuring(() async {
      final bloc = build()..add(const SearchEvent.queryChanged('abc'));
      await bloc.close();
      await Future<void>.delayed(_pastDebounce);
    });

    expect(errors, isEmpty);
    expect(search.queries, isEmpty);
  });

  test('close() with a debounce already pending is silent', () async {
    final errors = await _uncaughtDuring(() async {
      final bloc = build()..add(const SearchEvent.queryChanged('abc'));
      // Lets the handler run and start the timer.
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state, const SearchState.loading());
      await bloc.close();
      await Future<void>.delayed(_pastDebounce);
    });

    expect(errors, isEmpty);
    expect(search.queries, isEmpty);
  });

  test('an open bloc still searches after the debounce', () async {
    final bloc = build()..add(const SearchEvent.queryChanged('abc'));

    await Future<void>.delayed(_pastDebounce);

    expect(search.queries, ['abc']);
    expect(
      bloc.state,
      const SearchState.empty(query: 'abc', category: 'Semua'),
    );
    await bloc.close();
  });
}
