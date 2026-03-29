import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:ishari/features/bookmark/presentation/widgets/bookmark_card.dart';
import 'package:ishari/injection_container.dart';
import 'package:ishari/shared/widgets/filter_chips_row.dart';

const _kBg = Color(0xFFF0F5EE);
const _kDark = Color(0xFF111111);
const _kMuted = Color(0xFF777777);
const _kBorder = Color(0xFFE2E8DF);

const _kCategories = [
  'Semua',
  'Diwan',
  'Diba',
  'Muradah',
  'Muhud',
  'Rowi',
  'Syaraful Anam',
];

/// Bookmark tab — wraps BookmarkBloc and builds the full page.
class BookmarkTab extends StatelessWidget {
  const BookmarkTab({required this.isActive, super.key});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final userId = context.read<AuthBloc>().state.maybeWhen(
              authenticated: (user) => user.id,
              orElse: () => null,
            );
        final bloc = sl<BookmarkBloc>();
        if (userId != null) bloc.add(BookmarkEvent.load(userId: userId));
        return bloc;
      },
      child: _BookmarkTabBody(isActive: isActive),
    );
  }
}

class _BookmarkTabBody extends StatefulWidget {
  const _BookmarkTabBody({required this.isActive});

  final bool isActive;

  @override
  State<_BookmarkTabBody> createState() => _BookmarkTabBodyState();
}

class _BookmarkTabBodyState extends State<_BookmarkTabBody> {
  bool _showSearch = false;
  final _searchController = TextEditingController();

  @override
  void didUpdateWidget(_BookmarkTabBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      final userId = _getUserId();
      if (userId != null) {
        context.read<BookmarkBloc>().add(BookmarkEvent.load(userId: userId));
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String? _getUserId() {
    final authState = context.read<AuthBloc>().state;
    return authState.mapOrNull(authenticated: (s) => s.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AppBar(
              showSearch: _showSearch,
              searchController: _searchController,
              onSearchToggle: () {
                setState(() {
                  _showSearch = !_showSearch;
                  if (!_showSearch) {
                    _searchController.clear();
                    context
                        .read<BookmarkBloc>()
                        .add(const BookmarkEvent.searchChanged(query: ''));
                  }
                });
              },
              onSearchChanged: (q) => context
                  .read<BookmarkBloc>()
                  .add(BookmarkEvent.searchChanged(query: q)),
            ),
            BlocBuilder<BookmarkBloc, BookmarkState>(
              builder: (context, state) {
                return state.when(
                  initial: () => const SizedBox.shrink(),
                  loading: () => const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  loaded: (allBookmarks, filtered, selectedCategory,
                      newestFirst, searchQuery) {
                    return Expanded(
                      child: Column(
                        children: [
                          // Filter chips
                          const SizedBox(height: 4),
                          FilterChipsRow(
                            categories: _kCategories,
                            selectedCategory: selectedCategory,
                            onSelected: (cat) => context
                                .read<BookmarkBloc>()
                                .add(BookmarkEvent.filterChanged(
                                  category: cat,
                                )),
                          ),
                          const SizedBox(height: 4),
                          // Summary bar
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
                            child: Row(
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${filtered.length}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: _kDark,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' tersimpan',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: _kMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () => context
                                      .read<BookmarkBloc>()
                                      .add(const BookmarkEvent.toggleSort()),
                                  child: Container(
                                    height: 28,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(100),
                                      border: Border.all(
                                        color: _kBorder,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          newestFirst
                                              ? Icons.arrow_downward_rounded
                                              : Icons.arrow_upward_rounded,
                                          size: 12,
                                          color: _kMuted,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          newestFirst ? 'Terbaru' : 'Terlama',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: _kMuted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Content
                          if (filtered.isEmpty)
                            Expanded(
                              child: _EmptyState(
                                isFiltered: selectedCategory != 'Semua' ||
                                    searchQuery.isNotEmpty,
                              ),
                            )
                          else
                            Expanded(
                              child: ListView.separated(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  0,
                                  16,
                                  24,
                                ),
                                itemCount: filtered.length,
                                separatorBuilder: (_, index) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (context, i) {
                                  final b = filtered[i];
                                  final userId = _getUserId();
                                  return BookmarkCard(
                                    bookmark: b,
                                    onTap: () => context.push(
                                      '/chapter/${b.chapterId}',
                                    ),
                                    onRemove: userId == null
                                        ? () {}
                                        : () => context
                                            .read<BookmarkBloc>()
                                            .add(
                                              BookmarkEvent.removeBookmark(
                                                verseId: b.verseId,
                                                userId: userId,
                                              ),
                                            ),
                                    onEditNote: (note) => context
                                        .read<BookmarkBloc>()
                                        .add(
                                          BookmarkEvent.updateNote(
                                            verseId: b.verseId,
                                            note: note,
                                          ),
                                        ),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                  error: (message) => Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 48,
                              color: Color(0xFFAAAAAA),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              message,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: _kMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// App bar
// ─────────────────────────────────────────────────────────────────────────────

class _AppBar extends StatelessWidget {
  const _AppBar({
    required this.showSearch,
    required this.searchController,
    required this.onSearchToggle,
    required this.onSearchChanged,
  });

  final bool showSearch;
  final TextEditingController searchController;
  final VoidCallback onSearchToggle;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
      child: Row(
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: showSearch
                  ? Container(
                      key: const ValueKey('search'),
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: _kBorder, width: 1.5),
                      ),
                      child: TextField(
                        controller: searchController,
                        autofocus: true,
                        onChanged: onSearchChanged,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: _kDark,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Cari bookmark…',
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 13,
                            color: const Color(0xFFAAAAAA),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            size: 18,
                            color: Color(0xFFAAAAAA),
                          ),
                        ),
                      ),
                    )
                  : Align(
                      key: const ValueKey('title'),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Bookmark',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: _kDark,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onSearchToggle,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: _kBorder, width: 1.5),
              ),
              child: Icon(
                showSearch ? Icons.close_rounded : Icons.search_rounded,
                size: 18,
                color: _kDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isFiltered});

  final bool isFiltered;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F0E6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bookmark_outline_rounded,
                size: 36,
                color: Color(0xFF777777),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isFiltered ? 'Tidak ada hasil' : 'Belum ada bookmark',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: _kDark,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isFiltered
                  ? 'Coba ubah filter atau kata kunci pencarian.'
                  : 'Mulai simpan shalawat favoritmu\ndengan mengetuk ikon bookmark.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: _kMuted,
                height: 1.5,
              ),
            ),
            if (!isFiltered) ...[
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Navigate to Beranda tab (index 0) via scaffold
                  // Using a simple approach: pop back to index 0
                  DefaultTabController.maybeOf(context)?.animateTo(0);
                },
                child: Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: _kDark,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.explore_outlined,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        'Jelajahi Shalawat',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
