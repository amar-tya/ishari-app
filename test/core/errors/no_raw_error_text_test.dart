// Guards the rule from issue #38: text shown to the user must not be built
// from a caught error. Raw errors go to the logger, and ServerException.from
// keeps them out of the message.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// A line that breaks the rule, and what to do about it.
class _Rule {
  const _Rule(this.pattern, this.advice);

  final RegExp pattern;
  final String advice;
}

final _rules = <_Rule>[
  _Rule(
    RegExp(r'ServerException\(\s*message:\s*\w+\.toString\(\)'),
    'wrap the error with ServerException.from(e, stackTrace) instead',
  ),
  _Rule(
    RegExp(r'Failure\(\s*message:\s*\w+\.toString\(\)'),
    'build the failure with mapErrorToFailure(e, stackTrace) instead',
  ),
  _Rule(
    RegExp(r"""State\.error\([^)]*['"][^'"]*\$\{?(e|error|err|exception)\b"""),
    'show a text from FailureMessages and log the error instead',
  ),
];

/// A file path and the 1-based lines in it that break a rule.
List<String> _violations(File file) {
  final found = <String>[];
  final lines = file.readAsLinesSync();
  // Some calls are split over lines, so match on the joined text too.
  final text = lines.join('\n');
  for (final rule in _rules) {
    for (final match in rule.pattern.allMatches(text)) {
      final line = '\n'.allMatches(text.substring(0, match.start)).length + 1;
      found.add(
        '${file.path}:$line: ${lines[line - 1].trim()}\n'
        '    -> ${rule.advice}',
      );
    }
  }
  return found;
}

void main() {
  test('no code builds user-visible error text from a caught error', () {
    final files = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .where((f) => !f.path.endsWith('.freezed.dart'))
        .where((f) => !f.path.endsWith('.g.dart'));

    final violations = [for (final file in files) ..._violations(file)];

    expect(
      violations,
      isEmpty,
      reason:
          'Raw error text can reach the user (issue #38). Fix each line:\n'
          '${violations.join('\n')}',
    );
  });

  test('the rules catch the patterns they are written for', () {
    final samples = {
      0: 'throw ServerException(message: e.toString());',
      1: 'return left(UnknownFailure(message: e.toString()));',
      2: r"emit(MuhudState.error(message: 'Error: $e'));",
    };
    samples.forEach((index, sample) {
      expect(_rules[index].pattern.hasMatch(sample), isTrue, reason: sample);
    });
    expect(
      _rules[0].pattern.hasMatch('throw ServerException.from(e, stackTrace);'),
      isFalse,
    );
  });
}
