import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'workflow_helpers.dart';

// The upload script itself is covered by scripts/test_upload_sentry_symbols.sh.
void main() {
  const uploadScript = 'bash scripts/upload_sentry_symbols.sh';

  for (final MapEntry(key: name, value: content)
      in releaseWorkflows().entries) {
    group(name, () {
      final build = releaseBuildCommand.firstMatch(content)!.start;
      final upload = content.indexOf(uploadScript);

      test('obfuscates with split debug info in build/symbols', () {
        expect(content, contains('--split-debug-info=build/symbols'));
      });

      test('uploads Dart symbols to Sentry after the build', () {
        expect(upload, greaterThan(build));
      });

      test('upload is the last step, so it cannot block distribution', () {
        expect(upload, isNonNegative);
        expect(content.substring(upload), isNot(contains('- name:')));
      });

      test('upload runs whenever the build succeeded and is not muted', () {
        final stepStart = content.lastIndexOf('- name:', upload);
        final step = content.substring(stepStart);

        expect(
          step,
          matches(
            RegExp(
              r"if: \$\{\{ !cancelled\(\) && steps\.\w+\.outcome == 'success' \}\}",
            ),
          ),
        );
        expect(step, contains(r'secrets.SENTRY_AUTH_TOKEN'));
        expect(content, isNot(contains('continue-on-error')));
      });

      test('upload reads the obfuscation map the build saved', () {
        final mapPath = RegExp(
          r'upload_sentry_symbols\.sh "[^"]+" (\S+)',
        ).firstMatch(content)?.group(1);

        expect(mapPath, isNotNull);
        // Shorebird saves a release's map here by itself.
        final savedByShorebird =
            content.contains('shorebird release android') &&
            mapPath == 'build/shorebird/obfuscation_map.json';
        final savedByFlag = content.contains(
          '--extra-gen-snapshot-options=--save-obfuscation-map=$mapPath',
        );
        expect(savedByShorebird || savedByFlag, isTrue);
      });
    });
  }

  group('pubspec sentry config', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final sentry = RegExp(
      r'^sentry:\n((?:[ \t]+.*\n)+)',
      multiLine: true,
    ).firstMatch(pubspec.replaceAll('\r\n', '\n'))!.group(1)!;

    test('has no auth_token, which the plugin would pass on literally', () {
      expect(
        sentry,
        isNot(matches(RegExp(r'^\s*auth_token:', multiLine: true))),
      );
    });

    test('does not try to associate commits', () {
      expect(sentry, contains('commits: false'));
    });

    test('uses a plugin version that can upload the obfuscation map', () {
      final constraint = RegExp(
        r'sentry_dart_plugin: \^(\d+)\.(\d+)',
      ).firstMatch(pubspec)!;
      final major = int.parse(constraint.group(1)!);
      final minor = int.parse(constraint.group(2)!);

      expect(major > 3 || (major == 3 && minor >= 2), isTrue);
    });
  });
}
