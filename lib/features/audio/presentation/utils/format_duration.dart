/// Formats [duration] as `m:ss` (e.g. `3:07`) — shared by the track list's
/// static duration label and the mini player's live position/duration.
String formatDuration(Duration? duration) {
  if (duration == null) return '';
  final totalSeconds = duration.inSeconds;
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}
