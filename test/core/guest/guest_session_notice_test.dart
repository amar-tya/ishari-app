// A guest restored from storage has never had a session, so losing one is not
// news to them: the session-expired notice must never be raised for a guest.
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishari/core/guest/guest_mode_store.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/auth_fakes.dart';

void main() {
  late ControllableAuthRepository repository;
  late AuthBloc bloc;
  late ValueNotifier<bool> flag;
  late GuestModeStore store;

  setUp(() async {
    SharedPreferences.setMockInitialValues({GuestModeStore.key: true});
    flag = ValueNotifier(false);
    store = GuestModeStore(await SharedPreferences.getInstance(), flag: flag)
      ..start();
    expect(flag.value, isTrue, reason: 'restored as a guest');

    repository = ControllableAuthRepository();
    bloc = buildControllableAuthBloc(repository);
  });

  tearDown(() async {
    await bloc.close();
    await repository.changes.close();
    flag.dispose();
  });

  Future<void> coldStartWithoutSession() async {
    repository.sessionUser = null;
    repository.changes.add(null);
    bloc.add(const AuthEvent.checkAuthStatus());
    await pumpEventQueue();
    expect(bloc.state, const AuthState.unauthenticated());
  }

  test('a cold start as a guest raises no notice', () async {
    await coldStartWithoutSession();
    expect(bloc.takeSessionExpiredNotice(), isFalse);
  });

  test('a null from the SDK stream raises no notice', () async {
    await coldStartWithoutSession();
    repository.changes
      ..add(null)
      ..add(null);
    await pumpEventQueue();
    expect(bloc.state, const AuthState.unauthenticated());
    expect(bloc.takeSessionExpiredNotice(), isFalse);
  });

  test('an error from the SDK stream raises no notice', () async {
    await coldStartWithoutSession();
    repository.changes.addError(StateError('offline'));
    await pumpEventQueue();
    expect(bloc.state, const AuthState.unauthenticated());
    expect(bloc.takeSessionExpiredNotice(), isFalse);
  });

  test('a null before the startup check raises no notice', () async {
    repository.changes.add(null);
    await pumpEventQueue();
    await coldStartWithoutSession();
    expect(bloc.takeSessionExpiredNotice(), isFalse);
  });

  test('control: a guest who signs in and then loses it is told', () async {
    await coldStartWithoutSession();
    bloc.add(const AuthEvent.signInWithGoogle());
    await pumpEventQueue();
    expect(bloc.state, const AuthState.authenticated(testUser));

    repository.changes.add(null);
    await pumpEventQueue();

    expect(bloc.takeSessionExpiredNotice(), isTrue);
    expect(bloc.takeSessionExpiredNotice(), isFalse);
  });

  test('a restored session beats the guest flag, and is then told', () async {
    repository.sessionUser = testUser;
    repository.changes.add(testUser);
    bloc.add(const AuthEvent.checkAuthStatus());
    await pumpEventQueue();
    expect(bloc.state, const AuthState.authenticated(testUser));

    store.settle(bloc.state);
    expect(flag.value, isFalse);

    // Losing the session now is the signed-in user's, with its notice.
    repository.changes.add(null);
    await pumpEventQueue();
    expect(bloc.takeSessionExpiredNotice(), isTrue);
  });
}
