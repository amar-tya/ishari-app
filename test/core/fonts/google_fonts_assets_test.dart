// Regression guard for issue #12.
//
// Runtime font fetching is disabled, so every family/weight/style that lib/
// asks google_fonts for must be bundled in assets/fonts/. A missing file is
// not a soft fallback: the package rethrows from an un-awaited future.
import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
// The public API cannot drop a failed load from the pending set, nor turn a
// resolved variant back into its asset file name.
// ignore: implementation_imports
import 'package:google_fonts/src/google_fonts_base.dart'
    show pendingFontFutures;
// ignore: implementation_imports
import 'package:google_fonts/src/google_fonts_variant.dart';

import 'google_fonts_call_scanner.dart';

/// Loads one variant through the real package. Returns null on success,
/// otherwise a line naming the family, weight, style and expected asset file.
Future<String?> _loadVariant(FontRequest request) async {
  Object? error;
  String? resolvedFamily;
  final done = Completer<void>();

  // The package also reports a failed load as an unhandled async error, so
  // each load gets its own zone to keep the failure attributable.
  unawaited(
    runZonedGuarded(() async {
      try {
        resolvedFamily = GoogleFonts.getFont(
          request.family,
          fontWeight: request.weight,
          fontStyle: request.style,
        ).fontFamily;
        await GoogleFonts.pendingFonts();
      } on Object catch (e) {
        error ??= e;
      } finally {
        done.complete();
      }
    }, (e, _) => error ??= e),
  );
  await done.future;
  pendingFontFutures.clear();

  if (error == null) return null;

  final label =
      '${request.family} weight ${request.weight.value} '
      '${request.style.name}';
  if (resolvedFamily == null) return '$label: $error';

  // fontFamily looks like "Poppins_500" or "DMSans_regular".
  final separator = resolvedFamily!.lastIndexOf('_');
  final prefix = resolvedFamily!.substring(0, separator);
  final variant = GoogleFontsVariant.fromString(
    resolvedFamily!.substring(separator + 1),
  );
  return '$label: needs assets/fonts/'
      '$prefix-${variant.toApiFilenamePart()}.ttf. Loader said: $error';
}

List<File> _dartSources() => Directory('lib')
    .listSync(recursive: true)
    .whereType<File>()
    .where(
      (f) =>
          f.path.endsWith('.dart') &&
          !f.path.endsWith('.g.dart') &&
          !f.path.endsWith('.freezed.dart'),
    )
    .toList();

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('scanGoogleFontsCalls', () {
    ScanResult scan(String source) => scanGoogleFontsCalls(source, 'a.dart');

    Set<String> describe(ScanResult result) => {
      for (final r in result.requests)
        '${r.method} ${r.weight.value} ${r.style.name}',
    };

    test('defaults to weight 400 normal', () {
      final result = scan('final a = GoogleFonts.poppins(fontSize: 12);');

      expect(describe(result), {'poppins 400 normal'});
      expect(result.problems, isEmpty);
    });

    test('takes both branches of conditional weight and style', () {
      final result = scan('''
final a = GoogleFonts.poppins(
  fontWeight: item?.id == (other ?? 'x') ? FontWeight.bold : FontWeight.w500,
  fontStyle: quoted ? FontStyle.italic : FontStyle.normal,
);
''');

      expect(describe(result), {
        'poppins 700 italic',
        'poppins 700 normal',
        'poppins 500 italic',
        'poppins 500 normal',
      });
      expect(result.problems, isEmpty);
    });

    test('ignores calls in comments and strings', () {
      final result = scan('''
// GoogleFonts.lato()
/* GoogleFonts.lato( */
final a = 'GoogleFonts.lato()';
final b = GoogleFonts.dmSans(
  color: pick('a), b', "\${map['(']}"), // fontWeight: w,
  fontWeight: FontWeight.w800,
);
''');

      expect(describe(result), {'dmSans 800 normal'});
      expect(result.problems, isEmpty);
    });

    test('ignores GoogleFonts.config', () {
      final result = scan('GoogleFonts.config.allowRuntimeFetching = false;');

      expect(result.requests, isEmpty);
      expect(result.problems, isEmpty);
    });

    test('reports a weight it cannot resolve, with file and line', () {
      final result = scan('''

final a = GoogleFonts.poppins(
  fontWeight: wide ? FontWeight.w700 : widget.weight,
);
''');

      expect(result.requests, isEmpty);
      expect(
        result.problems.single,
        startsWith('a.dart:2 GoogleFonts.poppins'),
      );
      expect(result.problems.single, contains('widget.weight'));
    });

    test('reports a textStyle that may carry the weight or style', () {
      final result = scan('GoogleFonts.poppins(textStyle: base);');

      expect(result.requests, isEmpty);
      expect(result.problems.single, contains('textStyle'));
    });

    test('reports a reference that is not a direct call', () {
      final result = scan('final style = GoogleFonts.poppins;');

      expect(result.problems.single, contains('not a direct call'));
    });
  });

  group('bundled google_fonts assets', () {
    test('cover every variant requested in lib/', () async {
      GoogleFonts.config.allowRuntimeFetching = false;

      final familyByMethod = {
        for (final family in GoogleFonts.asMap().keys)
          family.replaceAll(' ', '').toLowerCase(): family,
      };

      final problems = <String>[];
      final callSites = <FontRequest, List<String>>{};
      for (final file in _dartSources()) {
        final result = scanGoogleFontsCalls(
          file.readAsStringSync(),
          file.path.replaceAll(r'\', '/'),
        );
        problems.addAll(result.problems);
        for (final call in result.requests) {
          final family = familyByMethod[call.method.toLowerCase()];
          if (family == null) {
            problems.add(
              '${call.location} GoogleFonts.${call.method}: '
              'cannot map this method to a font family',
            );
            continue;
          }
          callSites
              .putIfAbsent(
                (family: family, weight: call.weight, style: call.style),
                () => [],
              )
              .add(call.location);
        }
      }

      expect(
        callSites,
        isNotEmpty,
        reason: 'the scanner found no GoogleFonts calls in lib/',
      );

      for (final MapEntry(key: request, value: sites) in callSites.entries) {
        final failure = await _loadVariant(request);
        if (failure != null) {
          problems.add('$failure\n    requested at ${sites.join(', ')}');
        }
      }

      if (problems.isNotEmpty) {
        fail(
          'google_fonts problems (fonts must be bundled, see issue #12):\n'
          '- ${problems.join('\n- ')}',
        );
      }
    });

    test('are the only source: runtime fetching stays disabled', () {
      final assignment = RegExp(
        r'GoogleFonts\s*\.\s*config\s*\.\s*allowRuntimeFetching\s*=\s*(\w+)',
      );
      final values = {
        for (final file in _dartSources())
          for (final match in assignment.allMatches(
            maskCommentsAndStrings(file.readAsStringSync()),
          ))
            match[1],
      };

      expect(
        values,
        {'false'},
        reason:
            'lib/ must set GoogleFonts.config.allowRuntimeFetching = false '
            'and never set it to anything else',
      );
    });
  });
}
