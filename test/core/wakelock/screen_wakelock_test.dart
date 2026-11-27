import 'package:flutter_test/flutter_test.dart';
import 'package:ishari/core/wakelock/screen_wakelock.dart';

void main() {
  late List<bool> toggles;
  late ScreenWakelock wakelock;

  setUp(() {
    toggles = [];
    wakelock = ScreenWakelock(
      toggle: ({required enable}) async => toggles.add(enable),
    );
  });

  test('enables for the first holder and disables after the last', () {
    wakelock
      ..acquire()
      ..acquire()
      ..release();
    expect(toggles, [true]);

    wakelock.release();
    expect(toggles, [true, false]);
  });

  test('an unbalanced release does not break the next holder', () {
    wakelock
      ..release()
      ..acquire();

    expect(toggles, [true]);
  });

  test('a failing platform call is swallowed', () async {
    final failing = ScreenWakelock(
      toggle: ({required enable}) async => throw StateError('no activity'),
    )..acquire();
    await Future<void>.delayed(Duration.zero);

    expect(failing.release, returnsNormally);
    await Future<void>.delayed(Duration.zero);
  });
}
