import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/features/hadi/domain/entities/hadi_audio_entity.dart';
import 'package:ishari/features/hadi/presentation/bloc/hadi_directory_bloc.dart';
import 'package:ishari/features/hadi/presentation/bloc/hadi_directory_event.dart';
import 'package:ishari/features/hadi/presentation/bloc/hadi_directory_state.dart';
import 'package:ishari/features/muhud/domain/entities/verse_media_type.dart';

const _kDark = Color(0xFF111111);
const _kMute = Color(0xFF777777);
const _kBorder = Color(0xFFE2E8DF);
const _kLime = Color(0xFFCAFF00);

/// Bottom sheet shown when a track row is tapped — verse (ayat) info plus
/// the play/pause control and live status indicator, backed by the same
/// [HadiDirectoryBloc] instance as the page it was opened from.
class HadiTrackSheet extends StatelessWidget {
  const HadiTrackSheet({required this.track, super.key});

  final HadiAudioEntity track;

  static Future<void> show(BuildContext context, HadiAudioEntity track) {
    final bloc = context.read<HadiDirectoryBloc>();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: HadiTrackSheet(track: track),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HadiDirectoryBloc, HadiDirectoryState>(
      builder: (context, state) {
        final isPlaying = state.playingAudioId == track.id;
        final isLoading = isPlaying && state.isAudioLoading;

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 28,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 20),
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _kBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'AYAT ${track.verseNumber} · ${track.chapterTitle}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: _kMute,
                            letterSpacing: 0.6,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F5EE),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          child: Text(
                            track.type.label,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: _kDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      track.arabicText,
                      style: GoogleFonts.scheherazadeNew(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: _kDark,
                        height: 2,
                      ),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.read<HadiDirectoryBloc>().add(
                        HadiDirectoryEvent.playTrack(track.id),
                      ),
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: _kDark,
                        ),
                        alignment: Alignment.center,
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: _kLime,
                                ),
                              )
                            : Icon(
                                isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                size: 26,
                                color: _kLime,
                              ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      isLoading
                          ? 'Memuat audio…'
                          : isPlaying
                          ? 'Sedang diputar'
                          : 'Tap untuk memutar',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isPlaying ? _kDark : _kMute,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
