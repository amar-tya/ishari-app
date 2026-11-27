import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/analytics/analytics_service.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/observability/sentry_bloc_observer.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/search/domain/usecases/search_chapters.dart';
import 'package:ishari/features/search/presentation/bloc/search_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class _FakeSearchChapters implements SearchChapters {
  @override
  Future<Either<Failure, List<ChapterEntity>>> call(
    SearchParams params,
  ) async => const Right([]);
}

class _FakeAnalytics implements AnalyticsService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _UnmappedCubit extends Cubit<int> {
  _UnmappedCubit() : super(0);

  void fail(Object error) => addError(error);
}

class _RecordingObserver extends BlocObserver {
  final calls = <String>[];

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    calls.add('create');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    calls.add('error');
  }
}

void main() {
  late BlocObserver original;
  late List<Breadcrumb> breadcrumbs;

  setUp(() {
    original = Bloc.observer;
    breadcrumbs = [];
  });

  tearDown(() => Bloc.observer = original);

  void install() => SentryBlocObserver.install(addBreadcrumb: breadcrumbs.add);

  test('adding to a closed bloc leaves a breadcrumb naming it, before add() '
      'rethrows', () async {
    install();
    final bloc = SearchBloc(_FakeSearchChapters(), _FakeAnalytics());
    await bloc.close();

    expect(
      () => bloc.add(const SearchEvent.queryChanged('abc')),
      throwsStateError,
    );

    final breadcrumb = breadcrumbs.single;
    expect(breadcrumb.category, 'bloc.error');
    expect(breadcrumb.level, SentryLevel.error);
    expect(breadcrumb.data, {'bloc': 'SearchBloc', 'error_type': 'StateError'});
  });

  test('the breadcrumb carries no event, state or error message text', () {
    install();

    _UnmappedCubit().fail(const FormatException('user@example.com'));

    final breadcrumb = breadcrumbs.single;
    expect(breadcrumb.data, {
      'bloc': 'unknownBloc',
      'error_type': 'FormatException',
    });
    expect(jsonEncode(breadcrumb.toJson()), isNot(contains('example.com')));
  });

  test('error types are fixed literals, not runtime type names', () {
    install();
    final cubit = _UnmappedCubit();

    for (final error in <Object>[
      StateError('x'),
      ArgumentError('x'),
      TypeError(),
      TimeoutException('x'),
      Exception('x'),
      UnimplementedError(),
      'secret text thrown as an object',
    ]) {
      cubit.fail(error);
    }

    expect(breadcrumbs.map((b) => b.data!['error_type']), [
      'StateError',
      'ArgumentError',
      'TypeError',
      'TimeoutException',
      'Exception',
      'Error',
      'Object',
    ]);
  });

  test('install() keeps the observer that was already set', () {
    final previous = _RecordingObserver();
    Bloc.observer = previous;
    install();

    _UnmappedCubit().fail(StateError('x'));

    expect(previous.calls, ['create', 'error']);
    expect(breadcrumbs, hasLength(1));
  });

  test('a recorder that throws does not reach the bloc', () {
    SentryBlocObserver.install(
      addBreadcrumb: (_) => throw StateError('recorder broke'),
    );

    expect(() => _UnmappedCubit().fail(StateError('x')), returnsNormally);
  });

  test(
    'a recorder that fails asynchronously leaves no uncaught error',
    () async {
      final uncaught = <Object>[];

      await runZonedGuarded(() async {
        SentryBlocObserver.install(
          addBreadcrumb: (_) =>
              Future<void>.error(StateError('recorder broke')),
        );
        _UnmappedCubit().fail(StateError('x'));
        await Future<void>.delayed(Duration.zero);
      }, (error, _) => uncaught.add(error));

      expect(uncaught, isEmpty);
    },
  );

  // Release builds are obfuscated, so every bloc needs its own `is` check and
  // string literal in the observer. This reads the sources so that a new bloc
  // cannot be added without one.
  test('every bloc and cubit class in lib/ has a name mapping', () {
    final blocs = _blocClassNames(Directory('lib'));
    // Guards against a scan that silently finds nothing.
    expect(blocs, containsAll(<String>['SearchBloc', 'WizardCubit']));

    final observer = File(
      'lib/core/observability/sentry_bloc_observer.dart',
    ).readAsStringSync();
    final unmapped = blocs.where(
      (name) => !RegExp('\\b$name\\(\\)\\s*=>\\s*\'$name\'').hasMatch(observer),
    );

    expect(
      unmapped,
      isEmpty,
      reason: "Add `Name() => 'Name',` to SentryBlocObserver for each.",
    );
  });
}

/// Names of the classes under [root] that extend Bloc or Cubit, directly or
/// through another class. Abstract classes are skipped.
Set<String> _blocClassNames(Directory root) {
  final declaration = RegExp(
    r'^((?:(?:abstract|base|final|sealed|interface)\s+)*)class\s+(\w+)'
    r'(?:\s*<[^{]*?>)?\s+extends\s+(\w+)',
    multiLine: true,
  );
  final classes = <({String name, String parent, bool isAbstract})>[
    for (final file in root.listSync(recursive: true).whereType<File>())
      if (file.path.endsWith('.dart') && !file.path.endsWith('.freezed.dart'))
        for (final match in declaration.allMatches(file.readAsStringSync()))
          (
            name: match[2]!,
            parent: match[3]!,
            isAbstract:
                match[1]!.contains('abstract') || match[1]!.contains('sealed'),
          ),
  ];

  final family = {'BlocBase', 'Bloc', 'Cubit', 'HydratedBloc', 'HydratedCubit'};
  var grew = true;
  while (grew) {
    grew = false;
    for (final c in classes) {
      if (family.contains(c.parent) && family.add(c.name)) grew = true;
    }
  }

  return {
    for (final c in classes)
      if (!c.isAbstract && family.contains(c.parent)) c.name,
  };
}
