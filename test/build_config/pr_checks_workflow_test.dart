import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// Guards .github/workflows/pr-checks.yml, which runs on a PUBLIC repo for
// untrusted fork PRs. A failure here means someone weakened that safety (or
// the dummy env no longer matches lib/core/env/env.dart); the message says
// what to fix.
const _workflowPath = '.github/workflows/pr-checks.yml';

/// Workflow text without comment lines, so a comment can neither satisfy nor
/// break a check.
String _readWorkflow() => File(_workflowPath)
    .readAsLinesSync()
    .where((line) => !line.trimLeft().startsWith('#'))
    .join('\n');

void main() {
  late String workflow;

  setUpAll(() {
    expect(
      File(_workflowPath).existsSync(),
      isTrue,
      reason: '$_workflowPath is missing: PR CI (flutter analyze + test) '
          'would not run.',
    );
    workflow = _readWorkflow();
  });

  group('pr-checks.yml safety (public repo, fork PRs)', () {
    test('runs on pull_request and never on pull_request_target', () {
      expect(workflow, matches(RegExp(r'^\s{2}pull_request:', multiLine: true)),
          reason: 'Trigger must be `pull_request`.');
      expect(workflow, isNot(contains('pull_request_target')),
          reason: '`pull_request_target` runs fork code with a privileged '
              'token and secrets. Use `pull_request`.');
    });

    test('has no secrets of any kind', () {
      expect(workflow, isNot(contains('secrets.')),
          reason: 'Do not read secrets in the PR workflow. The env file is '
              'written with dummy values only.');
      expect(workflow, isNot(contains('secrets:')),
          reason: '`secrets: inherit` or passing secrets is not allowed.');
      expect(workflow, isNot(contains('inherit')));
    });

    test('token is read-only: top-level permissions is contents: read', () {
      final top = RegExp(
        r'^permissions:\n((?:[ \t]+.*\n?)+)',
        multiLine: true,
      ).firstMatch(workflow);
      expect(top, isNotNull,
          reason: 'Add a top-level `permissions:\\n  contents: read` block.');
      final lines = top!
          .group(1)!
          .split('\n')
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty)
          .toList();
      expect(lines, equals(['contents: read']),
          reason: 'permissions must be exactly `contents: read` (no write, '
              'no other scopes).');
      expect(workflow, isNot(contains(': write')));
    });

    test('checkout does not persist credentials', () {
      expect(workflow, contains('persist-credentials: false'),
          reason: 'Add `persist-credentials: false` to actions/checkout.');
    });

    test('every action is pinned by full commit SHA', () {
      final uses = RegExp(r'^\s*(?:-\s*)?uses:\s*(\S+)', multiLine: true)
          .allMatches(workflow)
          .map((m) => m.group(1)!)
          .toList();
      expect(uses, isNotEmpty);
      for (final ref in uses) {
        expect(
          ref,
          matches(RegExp(r'^[\w.-]+/[\w./-]+@[0-9a-f]{40}$')),
          reason: '`uses: $ref` must be pinned to a 40-char commit SHA '
              '(keep the version in a trailing comment).',
        );
      }
    });

    test('has no continue-on-error that would hide a failing check', () {
      expect(workflow, isNot(contains('continue-on-error')),
          reason: 'analyze/test must be able to fail the job.');
    });
  });

  group('pr-checks.yml behavior', () {
    test('uses the Flutter version pinned in .fvmrc', () {
      final fvmrc =
          jsonDecode(File('.fvmrc').readAsStringSync()) as Map<String, dynamic>;
      final version = fvmrc['flutter'] as String;
      expect(workflow, contains("flutter-version: '$version'"),
          reason: 'flutter-version in $_workflowPath must equal .fvmrc '
              '($version). Update both together (and the release workflows).');
    });

    test('runs flutter analyze and flutter test', () {
      expect(workflow, matches(RegExp(r'run:\s*flutter analyze\b')),
          reason: 'The job must run `flutter analyze`.');
      expect(workflow, matches(RegExp(r'run:\s*flutter test\s*$',
          multiLine: true)),
          reason: 'The job must run `flutter test`.');
    });

    test('dummy env covers every required field of lib/core/env/env.dart', () {
      final envDart = File('lib/core/env/env.dart').readAsStringSync();
      final fields = RegExp(
        r'@EnviedField\(([^)]*)\)\s*static final String\??\s+(\w+)\s*=',
      ).allMatches(envDart);
      expect(fields, isNotEmpty, reason: 'Could not parse env.dart fields.');

      for (final match in fields) {
        final args = match.group(1)!;
        if (args.contains('optional: true') ||
            args.contains('defaultValue')) {
          continue;
        }
        final key = match
            .group(2)!
            .replaceAllMapped(
              RegExp('[A-Z]'),
              (m) => '_${m.group(0)}',
            )
            .toUpperCase();
        expect(
          workflow,
          matches(RegExp('^\\s*$key=\\S+', multiLine: true)),
          reason: 'env.dart now requires `$key`: add a dummy `$key=...` line '
              'to the env heredoc in $_workflowPath, or build_runner fails '
              'in CI.',
        );
      }
    });

    test('dummy env values look obviously fake', () {
      final lines = RegExp(r'^\s*([A-Z_]+)=(\S+)\s*$', multiLine: true)
          .allMatches(workflow)
          .where((m) => m.group(1) != 'ANALYZE_FLAGS');
      for (final m in lines) {
        final value = m.group(2)!;
        if (m.group(1) == 'APP_ENV') continue;
        expect(
          value,
          anyOf(contains('placeholder'), matches(RegExp(r'0{10,}'))),
          reason: '${m.group(1)} must be an obviously fake value '
              '("placeholder" or zeros), never a real key.',
        );
      }
    });
  });
}
