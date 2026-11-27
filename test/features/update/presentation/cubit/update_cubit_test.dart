import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/update/domain/entities/app_version_entity.dart';
import 'package:ishari/features/update/presentation/cubit/update_cubit.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../splash/startup/startup_fakes.dart';

void main() {
  setUp(() {
    PackageInfo.setMockInitialValues(
      appName: 'ishari',
      packageName: 'com.ishari.app',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  testWidgets('a version check that never answers is up to date after 5s', (
    tester,
  ) async {
    final repository = FakeUpdateRepository()
      ..version = () => Completer<Either<Failure, AppVersionEntity>>().future;
    final cubit = buildUpdateCubit(repository);

    unawaited(cubit.check());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 4900));
    expect(cubit.state, const UpdateState.checking());

    await tester.pump(const Duration(milliseconds: 200));
    expect(cubit.state, const UpdateState.upToDate());
  });

  testWidgets('an answer within 5s is still honoured', (tester) async {
    final repository = FakeUpdateRepository()
      ..version = () => Future.delayed(
        const Duration(seconds: 4),
        () => right(
          const AppVersionEntity(
            minVersion: '2.0.0',
            latestVersion: '2.0.0',
            storeUrl: 'store',
            releaseNotes: 'notes',
          ),
        ),
      );
    final cubit = buildUpdateCubit(repository);

    unawaited(cubit.check());
    await tester.pump();
    await tester.pump(const Duration(seconds: 6));

    expect(
      cubit.state,
      const UpdateState.forceUpdate(storeUrl: 'store', releaseNotes: 'notes'),
    );
  });

  /// Runs one check as the app at [current], with the server answering
  /// [minimum] and [latest], and returns the state it ends in.
  Future<UpdateState> decide({
    required String current,
    required String minimum,
    required String latest,
  }) async {
    PackageInfo.setMockInitialValues(
      appName: 'ishari',
      packageName: 'com.ishari.app',
      version: current,
      buildNumber: '1',
      buildSignature: '',
    );
    final repository = FakeUpdateRepository()
      ..version = () async => right(
        AppVersionEntity(
          minVersion: minimum,
          latestVersion: latest,
          storeUrl: 'store',
          releaseNotes: 'notes',
        ),
      );
    final cubit = buildUpdateCubit(repository);
    addTearDown(cubit.close);
    await cubit.check();
    return cubit.state;
  }

  const forceUpdate = UpdateState.forceUpdate(
    storeUrl: 'store',
    releaseNotes: 'notes',
  );
  const upToDate = UpdateState.upToDate();
  UpdateState softUpdate(String latestVersion) => UpdateState.softUpdate(
    latestVersion: latestVersion,
    storeUrl: 'store',
    releaseNotes: 'notes',
  );

  group('force, soft or up to date', () {
    test(
      'is force below the minimum, even when it is also below latest',
      () async {
        final state = await decide(
          current: '1.0.0',
          minimum: '1.2.0',
          latest: '2.0.0',
        );

        expect(state, forceUpdate);
      },
    );

    test('the minimum alone decides force, whatever latest says', () async {
      // Latest is behind the minimum: a misconfigured row still forces.
      expect(
        await decide(current: '1.0.0', minimum: '2.0.0', latest: '1.5.0'),
        forceUpdate,
      );
      expect(
        await decide(current: '1.0.0', minimum: '1.0.1', latest: '1.0.0'),
        forceUpdate,
      );
    });

    test('is soft at the minimum but below latest, and names latest', () async {
      final state = await decide(
        current: '1.0.0',
        minimum: '1.0.0',
        latest: '1.1.0',
      );

      expect(state, softUpdate('1.1.0'));
    });

    test('is soft when only latest is ahead of a lower minimum', () async {
      final state = await decide(
        current: '1.3.0',
        minimum: '1.0.0',
        latest: '1.4.0',
      );

      expect(state, softUpdate('1.4.0'));
    });

    test('is up to date at the minimum and latest', () async {
      expect(
        await decide(current: '1.2.3', minimum: '1.2.3', latest: '1.2.3'),
        upToDate,
      );
    });

    test('is up to date above both, e.g. a build ahead of the store', () async {
      expect(
        await decide(current: '2.0.0', minimum: '1.0.0', latest: '1.5.0'),
        upToDate,
      );
    });

    test(
      'is up to date above latest while the minimum is also behind',
      () async {
        expect(
          await decide(current: '1.0.1', minimum: '0.9.0', latest: '1.0.0'),
          upToDate,
        );
      },
    );
  });

  group('version comparison', () {
    test('compares numbers, not text', () async {
      expect(
        await decide(current: '1.9.0', minimum: '1.0.0', latest: '1.10.0'),
        softUpdate('1.10.0'),
      );
      expect(
        await decide(current: '1.10.0', minimum: '1.0.0', latest: '1.9.0'),
        upToDate,
      );
      expect(
        await decide(current: '1.2.9', minimum: '1.2.10', latest: '1.2.10'),
        forceUpdate,
      );
    });

    test('an earlier part outweighs every later one', () async {
      expect(
        await decide(current: '1.9.9', minimum: '2.0.0', latest: '2.0.0'),
        forceUpdate,
      );
      expect(
        await decide(current: '2.0.0', minimum: '1.99.99', latest: '1.99.99'),
        upToDate,
      );
    });

    test('a shorter version is older than a longer one with a patch', () async {
      expect(
        await decide(current: '1.5', minimum: '1.0.0', latest: '1.5.1'),
        softUpdate('1.5.1'),
      );
      expect(
        await decide(current: '1.5', minimum: '1.5.1', latest: '1.5.1'),
        forceUpdate,
      );
      expect(
        await decide(current: '2', minimum: '2.0.1', latest: '2.0.1'),
        forceUpdate,
      );
    });

    test('a longer version is newer than a shorter one', () async {
      expect(
        await decide(current: '1.5.1', minimum: '1.5', latest: '1.5'),
        upToDate,
      );
    });

    test('missing trailing parts count as zero', () async {
      expect(
        await decide(current: '1.5', minimum: '1.5.0', latest: '1.5.0'),
        upToDate,
      );
      expect(
        await decide(current: '1.5.0', minimum: '1.5', latest: '1.5'),
        upToDate,
      );
      expect(
        await decide(current: '1.5.0.0', minimum: '1.5', latest: '1.5.0'),
        upToDate,
      );
    });

    test('an empty minimum or latest never blocks or nags', () async {
      expect(
        await decide(current: '1.0.0', minimum: '', latest: ''),
        upToDate,
      );
      expect(
        await decide(current: '1.0.0', minimum: '', latest: '1.1.0'),
        softUpdate('1.1.0'),
      );
    });
  });

  group('check', () {
    test('emits checking, then the decision', () async {
      PackageInfo.setMockInitialValues(
        appName: 'ishari',
        packageName: 'com.ishari.app',
        version: '1.0.0',
        buildNumber: '1',
        buildSignature: '',
      );
      final cubit = buildUpdateCubit(FakeUpdateRepository());
      addTearDown(cubit.close);
      expect(cubit.state, const UpdateState.initial());

      final states = <UpdateState>[];
      final subscription = cubit.stream.listen(states.add);
      addTearDown(subscription.cancel);
      await cubit.check();
      await pumpEventQueue();

      expect(states, [const UpdateState.checking(), upToDate]);
    });

    test('a server failure is the error state with its message', () async {
      final repository = FakeUpdateRepository()
        ..version = () async => left(const NetworkFailure());
      final cubit = buildUpdateCubit(repository);
      addTearDown(cubit.close);

      await cubit.check();

      expect(cubit.state, const UpdateState.error(FailureMessages.network));
      expect(repository.calls, 1);
    });

    test('a repository that throws counts as up to date', () async {
      final repository = FakeUpdateRepository()
        ..version = () async => throw StateError('boom');
      final cubit = buildUpdateCubit(repository);
      addTearDown(cubit.close);

      await cubit.check();

      expect(cubit.state, upToDate);
    });

    test('a later check replaces an error with the new answer', () async {
      final repository = FakeUpdateRepository()
        ..version = () async => left(const ServerFailure());
      final cubit = buildUpdateCubit(repository);
      addTearDown(cubit.close);
      await cubit.check();
      expect(cubit.state, const UpdateState.error(FailureMessages.server));

      repository.version = () async => right(
        const AppVersionEntity(
          minVersion: '9.0.0',
          latestVersion: '9.0.0',
          storeUrl: 'store',
          releaseNotes: 'notes',
        ),
      );
      await cubit.check();

      expect(cubit.state, forceUpdate);
    });
  });
}
