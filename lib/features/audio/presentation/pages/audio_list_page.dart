import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/features/audio/domain/entities/audio_track_entity.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_list_bloc.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_list_event.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_list_state.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_sort.dart';
import 'package:ishari/features/audio/presentation/utils/format_duration.dart';
import 'package:ishari/features/audio/presentation/widgets/audio_filter_sheet.dart';
import 'package:ishari/injection_container.dart';
import 'package:ishari/shared/widgets/native_ad_card.dart';

const _kBg = Color(0xFFF0F5EE);
const _kDark = Color(0xFF111111);
const _kMute = Color(0xFF777777);
const _kBorder = Color(0xFFE2E8DF);
const _kLime = Color(0xFFCAFF00);

class AudioListPage extends StatelessWidget {
  const AudioListPage({super.key});

  static const routePath = '/audio';

  @override
  Widget build(BuildContext context) {
    final bloc = sl<AudioListBloc>()..add(const AudioListEvent.loadAll());
    return BlocProvider.value(value: bloc, child: const _AudioListBody());
  }
}

class _AudioListBody extends StatefulWidget {
  const _AudioListBody();

  @override
  State<_AudioListBody> createState() => _AudioListBodyState();
}

class _AudioListBodyState extends State<_AudioListBody> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    // Search text is page-local UI state, but the filter query lives in the
    // shared AudioListBloc (singleton, kept alive across visits). Reset it
    // here so a stale query doesn't silently keep filtering the list on the
    // next visit while this page's own (fresh) controller shows empty.
    sl<AudioListBloc>().add(const AudioListEvent.searchChanged(''));
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<AudioListBloc, AudioListState>(
          builder: (context, state) {
            return Column(
              children: [
                const _Header(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                  child: _SearchFilterBar(
                    controller: _searchController,
                    totalApplied: state.totalAppliedFilterCount,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
                  child: _SortRow(
                    resultCount: state.filteredSortedTracks.length,
                    sort: state.sort,
                  ),
                ),
                Expanded(child: _buildBody(context, state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AudioListState state) {
    if (state.status == AudioListStatus.loading ||
        state.status == AudioListStatus.initial) {
      return const Center(child: CircularProgressIndicator(color: _kDark));
    }
    if (state.status == AudioListStatus.error) {
      return Center(
        child: Text(
          state.errorMessage ?? 'Gagal memuat data.',
          style: GoogleFonts.poppins(color: _kMute),
        ),
      );
    }

    final tracks = state.filteredSortedTracks;
    final bloc = context.read<AudioListBloc>();
    return RefreshIndicator(
      color: _kDark,
      onRefresh: () async {
        final startTick = bloc.state.refreshTick;
        bloc.add(const AudioListEvent.loadAll(forceRefresh: true));
        await bloc.stream.firstWhere((s) => s.refreshTick != startTick);
      },
      child: tracks.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 120),
                Center(
                  child: Text(
                    'Tidak ada audio yang cocok.',
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: _kMute,
                    ),
                  ),
                ),
              ],
            )
          : _TrackList(
              tracks: tracks,
              playingId: state.playingId,
              isAudioLoading: state.isAudioLoading,
              isPlaying: state.isPlaying,
              showBottomSpacer: state.playingTrack != null,
            ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

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
                  'KOLEKSI',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: _kMute,
                    letterSpacing: 0.4,
                  ),
                ),
                Text(
                  'Audio',
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 19,
                    letterSpacing: -0.3,
                    color: _kDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchFilterBar extends StatelessWidget {
  const _SearchFilterBar({
    required this.controller,
    required this.totalApplied,
  });

  final TextEditingController controller;
  final int totalApplied;

  @override
  Widget build(BuildContext context) {
    final hasFilter = totalApplied > 0;
    final filterBg = hasFilter ? _kDark : _kBg;
    final filterFg = hasFilter ? _kLime : const Color(0xFF555555);
    final filterLabel = hasFilter ? '$totalApplied Filter' : 'Filter';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _kBorder, width: 1.5),
        borderRadius: BorderRadius.circular(100),
      ),
      padding: const EdgeInsets.fromLTRB(16, 6, 6, 6),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, size: 18, color: Color(0xFF555555)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: (v) => context.read<AudioListBloc>().add(
                AudioListEvent.searchChanged(v),
              ),
              style: GoogleFonts.poppins(fontSize: 13.5, color: _kDark),
              decoration: InputDecoration(
                hintText: 'Cari judul atau nama Hadi…',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 13.5,
                  color: const Color(0xFFAAAAAA),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Container(width: 1.5, height: 22, color: _kBorder),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => AudioFilterSheet.show(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: filterBg,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.tune_rounded, size: 16, color: filterFg),
                  const SizedBox(width: 5),
                  Text(
                    filterLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: filterFg,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(Icons.expand_more_rounded, size: 16, color: filterFg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SortRow extends StatelessWidget {
  const _SortRow({required this.resultCount, required this.sort});

  final int resultCount;
  final AudioSort sort;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$resultCount audio',
          style: const TextStyle(
            fontSize: 11,
            color: _kMute,
            fontWeight: FontWeight.w600,
          ),
        ),
        PopupMenuButton<AudioSort>(
          initialValue: sort,
          onSelected: (s) => context.read<AudioListBloc>().add(
            AudioListEvent.sortChanged(s),
          ),
          offset: const Offset(0, 40),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: _kBorder, width: 1.5),
          ),
          itemBuilder: (context) => [
            for (final s in AudioSort.values)
              PopupMenuItem<AudioSort>(
                value: s,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      s.label,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: _kDark,
                      ),
                    ),
                    if (s == sort)
                      const Icon(Icons.check_rounded, size: 16, color: _kDark),
                  ],
                ),
              ),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: _kBorder, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.swap_vert_rounded,
                  size: 16,
                  color: Color(0xFF555555),
                ),
                const SizedBox(width: 6),
                Text(
                  sort.label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _kDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Track rows with a native ad slot after the 4th item (skipped entirely
/// when fewer than 5 tracks remain after filtering) — same interval rule as
/// `HadiDirectoryPage`. Recomputed against [tracks], which is already the
/// filtered/searched/sorted list, so the ad position stays correct as those
/// change.
class _TrackList extends StatelessWidget {
  const _TrackList({
    required this.tracks,
    required this.playingId,
    required this.isAudioLoading,
    required this.isPlaying,
    required this.showBottomSpacer,
  });

  final List<AudioTrackEntity> tracks;
  final String? playingId;
  final bool isAudioLoading;
  final bool isPlaying;
  final bool showBottomSpacer;

  @override
  Widget build(BuildContext context) {
    final withAd = tracks.length >= 5;
    final rowCount = tracks.length + (withAd ? 1 : 0);
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(20, 0, 20, showBottomSpacer ? 100 : 20),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: rowCount,
      itemBuilder: (context, i) {
        if (withAd && i == 4) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: NativeAdCard(),
          );
        }
        final dataIndex = withAd && i > 4 ? i - 1 : i;
        return _TrackRow(
          track: tracks[dataIndex],
          playingId: playingId,
          isAudioLoading: isAudioLoading,
          isPlaying: isPlaying,
        );
      },
    );
  }
}

class _TrackRow extends StatelessWidget {
  const _TrackRow({
    required this.track,
    required this.playingId,
    required this.isAudioLoading,
    required this.isPlaying,
  });

  final AudioTrackEntity track;
  final String? playingId;
  final bool isAudioLoading;
  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    final isThis = playingId == track.id;
    final isLoading = isThis && isAudioLoading;
    final isThisPlaying = isThis && isPlaying;
    final subtitle = track.facetSubtitle;
    final description = track.description;

    return GestureDetector(
      onTap: () => context.read<AudioListBloc>().add(
        AudioListEvent.playTrack(track.id),
      ),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: _kBorder, width: 1.5)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isThis ? _kLime : _kDark,
              ),
              alignment: Alignment.center,
              child: isLoading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: isThis ? _kDark : _kLime,
                      ),
                    )
                  : Icon(
                      isThisPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      size: 19,
                      color: isThis ? _kDark : _kLime,
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                      color: _kDark,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: _kDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (description != null && description.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: _kMute,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (track.duration != null)
              Padding(
                padding: const EdgeInsets.only(top: 9),
                child: Text(
                  formatDuration(Duration(seconds: track.duration!)),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFFAAAAAA),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
