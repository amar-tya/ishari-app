import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ishari/core/guest/guest_mode_store.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/splash/startup/startup_steps.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/auth_fakes.dart';

/// Preferences that record writes and can be told to fail or to hold a value
/// of the wrong type.
class _FakePrefs extends Fake implements SharedPreferences {
  _FakePrefs([this.stored]);

  Object? stored;
  final writes = <String>[];
  bool failReads = false;
  bool failWrites = false;

  @override
  bool? getBool(String key) {
    if (failReads) throw StateError('unreadable');
    if (key != GuestModeStore.key) return null;
    final value = stored;
    if (value == null) return null;
    // Like the real plugin: another type is a cast error.
    return value as bool;
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    writes.add('set $key=$value');
    if (failWrites) throw StateError('disk full');
    stored = value;
    return true;
  }

  @override
  Future<bool> remove(String key) async {
    writes.add('remove $key');
    if (failWrites) throw StateError('disk full');
    stored = null;
    return true;
  }
}

void main() {
  late ValueNotifier<bool> flag;

  setUp(() => flag = ValueNotifier(false));
  tearDown(() => flag.dispose());

  GuestModeStore storeOver(_FakePrefs prefs) =>
      GuestModeStore(prefs, flag: flag);

  group('restoring', () {
    test('no saved value (an install from before) is not a guest', () {
      final prefs = _FakePrefs();
      storeOver(prefs).start();
      expect(flag.value, isFalse);
      expect(prefs.writes, isEmpty);
    });

    test('a saved guest comes back as a guest, without writing', () {
      final prefs = _FakePrefs(true);
      storeOver(prefs).start();
      expect(flag.value, isTrue);
      expect(prefs.writes, isEmpty);
    });

    test('a value of the wrong type is not a guest and does not throw', () {
      final prefs = _FakePrefs('yes');
      storeOver(prefs).start();
      expect(flag.value, isFalse);
    });

    test('unreadable storage is not a guest and does not throw', () {
      final prefs = _FakePrefs(true)..failReads = true;
      storeOver(prefs).start();
      expect(flag.value, isFalse);
    });

    test('works with the real preferences too', () async {
      SharedPreferences.setMockInitialValues({GuestModeStore.key: true});
      final prefs = await SharedPreferences.getInstance();
      GuestModeStore(prefs, flag: flag).start();
      expect(flag.value, isTrue);
    });

    test('the real preferences hold no value on a fresh install', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      GuestModeStore(prefs, flag: flag).start();
      expect(flag.value, isFalse);
    });

    test('a wrong type in the real preferences is not a guest', () async {
      SharedPreferences.setMockInitialValues({GuestModeStore.key: 'yes'});
      final prefs = await SharedPreferences.getInstance();
      GuestModeStore(prefs, flag: flag).start();
      expect(flag.value, isFalse);
    });
  });

  group('saving', () {
    test('choosing guest is saved, leaving guest removes the value', () async {
      final prefs = _FakePrefs();
      storeOver(prefs).start();

      flag.value = true;
      await pumpEventQueue();
      expect(prefs.stored, isTrue);

      flag.value = false;
      await pumpEventQueue();
      expect(prefs.stored, isNull);
      expect(prefs.writes, [
        'set ${GuestModeStore.key}=true',
        'remove ${GuestModeStore.key}',
      ]);
    });

    test('a failing write is dropped, later ones still happen', () async {
      final prefs = _FakePrefs()..failWrites = true;
      storeOver(prefs).start();

      flag.value = true;
      await pumpEventQueue();
      expect(flag.value, isTrue);

      prefs.failWrites = false;
      flag
        ..value = false
        ..value = true;
      await pumpEventQueue();
      expect(prefs.stored, isTrue);
    });

    test('nothing is saved before start', () async {
      final prefs = _FakePrefs();
      storeOver(prefs);
      flag.value = true;
      await pumpEventQueue();
      expect(prefs.writes, isEmpty);
    });
  });

  group('a startup retry', () {
    test('does not attach a second listener or rewrite the value', () async {
      final prefs = _FakePrefs(true);
      final store = storeOver(prefs);
      final steps = StartupSteps();
      var runs = 0;
      Future<void> step() async {
        runs++;
        store.start();
      }

      await steps.runOnce('guest_mode', step);
      // The retry button runs the same steps again.
      await steps.runOnce('guest_mode', step);
      // A step body that does run twice is harmless too.
      store.start();

      expect(runs, 1);
      expect(flag.value, isTrue);
      expect(prefs.writes, isEmpty, reason: 'restored value is not rewritten');

      flag.value = false;
      await pumpEventQueue();
      expect(prefs.writes, ['remove ${GuestModeStore.key}']);
    });

    test('does not undo a choice made since the first run', () async {
      final prefs = _FakePrefs();
      final store = storeOver(prefs)..start();
      flag.value = true;
      await pumpEventQueue();

      store.start();

      expect(flag.value, isTrue);
    });
  });

  group('settle', () {
    final states = <String, AuthState>{
      'initial': const AuthState.initial(),
      'loading': const AuthState.loading(),
      'unauthenticated': const AuthState.unauthenticated(),
      'error': const AuthState.error('failed'),
    };

    for (final MapEntry(key: name, value: state) in states.entries) {
      test('$name leaves a guest alone', () async {
        final prefs = _FakePrefs(true);
        storeOver(prefs)
          ..start()
          ..settle(state);
        await pumpEventQueue();

        expect(flag.value, isTrue);
        expect(prefs.stored, isTrue);
        expect(prefs.writes, isEmpty);
      });
    }

    test('authenticated makes the session win and forgets the guest', () async {
      final prefs = _FakePrefs(true);
      storeOver(prefs)
        ..start()
        ..settle(const AuthState.authenticated(testUser));
      await pumpEventQueue();

      expect(flag.value, isFalse);
      expect(prefs.stored, isNull);
    });

    test('authenticated without a guest flag writes nothing', () async {
      final prefs = _FakePrefs();
      storeOver(prefs)
        ..start()
        ..settle(const AuthState.authenticated(testUser));
      await pumpEventQueue();

      expect(flag.value, isFalse);
      expect(prefs.writes, isEmpty);
    });
  });
}
