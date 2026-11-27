import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/errors/exceptions.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/core/network/network_info.dart';
import 'package:ishari/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:ishari/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:ishari/features/auth/data/models/user_model.dart';
import 'package:ishari/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ishari/features/auth/domain/entities/user_entity.dart';

const _cacheKey = 'cached_user';

const _user = UserModel(id: 'user-1', email: 'user@example.com');
const _staleUser = UserModel(id: 'old-user', email: 'old@example.com');

class _FakeRemote extends Fake implements AuthRemoteDataSource {
  UserModel? sessionUser;
  Exception? signInError;
  Exception? signOutError;
  Exception? currentUserError;

  @override
  Future<UserModel> signInWithGoogle() async {
    if (signInError case final error?) throw error;
    return _user;
  }

  @override
  Future<void> signOut() async {
    if (signOutError case final error?) throw error;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    if (currentUserError case final error?) throw error;
    return sessionUser;
  }
}

class _FakeSecureStorage extends Fake implements FlutterSecureStorage {
  final values = <String, String>{};
  bool broken = false;
  int writes = 0;

  void _failIfBroken() {
    if (broken) throw StateError('keystore unavailable');
  }

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    writes++;
    _failIfBroken();
    values[key] = value!;
  }

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _failIfBroken();
    return values[key];
  }

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _failIfBroken();
    values.remove(key);
  }
}

class _FakeNetwork implements NetworkInfo {
  Future<bool> Function() connected = () async => true;

  @override
  Future<bool> get isConnected => connected();
}

void main() {
  late _FakeRemote remote;
  late _FakeSecureStorage storage;
  late _FakeNetwork network;
  late AuthRepositoryImpl repository;

  setUp(() {
    remote = _FakeRemote();
    storage = _FakeSecureStorage();
    network = _FakeNetwork();
    repository = AuthRepositoryImpl(
      remote,
      AuthLocalDataSourceImpl(storage),
      network,
    );
  });

  void seedStaleCache() =>
      storage.values[_cacheKey] = json.encode(_staleUser.toJson());

  void goOffline() => network.connected = () async => false;

  group('signInWithGoogle', () {
    test('returns the user without copying it to secure storage', () async {
      final result = await repository.signInWithGoogle();

      expect(result, right<Failure, UserEntity>(_user.toEntity()));
      expect(storage.writes, 0);
    });

    test('succeeds when secure storage is broken', () async {
      storage.broken = true;

      final result = await repository.signInWithGoogle();

      expect(result, right<Failure, UserEntity>(_user.toEntity()));
    });

    test('offline is a network failure', () async {
      goOffline();

      final result = await repository.signInWithGoogle();

      expect(result.getLeft().toNullable(), isA<NetworkFailure>());
    });

    test('cancel and server errors map to failures', () async {
      remote.signInError = const CanceledSignInException();
      final canceled = await repository.signInWithGoogle();
      remote.signInError = const ServerException(message: 'boom');
      final failed = await repository.signInWithGoogle();

      expect(canceled.getLeft().toNullable(), isA<CanceledFailure>());
      expect(
        failed.getLeft().toNullable(),
        const ServerFailure(message: 'boom'),
      );
    });
  });

  group('getCurrentUser', () {
    test('returns the session user while offline, not the old cache', () async {
      goOffline();
      seedStaleCache();
      remote.sessionUser = _user;

      final result = await repository.getCurrentUser();

      expect(result, right<Failure, UserEntity?>(_user.toEntity()));
    });

    test('without a session is signed out offline, cache ignored', () async {
      goOffline();
      seedStaleCache();

      final result = await repository.getCurrentUser();

      expect(result, right<Failure, UserEntity?>(null));
      expect(storage.values, isNot(contains(_cacheKey)));
    });

    test('without a session removes the legacy cache online', () async {
      seedStaleCache();

      final result = await repository.getCurrentUser();

      expect(result, right<Failure, UserEntity?>(null));
      expect(storage.values, isNot(contains(_cacheKey)));
    });

    test('does not wait for a connectivity check', () async {
      network.connected = () => Completer<bool>().future;
      remote.sessionUser = _user;

      final result = await repository.getCurrentUser().timeout(
        const Duration(seconds: 1),
      );

      expect(result, right<Failure, UserEntity?>(_user.toEntity()));
    });

    test('completes with a session when secure storage is broken', () async {
      storage.broken = true;
      remote.sessionUser = _user;

      final result = await repository.getCurrentUser();

      expect(result, right<Failure, UserEntity?>(_user.toEntity()));
    });

    test('completes without a session when the cache clear fails', () async {
      storage.broken = true;

      final result = await repository.getCurrentUser();

      expect(result, right<Failure, UserEntity?>(null));
    });

    test('maps a remote error to a server failure', () async {
      remote.currentUserError = const ServerException(message: 'boom');

      final result = await repository.getCurrentUser();

      expect(
        result.getLeft().toNullable(),
        const ServerFailure(message: 'boom'),
      );
    });
  });

  group('signOut', () {
    test('removes the legacy cache', () async {
      seedStaleCache();

      final result = await repository.signOut();

      expect(result, right<Failure, Unit>(unit));
      expect(storage.values, isNot(contains(_cacheKey)));
    });

    test('removes the legacy cache even when sign-out fails', () async {
      seedStaleCache();
      remote.signOutError = const ServerException(message: 'boom');

      final result = await repository.signOut();

      expect(
        result.getLeft().toNullable(),
        const ServerFailure(message: 'boom'),
      );
      expect(storage.values, isNot(contains(_cacheKey)));
    });

    test('succeeds when the cache clear fails', () async {
      storage.broken = true;

      final result = await repository.signOut();

      expect(result, right<Failure, Unit>(unit));
    });

    test('keeps the sign-out failure when the cache clear fails too', () async {
      storage.broken = true;
      remote.signOutError = const ServerException(message: 'boom');

      final result = await repository.signOut();

      expect(
        result.getLeft().toNullable(),
        const ServerFailure(message: 'boom'),
      );
    });
  });
}
