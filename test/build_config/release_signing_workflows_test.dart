import 'package:flutter_test/flutter_test.dart';

import 'workflow_helpers.dart';

// The Gradle guard itself is covered by scripts/test_release_signing.sh.
void main() {
  final workflows = releaseWorkflows();

  test('finds every workflow that builds an Android release', () {
    expect(
      workflows.keys,
      unorderedEquals([
        'build-and-distribute-android.yml',
        'build-staging-android.yml',
        'release-android.yml',
        'shorebird-patch-android.yml',
      ]),
    );
  });

  for (final MapEntry(key: name, value: content) in workflows.entries) {
    group(name, () {
      test('writes android/key.properties before building', () {
        final keyFile = content.indexOf('> android/key.properties');
        final build = releaseBuildCommand.firstMatch(content)!.start;

        expect(keyFile, isNonNegative);
        expect(keyFile, lessThan(build));
      });

      test('never opts in to debug signing', () {
        expect(content, isNot(contains('allowDebugSigning')));
      });
    });
  }
}
