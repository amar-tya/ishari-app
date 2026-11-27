// Repositories turn what a data source throws into a failure the user can
// read. The data sources here are fakes that throw what the real ones do.
import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/network/network_info.dart';
import 'package:ishari/features/home/data/datasources/home_remote_datasource.dart';
import 'package:ishari/features/home/data/models/chapter_model.dart';
import 'package:ishari/features/home/data/repositories/home_repository_impl.dart';
import 'package:ishari/features/update/data/datasources/update_remote_datasource.dart';
import 'package:ishari/features/update/data/models/app_version_model.dart';
import 'package:ishari/features/update/data/repositories/update_repository_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class _Network implements NetworkInfo {
  _Network({required this.connected});

  final bool connected;

  @override
  Future<bool> get isConnected async => connected;
}

class _ThrowingHome extends Fake implements HomeRemoteDataSource {
  _ThrowingHome(this.error);

  final Object error;
  int calls = 0;

  @override
  Future<List<ChapterModel>> getChaptersByCategory(String category) async {
    calls++;
    throw error;
  }
}

class _ThrowingUpdate extends Fake implements UpdateRemoteDataSource {
  _ThrowingUpdate(this.error);

  final Object error;

  @override
  Future<AppVersionModel> getAppVersion(String platform) async => throw error;
}

void main() {
  final stack = StackTrace.current;
  const dbError = PostgrestException(
    message: 'permission denied for table app_config',
    code: '42501',
    details: 'user reader@example.com',
  );

  Failure left(Either<Failure, Object?> result) =>
      result.getLeft().toNullable()!;

  group('home repository', () {
    test('a database error becomes a readable failure', () async {
      final repository = HomeRepositoryImpl(
        _ThrowingHome(ServerException.from(dbError, stack)),
        _Network(connected: true),
      );

      final failure = left(await repository.getChaptersByCategory('x'));

      expect(failure.message, FailureMessages.forbidden);
      expect(failure.message, isNot(contains('app_config')));
    });

    test('a lost connection becomes a network failure', () async {
      final repository = HomeRepositoryImpl(
        _ThrowingHome(
          ServerException.from(const SocketException('Failed host'), stack),
        ),
        _Network(connected: true),
      );

      final failure = left(await repository.getChaptersByCategory('x'));

      expect(failure, isA<NetworkFailure>());
      expect(failure.message, FailureMessages.network);
    });

    test(
      'offline never reaches the data source and reads in Indonesian',
      () async {
        final remote = _ThrowingHome(StateError('unused'));
        final repository = HomeRepositoryImpl(
          remote,
          _Network(connected: false),
        );

        final failure = left(await repository.getChaptersByCategory('x'));

        expect(remote.calls, 0);
        expect(failure, const NetworkFailure());
        expect(failure.message, FailureMessages.network);
      },
    );
  });

  group('update repository', () {
    test('a data source error becomes a readable failure', () async {
      final repository = UpdateRepositoryImpl(
        _ThrowingUpdate(ServerException.from(dbError, stack)),
      );

      final failure = left(await repository.getAppVersion('android'));

      expect(failure.message, FailureMessages.forbidden);
    });

    test('an error that is not a ServerException is not echoed', () async {
      final repository = UpdateRepositoryImpl(
        _ThrowingUpdate(StateError('Bad state: secret detail')),
      );

      final failure = left(await repository.getAppVersion('android'));

      expect(failure, isA<UnknownFailure>());
      expect(failure.message, FailureMessages.unknown);
    });

    test('a timeout gets its own text', () async {
      final repository = UpdateRepositoryImpl(
        _ThrowingUpdate(
          ServerException.from(
            TimeoutException('x', const Duration(seconds: 5)),
            stack,
          ),
        ),
      );

      final failure = left(await repository.getAppVersion('android'));

      expect(failure.message, FailureMessages.timeout);
    });
  });
}
