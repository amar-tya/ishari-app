import 'dart:io';

/// A command that produces an Android release artifact.
final releaseBuildCommand = RegExp(
  r'^\s*(shorebird (release|patch) android|flutter build (apk|appbundle))\b',
  multiLine: true,
);

/// GitHub workflow files that build an Android release, keyed by file name.
/// Comment lines are removed so they cannot satisfy or break a check.
Map<String, String> releaseWorkflows() {
  final workflows = <String, String>{};
  for (final file in Directory('.github/workflows').listSync()) {
    if (file is! File || !file.path.endsWith('.yml')) continue;
    final content = file
        .readAsLinesSync()
        .where((line) => !line.trimLeft().startsWith('#'))
        .join('\n');
    if (releaseBuildCommand.hasMatch(content)) {
      workflows[file.uri.pathSegments.last] = content;
    }
  }
  return workflows;
}
