// Checks the font guard makes against the source tree. The test asset bundle
// cannot be trusted for this: flutter test reuses build/unit_test_assets, and
// deleting or renaming an asset does not make it rebuild.

/// Where bundled google_fonts files live, as written in pubspec.yaml.
const fontDirectory = 'assets/fonts/';

/// The entries of the `flutter: assets:` list in [pubspec].
///
/// Reads only the block-list form. Any other form yields no entries, so the
/// guard fails instead of passing unchecked.
Set<String> declaredAssets(String pubspec) {
  final entries = <String>{};
  var inFlutter = false;
  int? keyIndent;
  int? itemIndent;

  for (final raw in pubspec.split('\n')) {
    final line = raw.replaceFirst(RegExp(r'(^|\s)#.*$'), '').trimRight();
    final content = line.trimLeft();
    if (content.isEmpty) continue;
    final indent = line.length - content.length;

    if (indent == 0 && !content.startsWith('-')) {
      inFlutter = content == 'flutter:';
      keyIndent = null;
    } else if (!inFlutter) {
      continue;
    } else if (keyIndent == null) {
      if (content == 'assets:') {
        keyIndent = indent;
        itemIndent = null;
      }
    } else if (indent < keyIndent ||
        (indent == keyIndent && !content.startsWith('- '))) {
      // The next key under flutter: ends the list.
      inFlutter = false;
    } else if (content.startsWith('- ')) {
      // Deeper lists belong to an entry, such as its flavors.
      itemIndent ??= indent;
      if (indent != itemIndent) continue;
      entries.add(
        content
            .substring(2)
            .trim()
            .replaceFirst(RegExp(r'^path:\s*'), '')
            .replaceAll(RegExp('["\']'), ''),
      );
    }
  }
  return entries;
}

/// Why the font [name], such as `Poppins-Medium`, is not really bundled, or
/// null if it is. [files] are the file names in [fontDirectory] and [declared]
/// is the result of [declaredAssets].
///
/// Names are compared exactly because asset lookup is case-sensitive, unlike
/// the file system on Windows and macOS.
String? fontSourceProblem(
  String name, {
  required Set<String> files,
  required Set<String> declared,
}) {
  final candidates = ['$name.ttf', '$name.otf'].where(files.contains);
  if (candidates.isEmpty) {
    return '$fontDirectory$name.ttf is not in the source tree (nor .otf)';
  }
  if (declared.contains(fontDirectory) ||
      candidates.any((f) => declared.contains('$fontDirectory$f'))) {
    return null;
  }
  return '$fontDirectory${candidates.first} is not covered by the flutter '
      'assets list in pubspec.yaml';
}
