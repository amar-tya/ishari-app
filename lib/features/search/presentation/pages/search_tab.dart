import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/home/presentation/widgets/chapter_masonry_grid.dart';
import 'package:ishari/features/search/presentation/bloc/search_bloc.dart';
import 'package:ishari/features/search/presentation/widgets/search_empty_view.dart';
import 'package:ishari/features/search/presentation/widgets/search_idle_view.dart';
import 'package:ishari/injection_container.dart';
import 'package:ishari/shared/widgets/filter_chips_row.dart';
import 'package:ishari/shared/widgets/search_bar_field.dart';

const _kBg = Color(0xFFF0F5EE);
const _kDark = Color(0xFF111111);

const _kSearchCategories = [
  'Semua',
  'Diwan',
  'Diba',
  'Muradah',
  'Rowi',
];

/// Cari (Search) tab — provides [SearchBloc] and renders the full search UI.
class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SearchBloc>(),
      child: const _SearchTabBody(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Body
// ─────────────────────────────────────────────────────────────────────────────

class _SearchTabBody extends StatefulWidget {
  const _SearchTabBody();

  @override
  State<_SearchTabBody> createState() => _SearchTabBodyState();
}

class _SearchTabBodyState extends State<_SearchTabBody> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() => setState(() {});

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {});
    context.read<SearchBloc>().add(SearchEvent.queryChanged(value));
  }

  void _onClear() {
    _controller.clear();
    context.read<SearchBloc>().add(const SearchEvent.cleared());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SearchHeader(
              controller: _controller,
              focusNode: _focusNode,
              isFocused: _focusNode.hasFocus,
              onChanged: _onChanged,
              onClear: _onClear,
            ),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  return state.when(
                    idle: () => const SearchIdleView(),
                    loading: () => const _LoadingView(),
                    results: (chapters, query, category) => _ResultsView(
                      chapters: chapters,
                      query: query,
                      category: category,
                    ),
                    empty: (query, category) =>
                        SearchEmptyView(query: query),
                    error: (message) => _ErrorView(message: message),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Search Header (bar + chips)
// ─────────────────────────────────────────────────────────────────────────────

class _SearchHeader extends StatelessWidget {
  const _SearchHeader({
    required this.controller,
    required this.focusNode,
    required this.isFocused,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFocused;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final isIdle = state.maybeWhen(idle: () => true, orElse: () => false);
        final selectedCategory = state.maybeWhen(
          results: (_, _, category) => category,
          empty: (_, category) => category,
          loading: () => 'Semua',
          orElse: () => 'Semua',
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isIdle) ...[
                    Text(
                      'Cari',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: _kDark,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                  SearchBarField(
                    controller: controller,
                    focusNode: focusNode,
                    isFocused: isFocused,
                    onChanged: onChanged,
                    onClear: onClear,
                  ),
                ],
              ),
            ),
            if (!isIdle) ...[
              const SizedBox(height: 12),
              FilterChipsRow(
                categories: _kSearchCategories,
                selectedCategory: selectedCategory,
                onSelected: (cat) {
                  context
                      .read<SearchBloc>()
                      .add(SearchEvent.categorySelected(cat));
                },
              ),
            ],
            const SizedBox(height: 4),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Loading
// ─────────────────────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: _kDark,
        strokeWidth: 2.5,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Results
// ─────────────────────────────────────────────────────────────────────────────

class _ResultsView extends StatelessWidget {
  const _ResultsView({
    required this.chapters,
    required this.query,
    required this.category,
  });

  final List<ChapterEntity> chapters;
  final String query;
  final String category;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hasil Pencarian',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _kDark,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  '${chapters.length} bab ditemukan',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF777777),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: ChapterMasonryGrid(
            chapters: chapters,
            onChapterTap: (chapter) {
              final id = int.tryParse(chapter.id);
              if (id != null) unawaited(context.push('/chapter/$id'));
            },
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_outlined,
              size: 48,
              color: Color(0xFF777777),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: const Color(0xFF777777),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
