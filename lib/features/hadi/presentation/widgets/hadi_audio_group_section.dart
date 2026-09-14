import 'package:flutter/material.dart';
import 'package:ishari/features/hadi/domain/entities/hadi_audio_entity.dart';
import 'package:ishari/features/muhud/domain/entities/verse_media_type.dart';

const _kDark = Color(0xFF111111);
const _kMute = Color(0xFF777777);
const _kBorder = Color(0xFFE2E8DF);
const _kLime = Color(0xFFCAFF00);

String _formatDuration(int? seconds) {
  if (seconds == null) return '';
  final m = seconds ~/ 60;
  final s = seconds % 60;
  return '$m:${s.toString().padLeft(2, '0')}';
}

/// One "Gaya Bacaan" section — group label + its track rows. Track row
/// styling (border/icon-swap on the playing row) follows the Claude Design
/// mock; the grouping itself is a functional requirement layered on top.
class HadiAudioGroupSection extends StatelessWidget {
  const HadiAudioGroupSection({
    required this.type,
    required this.tracks,
    required this.playingId,
    required this.isLoading,
    required this.onTrackTap,
    super.key,
  });

  final VerseMediaType type;
  final List<HadiAudioEntity> tracks;
  final int? playingId;
  final bool isLoading;
  final ValueChanged<HadiAudioEntity> onTrackTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type.label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: _kMute,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < tracks.length; i++) ...[
            if (i > 0) const SizedBox(height: 10),
            _TrackRow(
              track: tracks[i],
              isPlaying: playingId == tracks[i].id,
              isLoading: isLoading && playingId == tracks[i].id,
              onTap: () => onTrackTap(tracks[i]),
            ),
          ],
        ],
      ),
    );
  }
}

class _TrackRow extends StatelessWidget {
  const _TrackRow({
    required this.track,
    required this.isPlaying,
    required this.isLoading,
    required this.onTap,
  });

  final HadiAudioEntity track;
  final bool isPlaying;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final subtitleParts = <String>[
      'Bait ${track.verseNumber}',
      if (track.duration != null) _formatDuration(track.duration),
    ];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPlaying ? _kLime : _kBorder,
            width: isPlaying ? 2 : 1.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isPlaying ? _kLime : _kDark,
              ),
              alignment: Alignment.center,
              child: isLoading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: isPlaying ? _kDark : _kLime,
                      ),
                    )
                  : Icon(
                      isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      size: 19,
                      color: isPlaying ? _kDark : _kLime,
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.chapterTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                      color: _kDark,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitleParts.join(' · '),
                    style: const TextStyle(
                      fontSize: 11,
                      color: _kMute,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
