/// Finds `GoogleFonts.<method>(...)` calls in Dart source and works out which
/// weights and styles each one can request. Anything it cannot work out is
/// reported as a problem instead of being skipped.
library;

import 'package:flutter/painting.dart';

typedef FontRequest = ({String family, FontWeight weight, FontStyle style});

typedef FontCall = ({
  String location,
  String method,
  FontWeight weight,
  FontStyle style,
});

typedef ScanResult = ({List<FontCall> requests, List<String> problems});

/// Members of `GoogleFonts` that do not request a font by themselves.
const _nonFontMembers = {'config', 'asMap', 'pendingFonts'};

const _weights = {
  'FontWeight.w100': FontWeight.w100,
  'FontWeight.w200': FontWeight.w200,
  'FontWeight.w300': FontWeight.w300,
  'FontWeight.w400': FontWeight.w400,
  'FontWeight.w500': FontWeight.w500,
  'FontWeight.w600': FontWeight.w600,
  'FontWeight.w700': FontWeight.w700,
  'FontWeight.w800': FontWeight.w800,
  'FontWeight.w900': FontWeight.w900,
  'FontWeight.normal': FontWeight.normal,
  'FontWeight.bold': FontWeight.bold,
};

const _styles = {
  'FontStyle.normal': FontStyle.normal,
  'FontStyle.italic': FontStyle.italic,
};

ScanResult scanGoogleFontsCalls(String source, String path) {
  // Same length as [source], so offsets are interchangeable.
  final code = maskCommentsAndStrings(source);
  final requests = <FontCall>[];
  final problems = <String>[];

  for (final match in RegExp(r'\bGoogleFonts\s*\.\s*(\w+)').allMatches(code)) {
    final method = match[1]!;
    if (_nonFontMembers.contains(method)) continue;

    final line = '\n'.allMatches(code.substring(0, match.start)).length + 1;
    final location = '$path:$line';
    void report(String reason) =>
        problems.add('$location GoogleFonts.$method: $reason');

    final open = RegExp(r'\s*\(').matchAsPrefix(code, match.end);
    if (open == null) {
      report('not a direct call, so its weight and style are unknown');
      continue;
    }

    final arguments = _namedArguments(source, code, open.end);
    if (arguments == null) {
      report('could not find the closing parenthesis');
      continue;
    }

    if (arguments.containsKey('textStyle') &&
        !(arguments.containsKey('fontWeight') &&
            arguments.containsKey('fontStyle'))) {
      report(
        'textStyle is passed without an explicit fontWeight and fontStyle',
      );
      continue;
    }

    Set<T>? resolve<T>(String name, Map<String, T> literals, T fallback) {
      final argument = arguments[name];
      if (argument == null) return {fallback};
      final values = _literalValues(argument.code, literals);
      if (values == null) {
        report(
          'cannot resolve $name "${argument.source}"; use a literal, or a '
          'conditional whose branches are literals',
        );
      }
      return values;
    }

    final weights = resolve('fontWeight', _weights, FontWeight.w400);
    final styles = resolve('fontStyle', _styles, FontStyle.normal);
    if (weights == null || styles == null) continue;

    // Conditions are not correlated, so every combination is required.
    for (final weight in weights) {
      for (final style in styles) {
        requests.add(
          (location: location, method: method, weight: weight, style: style),
        );
      }
    }
  }

  return (requests: requests, problems: problems);
}

/// Splits the argument list starting at [start] (just after the opening
/// parenthesis) and returns the named arguments, or null if it never closes.
Map<String, ({String code, String source})>? _namedArguments(
  String source,
  String code,
  int start,
) {
  final arguments = <String, ({String code, String source})>{};
  var depth = 0;
  var segmentStart = start;

  void addSegment(int end) {
    final name = RegExp(
      r'\s*(\w+)\s*:',
    ).matchAsPrefix(code.substring(0, end), segmentStart);
    if (name == null) return;
    arguments[name[1]!] = (
      code: code.substring(name.end, end),
      source: source.substring(name.end, end).trim(),
    );
  }

  for (var i = start; i < code.length; i++) {
    final char = code[i];
    if ('([{'.contains(char)) {
      depth++;
    } else if (')]}'.contains(char)) {
      if (depth == 0) {
        addSegment(i);
        return arguments;
      }
      depth--;
    } else if (char == ',' && depth == 0) {
      addSegment(i);
      segmentStart = i + 1;
    }
  }
  return null;
}

/// Every value [expression] can evaluate to, or null if any branch is not one
/// of [literals].
Set<T>? _literalValues<T>(String expression, Map<String, T> literals) {
  final literal = literals[expression.replaceAll(RegExp(r'\s'), '')];
  if (literal != null) return {literal};

  var depth = 0;
  var nested = 0;
  int? question;
  for (var i = 0; i < expression.length; i++) {
    final char = expression[i];
    if ('([{'.contains(char)) {
      depth++;
    } else if (')]}'.contains(char)) {
      depth--;
    } else if (depth != 0) {
      continue;
    } else if (char == '?') {
      final next = i + 1 < expression.length ? expression[i + 1] : '';
      if (next == '?') {
        i++; // `??`
      } else if (next != '.') {
        if (question == null) {
          question = i;
        } else {
          nested++;
        }
      }
    } else if (char == ':' && question != null) {
      if (nested > 0) {
        nested--;
        continue;
      }
      final whenTrue = _literalValues(
        expression.substring(question + 1, i),
        literals,
      );
      final whenFalse = _literalValues(expression.substring(i + 1), literals);
      if (whenTrue == null || whenFalse == null) return null;
      return {...whenTrue, ...whenFalse};
    }
  }
  return null;
}

/// Replaces comments and string contents with spaces, keeping newlines and the
/// code inside string interpolations.
String maskCommentsAndStrings(String source) {
  final out = source.split('');
  var i = 0;

  void mask(int count) {
    for (final end = i + count; i < end && i < out.length; i++) {
      if (out[i] != '\n') out[i] = ' ';
    }
  }

  late final void Function({required bool interpolation}) readCode;

  void readString({required bool raw}) {
    final quote = source[i];
    final delimiter = source.startsWith(quote * 3, i) ? quote * 3 : quote;
    mask(delimiter.length);
    while (i < source.length) {
      if (source.startsWith(delimiter, i)) {
        mask(delimiter.length);
        return;
      }
      if (!raw && source[i] == r'\') {
        mask(2);
      } else if (!raw && source.startsWith(r'${', i)) {
        mask(1);
        i++; // keep the `{`
        readCode(interpolation: true);
      } else {
        mask(1);
      }
    }
  }

  readCode = ({required bool interpolation}) {
    var braces = 0;
    while (i < source.length) {
      final char = source[i];
      if (source.startsWith('//', i)) {
        final end = source.indexOf('\n', i);
        mask((end == -1 ? source.length : end) - i);
      } else if (source.startsWith('/*', i)) {
        var depth = 0;
        do {
          if (source.startsWith('/*', i)) {
            depth++;
            mask(2);
          } else if (source.startsWith('*/', i)) {
            depth--;
            mask(2);
          } else {
            mask(1);
          }
        } while (depth > 0 && i < source.length);
      } else if (char == "'" || char == '"') {
        final raw =
            i > 0 &&
            source[i - 1] == 'r' &&
            (i < 2 || !RegExp(r'\w').hasMatch(source[i - 2]));
        readString(raw: raw);
      } else {
        if (char == '{') braces++;
        if (char == '}') {
          if (interpolation && braces == 0) {
            i++;
            return;
          }
          braces--;
        }
        i++;
      }
    }
  };

  readCode(interpolation: false);
  return out.join();
}
