import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/features/hadi/domain/entities/hadi_summary_entity.dart';
import 'package:ishari/features/hadi/presentation/bloc/hadi_directory_bloc.dart';
import 'package:ishari/features/hadi/presentation/bloc/hadi_directory_event.dart';
import 'package:ishari/features/hadi/presentation/bloc/hadi_directory_state.dart';
import 'package:ishari/features/hadi/presentation/widgets/hadi_avatar.dart';
import 'package:ishari/features/hadi/presentation/widgets/hadi_masonry_grid.dart';
import 'package:ishari/injection_container.dart';
import 'package:ishari/shared/widgets/native_ad_card.dart';
import 'package:ishari/shared/widgets/search_bar_field.dart';

const _kBg = Color(0xFFF0F5EE);
const _kDark = Color(0xFF111111);
const _kMute = Color(0xFF777777);
const _kBorder = Color(0xFFE2E8DF);

class HadiDirectoryPage extends StatelessWidget {
  const HadiDirectoryPage({super.key});

  static const routePath = '/hadi';

  @override
  Widget build(BuildContext context) {
    final bloc = sl<HadiDirectoryBloc>()
      ..add(const HadiDirectoryEvent.loadAll());
    return BlocProvider.value(
      value: bloc,
      child: const _HadiDirectoryBody(),
    );
  }
}

class _HadiDirectoryBody extends StatefulWidget {
  const _HadiDirectoryBody();

  @override
  State<_HadiDirectoryBody> createState() => _HadiDirectoryBodyState();
}

class _HadiDirectoryBodyState extends State<_HadiDirectoryBody> {
  final _searchController = TextEditingController();
  // View mode is page-local UI state on purpose (spec: resets to list on
  // every visit) — it must not live in the shared singleton bloc.
  bool _isGrid = false;

  @override
  void dispose() {
    // Search text is page-local UI state, but the filter lives in the
    // shared HadiDirectoryBloc (singleton, kept alive across visits so
    // Directory/Detail don't refetch). Reset it here so a stale query
    // doesn't silently keep filtering the list on the next visit while
    // this page's own (fresh) TextEditingController shows empty.
    sl<HadiDirectoryBloc>().add(const HadiDirectoryEvent.searchChanged(''));
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<HadiDirectoryBloc, HadiDirectoryState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: _Header()),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                    child: SearchBarField(
                      controller: _searchController,
                      hint: 'Cari nama Hadi…',
                      onChanged: (v) => context.read<HadiDirectoryBloc>().add(
                        HadiDirectoryEvent.searchChanged(v),
                      ),
                      onClear: () {
                        _searchController.clear();
                        context.read<HadiDirectoryBloc>().add(
                          const HadiDirectoryEvent.searchChanged(''),
                        );
                      },
                    ),
                  ),
                ),
                if (state.status == HadiDirectoryStatus.loading)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: _kDark),
                    ),
                  )
                else if (state.status == HadiDirectoryStatus.error)
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        state.errorMessage ?? 'Gagal memuat data.',
                        style: GoogleFonts.poppins(color: _kMute),
                      ),
                    ),
                  )
                else ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Semua Hadi',
                            style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              letterSpacing: -0.3,
                              color: _kDark,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                state.hadiCountLabel,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: _kMute,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 10),
                              _ViewToggleButton(
                                isGrid: _isGrid,
                                onTap: () =>
                                    setState(() => _isGrid = !_isGrid),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_isGrid)
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      sliver: SliverToBoxAdapter(
                        child: HadiMasonryGrid(
                          hadiList: state.filteredHadiList,
                          audioCountFor: state.audioCountFor,
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      sliver: _HadiSliverList(
                        hadiList: state.filteredHadiList,
                        audioCountFor: state.audioCountFor,
                      ),
                    ),
                ],
              ],
            );
          },
        ),
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
                Icons.arrow_back_rounded,
                size: 20,
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
                  'Fitur Hadi',
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

class _ViewToggleButton extends StatelessWidget {
  const _ViewToggleButton({required this.isGrid, required this.onTap});

  final bool isGrid;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: _kBorder, width: 1.5),
        ),
        alignment: Alignment.center,
        child: Icon(
          isGrid ? Icons.view_list_rounded : Icons.grid_view_rounded,
          size: 18,
          color: _kDark,
        ),
      ),
    );
  }
}

/// List mode with a native ad slot after the 4th hadi (skipped entirely when
/// fewer than 5 hadi remain after filtering) — same interval rule as
/// HadiMasonryGrid and the tatanan list.
class _HadiSliverList extends StatelessWidget {
  const _HadiSliverList({
    required this.hadiList,
    required this.audioCountFor,
  });

  final List<HadiSummaryEntity> hadiList;
  final int Function(String hadiId) audioCountFor;

  @override
  Widget build(BuildContext context) {
    final withAd = hadiList.length >= 5;
    final itemCount = hadiList.length + (withAd ? 1 : 0);
    return SliverList.separated(
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        if (withAd && i == 4) return const NativeAdCard();
        final dataIndex = withAd && i > 4 ? i - 1 : i;
        final hadi = hadiList[dataIndex];
        return _HadiCard(
          hadi: hadi,
          index: dataIndex,
          audioCount: audioCountFor(hadi.id),
        );
      },
    );
  }
}

class _HadiCard extends StatelessWidget {
  const _HadiCard({
    required this.hadi,
    required this.index,
    required this.audioCount,
  });

  final HadiSummaryEntity hadi;
  final int index;
  final int audioCount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/hadi/${hadi.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _kBorder, width: 1.5),
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            HadiAvatar(name: hadi.name, index: index),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hadi.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14.5,
                      letterSpacing: -0.2,
                      color: _kDark,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$audioCount audio tersedia',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: _kMute,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: Color(0xFFAAAAAA),
            ),
          ],
        ),
      ),
    );
  }
}
