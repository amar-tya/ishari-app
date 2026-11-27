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
}
