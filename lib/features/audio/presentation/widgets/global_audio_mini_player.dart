import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/core/app_state.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_list_bloc.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_list_event.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_list_state.dart';
import 'package:ishari/features/audio/presentation/utils/format_duration.dart';

const _kLime = Color(0xFFCAFF00);
const _kDark = Color(0xFF111111);
const _kSeekStep = Duration(seconds: 10);

/// Mounted once above the router's Navigator (see `IshariApp`'s
/// `MaterialApp.router.builder`) so it floats over every route — the
/// `MainScaffold` tabs and every pushed detail page alike, including the
/// chapter reader — instead of living inside a single page like the old
/// per-page widget did. Reads `AudioListBloc` directly since it's a
/// `@lazySingleton` already alive for the app's lifetime.
class GlobalAudioMiniPlayerOverlay extends StatelessWidget {
  const GlobalAudioMiniPlayerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioListBloc, AudioListState>(
      builder: (context, state) {
        final track = state.playingTrack;
        if (track == null) return const SizedBox.shrink();

        return ValueListenableBuilder<bool>(
          valueListenable: AppState.isMainScaffoldVisible,
          builder: (context, showsPillNav, _) {
            final safeBottom = MediaQuery.of(context).padding.bottom;
            // MainScaffold's own pill nav bar reserves 16 margin + 60
            // height + 8 gap — clear it there, otherwise sit just above the
            // screen edge like the old per-page mini player did.
            final bottomOffset = safeBottom + (showsPillNav ? 84.0 : 16.0);
            return Positioned(
              left: 16,
              right: 16,
              bottom: bottomOffset,
              child: _MiniPlayerCard(
                title: track.title,
                subtitle: track.facetSubtitle,
                isPlaying: state.isPlaying,
                isLoading: state.isAudioLoading,
                position: state.position,
                duration: state.duration,
                onToggle: () => context.read<AudioListBloc>().add(
                  AudioListEvent.playTrack(track.id),
                ),
                onSeekBack: () => context.read<AudioListBloc>().add(
                  AudioListEvent.seekBy(-_kSeekStep),
                ),
                onSeekForward: () => context.read<AudioListBloc>().add(
                  const AudioListEvent.seekBy(_kSeekStep),
                ),
                onSeek: (target) => context.read<AudioListBloc>().add(
                  AudioListEvent.seekTo(target),
                ),
                onClose: () => context.read<AudioListBloc>().add(
                  const AudioListEvent.stopAudio(),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _MiniPlayerCard extends StatelessWidget {
  const _MiniPlayerCard({
    required this.title,
    required this.subtitle,
    required this.isPlaying,
    required this.isLoading,
    required this.position,
    required this.duration,
    required this.onToggle,
    required this.onSeekBack,
    required this.onSeekForward,
    required this.onSeek,
    required this.onClose,
  });

  final String title;
  final String subtitle;
  final bool isPlaying;
  final bool isLoading;
  final Duration position;
  final Duration? duration;
  final VoidCallback onToggle;
  final VoidCallback onSeekBack;
  final VoidCallback onSeekForward;
  final ValueChanged<Duration> onSeek;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    // This card is mounted above the router's Navigator (see
    // GlobalAudioMiniPlayerOverlay), outside any page's own Scaffold — so
    // there's no Material ancestor here to supply Text/Icon their default
    // style. Without one, Flutter falls back to a debug-only TextStyle that
    // renders every Text underlined as a "missing Material ancestor" hint.
    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(
          color: _kDark,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.32),
              blurRadius: 32,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _CircleIconButton(
                  icon: Icons.replay_10_rounded,
                  onTap: onSeekBack,
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onToggle,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: _kLime,
                    ),
                    alignment: Alignment.center,
                    child: isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: _kDark,
                            ),
                          )
                        : Icon(
                            isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            size: 20,
                            color: _kDark,
                          ),
                  ),
                ),
                const SizedBox(width: 8),
                _CircleIconButton(
                  icon: Icons.forward_10_rounded,
                  onTap: onSeekForward,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _CircleIconButton(icon: Icons.close_rounded, onTap: onClose),
              ],
            ),
            Row(
              children: [
                Text(
                  formatDuration(position),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: _SeekBar(
                    position: position,
                    duration: duration,
                    onSeek: onSeek,
                  ),
                ),
                Text(
                  formatDuration(duration ?? Duration.zero),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Tap or drag anywhere on the track to seek. Holds the dragged value
/// locally so the thumb doesn't fight the position stream mid-drag —
/// [onSeek] only fires once the user lets go.
class _SeekBar extends StatefulWidget {
  const _SeekBar({
    required this.position,
    required this.duration,
    required this.onSeek,
  });

  final Duration position;
  final Duration? duration;
  final ValueChanged<Duration> onSeek;

  @override
  State<_SeekBar> createState() => _SeekBarState();
}

const _kThumbSize = 12.0;
const _kTrackHeight = 4.0;
const _kSeekBarHeight = 24.0;

class _SeekBarState extends State<_SeekBar> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    final totalMs = widget.duration?.inMilliseconds ?? 0;
    final value =
        _dragValue ??
        (totalMs == 0
            ? 0.0
            : (widget.position.inMilliseconds / totalMs).clamp(0.0, 1.0));

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        void updateFromDx(double dx) {
          if (totalMs == 0) return;
          setState(() => _dragValue = (dx / width).clamp(0.0, 1.0));
        }

        void commit() {
          if (totalMs == 0 || _dragValue == null) return;
          widget.onSeek(
            Duration(milliseconds: (_dragValue! * totalMs).round()),
          );
          setState(() => _dragValue = null);
        }

        final filledWidth = width * value;
        final thumbLeft = (filledWidth - _kThumbSize / 2).clamp(
          0.0,
          width - _kThumbSize,
        );

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) => updateFromDx(details.localPosition.dx),
          onTapUp: (_) => commit(),
          onHorizontalDragUpdate: (details) =>
              updateFromDx(details.localPosition.dx),
          onHorizontalDragEnd: (_) => commit(),
          child: SizedBox(
            height: _kSeekBarHeight,
            width: width,
            child: Stack(
              children: [
                Positioned(
                  top: (_kSeekBarHeight - _kTrackHeight) / 2,
                  left: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      width: width,
                      height: _kTrackHeight,
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                ),
                Positioned(
                  top: (_kSeekBarHeight - _kTrackHeight) / 2,
                  left: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      width: filledWidth,
                      height: _kTrackHeight,
                      color: _kLime,
                    ),
                  ),
                ),
                Positioned(
                  top: (_kSeekBarHeight - _kThumbSize) / 2,
                  left: thumbLeft,
                  child: const _SeekThumb(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SeekThumb extends StatelessWidget {
  const _SeekThumb();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _kThumbSize,
      height: _kThumbSize,
      decoration: const BoxDecoration(shape: BoxShape.circle, color: _kLime),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.12),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 16, color: Colors.white),
      ),
    );
  }
}
