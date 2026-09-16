import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/features/hadi/domain/entities/hadi_summary_entity.dart';
import 'package:ishari/features/hadi/presentation/bloc/hadi_directory_bloc.dart';
import 'package:ishari/features/hadi/presentation/bloc/hadi_directory_event.dart';
import 'package:ishari/features/hadi/presentation/bloc/hadi_directory_state.dart';
import 'package:ishari/features/hadi/presentation/widgets/hadi_audio_group_section.dart';
import 'package:ishari/features/hadi/presentation/widgets/hadi_avatar.dart';
import 'package:ishari/features/hadi/presentation/widgets/hadi_mini_player.dart';
import 'package:ishari/features/hadi/presentation/widgets/hadi_track_sheet.dart';
import 'package:ishari/injection_container.dart';
import 'package:ishari/shared/widgets/banner_ad_widget.dart';

const _kBg = Color(0xFFF0F5EE);
const _kDark = Color(0xFF111111);
const _kMute = Color(0xFF777777);
const _kBorder = Color(0xFFE2E8DF);

class HadiDetailPage extends StatelessWidget {
  const HadiDetailPage({required this.hadiId, super.key});

  static const routePath = '/hadi/:hadiId';

  final String hadiId;

  @override
  Widget build(BuildContext context) {
    final bloc = sl<HadiDirectoryBloc>()
      ..add(const HadiDirectoryEvent.loadAll());
    return BlocProvider.value(
      value: bloc,
      child: _HadiDetailBody(hadiId: hadiId),
    );
  }
}

class _HadiDetailBody extends StatelessWidget {
  const _HadiDetailBody({required this.hadiId});

  final String hadiId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        bottom: false,
        // Header is a fixed sibling above the scroll view, not a sliver, so
        // the back button/title stay pinned (and visible) through loading,
        // error, and loaded states alike.
        child: BlocBuilder<HadiDirectoryBloc, HadiDirectoryState>(
          builder: (context, state) {
            final hadi = state.hadiById(hadiId);
            return Column(
              children: [
                _Header(name: hadi?.name ?? 'Hadi'),
                Expanded(
                  child: _HadiDetailContent(
                    hadiId: hadiId,
                    state: state,
                    hadi: hadi,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HadiDetailContent extends StatelessWidget {
  const _HadiDetailContent({
    required this.hadiId,
    required this.state,
    required this.hadi,
  });

  final String hadiId;
  final HadiDirectoryState state;
  final HadiSummaryEntity? hadi;

  @override
  Widget build(BuildContext context) {
    if (state.status == HadiDirectoryStatus.loading ||
        state.status == HadiDirectoryStatus.initial) {
      return const Center(child: CircularProgressIndicator(color: _kDark));
    }
    final hadi = this.hadi;
    if (state.status == HadiDirectoryStatus.error || hadi == null) {
      return Center(
        child: Text(
          state.errorMessage ?? 'Hadi tidak ditemukan.',
          style: GoogleFonts.poppins(color: _kMute),
        ),
      );
    }

    final grouped = state.groupedAudioForHadi(hadiId);
    final trackCount = state.audioCountFor(hadiId);
    final playingTrack = state.playingTrack;
    final showMiniPlayer =
        playingTrack != null && playingTrack.hadiId == hadiId;

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 8),
                child: BannerAdWidget(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 18),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: _kBorder, width: 1.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      HadiAvatar(
                        name: hadi.name,
                        index: 0,
                        size: 60,
                        photoUrl: hadi.photoUrl,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          hadi.description?.isNotEmpty == true
                              ? hadi.description!
                              : 'Belum ada deskripsi.',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF555555),
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 2, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      'Daftar Audio',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        letterSpacing: -0.3,
                        color: _kDark,
                      ),
                    ),
                    Text(
                      '$trackCount rekaman',
                      style: const TextStyle(
                        fontSize: 11,
                        color: _kMute,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (grouped.isEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: Text(
                      'Belum ada audio untuk hadi ini.',
                      style: GoogleFonts.poppins(color: _kMute),
                    ),
                  ),
                ),
              )
            else
              SliverList.list(
                children: [
                  for (final entry in grouped.entries)
                    HadiAudioGroupSection(
                      type: entry.key,
                      tracks: entry.value,
                      playingId: state.playingAudioId,
                      isLoading: state.isAudioLoading,
                      onTrackTap: (track) =>
                          HadiTrackSheet.show(context, track),
                    ),
                ],
              ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: showMiniPlayer ? 100 : 20,
              ),
            ),
          ],
        ),
        if (showMiniPlayer)
          Positioned(
            left: 16,
            right: 16,
            bottom: 16 + MediaQuery.of(context).padding.bottom,
            child: HadiMiniPlayer(
              title: playingTrack.chapterTitle,
              subtitle: hadi.name,
              isPlaying: !state.isAudioLoading,
              onToggle: () => context.read<HadiDirectoryBloc>().add(
                HadiDirectoryEvent.playTrack(playingTrack.id),
              ),
            ),
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: _kBorder, width: 1.5),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: Color(0xFF555555),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'HADI',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: _kMute,
                    letterSpacing: 0.4,
                  ),
                ),
                Text(
                  name,
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 19,
                    letterSpacing: -0.3,
                    color: _kDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
