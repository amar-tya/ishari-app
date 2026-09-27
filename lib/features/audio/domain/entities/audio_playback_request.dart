import 'package:meta/meta.dart';

/// What to play + the metadata shown on the OS media notification/lockscreen
/// once `AudioPlaybackService.load` starts it.
@immutable
class AudioPlaybackRequest {
  const AudioPlaybackRequest({
    required this.id,
    required this.url,
    required this.title,
    required this.subtitle,
  });

  /// Stable id for the track — surfaced to the OS media session.
  final String id;
  final String url;
  final String title;
  final String subtitle;
}
