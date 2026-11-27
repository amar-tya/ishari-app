import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ishari/core/errors/failures.dart';
import 'package:ishari/features/auth/domain/entities/user_entity.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';

import '../../auth_fakes.dart';

const _updated = UserEntity(
  id: 'user-1',
  email: 'user@example.com',
  displayName: 'New Name',
);

const _authenticated = AuthState.authenticated(testUser);
const _unauthenticated = AuthState.unauthenticated();
const _loading = AuthState.loading();

void main() {
  late ControllableAuthRepository repository;
  late AuthBloc bloc;
  late List<AuthState> states;

  setUp(() {
    repository = ControllableAuthRepository();
    bloc = buildControllableAuthBloc(repository);
    states = [];
    bloc.stream.listen(states.add);
  });

  tearDown(() async {
    await bloc.close();
    await repository.changes.close();
  });

  Future<void> sdkEmits(UserEntity? user) async {
    repository.changes.add(user);
    await pumpEventQueue();
  }

  Future<void> send(AuthEvent event) async {
    bloc.add(event);
    await pumpEventQueue();
  }

  /// A cold start with a restored session: the SDK replays it, then the
  /// startup check finds it.
  Future<void> startSignedIn() async {
    repository.sessionUser = testUser;
    await sdkEmits(testUser);
    await send(const AuthEvent.checkAuthStatus());
    expect(bloc.state, _authenticated);
    states.clear();
  }

  group('while authenticated', () {
    test('a lost session signs the user out with one notice', () async {
      await startSignedIn();

      await sdkEmits(null);

      expect(states, [_unauthenticated]);
      expect(bloc.takeSessionExpiredNotice(), isTrue);
      expect(bloc.takeSessionExpiredNotice(), isFalse);
    });

    test('a repeated signed-out event does not raise it again', () async {
      await startSignedIn();
      await sdkEmits(null);
      bloc.takeSessionExpiredNotice();

      await sdkEmits(null);

      expect(bloc.takeSessionExpiredNotice(), isFalse);
    });

    test('changed user data replaces the user', () async {
      await startSignedIn();

      await sdkEmits(_updated);

      expect(states, [const AuthState.authenticated(_updated)]);
    });

    test('an unchanged user emits nothing', () async {
      await startSignedIn();

      await sdkEmits(testUser);

      expect(states, isEmpty);
    });

    test('stream errors change nothing and later events still work', () async {
      await startSignedIn();

      repository.changes.addError(StateError('refresh failed offline'));
      await pumpEventQueue();

      expect(states, isEmpty);
      expect(bloc.takeSessionExpiredNotice(), isFalse);

      await sdkEmits(null);

      expect(states, [_unauthenticated]);
    });
  });

  group('outside authenticated, stream values are ignored', () {
    test('before the startup check', () async {
      await sdkEmits(testUser);
      await sdkEmits(null);

      expect(states, isEmpty);
      expect(bloc.state, const AuthState.initial());
    });

    test('when unauthenticated, such as a guest', () async {
      await send(const AuthEvent.checkAuthStatus());
      states.clear();

      await sdkEmits(testUser);
      await sdkEmits(null);

      expect(states, isEmpty);
      expect(bloc.takeSessionExpiredNotice(), isFalse);
    });

    test('after an error', () async {
      repository.currentUser = () async =>
          left(const ServerFailure(message: 'boom'));
      await send(const AuthEvent.checkAuthStatus());
      states.clear();

      await sdkEmits(testUser);
      await sdkEmits(null);

      expect(states, isEmpty);
    });

    test('while a sign-in is in progress', () async {
      final signIn = Completer<Either<Failure, UserEntity>>();
      repository.signIn = () => signIn.future;
      await send(const AuthEvent.signInWithGoogle());

      await sdkEmits(testUser);

      expect(states, [_loading]);
      signIn.complete(right(testUser));
      await pumpEventQueue();
      expect(states, [_loading, _authenticated]);
    });
  });

  group('no session-expired notice', () {
    test('on first launch or a cold start without a session', () async {
      // The SDK replays an initial session of null.
      await sdkEmits(null);

      await send(const AuthEvent.checkAuthStatus());

      expect(bloc.state, _unauthenticated);
      expect(bloc.takeSessionExpiredNotice(), isFalse);
    });

    test('when the signed-out value arrives during that check', () async {
      final check = Completer<Either<Failure, UserEntity?>>();
      repository.currentUser = () => check.future;
      await send(const AuthEvent.checkAuthStatus());
      await sdkEmits(null);

      check.complete(right(null));
      await pumpEventQueue();

      expect(bloc.state, _unauthenticated);
      expect(bloc.takeSessionExpiredNotice(), isFalse);
    });

    test('on an explicit sign-out', () async {
      await startSignedIn();
      // The SDK reports the sign-out before the call returns.
      repository.signOutResult = () async {
        repository.sessionUser = null;
        repository.changes.add(null);
        await pumpEventQueue();
        return right(unit);
      };

      await send(const AuthEvent.signOut());
      await sdkEmits(null);

      expect(states, [_loading, _unauthenticated]);
      expect(bloc.takeSessionExpiredNotice(), isFalse);

      // Nor on a later startup check by the same bloc.
      await send(const AuthEvent.checkAuthStatus());
      expect(bloc.takeSessionExpiredNotice(), isFalse);
    });

    test('on an explicit sign-out that fails', () async {
      await startSignedIn();
      repository.signOutResult = () async =>
          left(const ServerFailure(message: 'boom'));

      await send(const AuthEvent.signOut());
      await sdkEmits(null);

      expect(states, [_loading, const AuthState.error('boom')]);
      expect(bloc.takeSessionExpiredNotice(), isFalse);
    });

    test('left over once the user signs in again', () async {
      await startSignedIn();
      await sdkEmits(null);

      await send(const AuthEvent.signInWithGoogle());

      expect(bloc.takeSessionExpiredNotice(), isFalse);
    });

    test('left over once the user signs out', () async {
      await startSignedIn();
      await sdkEmits(null);

      await send(const AuthEvent.signOut());

      expect(bloc.takeSessionExpiredNotice(), isFalse);
    });
  });

  group('session lost while the startup check is pending', () {
    late Completer<Either<Failure, UserEntity?>> check;

    setUp(() {
      check = Completer();
      repository.currentUser = () => check.future;
    });

    test('never reports the stale user as authenticated', () async {
      await sdkEmits(testUser);
      await send(const AuthEvent.checkAuthStatus());
      await sdkEmits(null);

      check.complete(right(testUser));
      await pumpEventQueue();

      expect(states, [_loading, _unauthenticated]);
      expect(bloc.takeSessionExpiredNotice(), isTrue);
    });

    test('raises the notice when the check already sees no user', () async {
      await sdkEmits(testUser);
      await send(const AuthEvent.checkAuthStatus());
      await sdkEmits(null);

      check.complete(right(null));
      await pumpEventQueue();

      expect(states, [_loading, _unauthenticated]);
      expect(bloc.takeSessionExpiredNotice(), isTrue);
    });

    test('is forgotten if a session arrives again', () async {
      await send(const AuthEvent.checkAuthStatus());
      await sdkEmits(null);
      await sdkEmits(testUser);

      check.complete(right(testUser));
      await pumpEventQueue();

      expect(states, [_loading, _authenticated]);
      expect(bloc.takeSessionExpiredNotice(), isFalse);
    });
  });

  group('close', () {
    test('stops listening to the SDK', () async {
      expect(repository.changes.hasListener, isTrue);

      await bloc.close();

      expect(repository.changes.hasListener, isFalse);
    });

    test('a replacement bloc works while the old check still hangs', () async {
      repository.currentUser = () =>
          Completer<Either<Failure, UserEntity?>>().future;
      await send(const AuthEvent.checkAuthStatus());
      // The startup retry does not wait for the stuck bloc to finish closing.
      unawaited(bloc.close());

      repository.currentUser = null;
      repository.sessionUser = testUser;
      final replacement = buildControllableAuthBloc(repository);
      addTearDown(replacement.close);
      replacement.add(const AuthEvent.checkAuthStatus());
      await pumpEventQueue();
      expect(replacement.state, _authenticated);

      await sdkEmits(null);

      expect(replacement.state, _unauthenticated);
      expect(states, [_loading]);
    });
  });
}
