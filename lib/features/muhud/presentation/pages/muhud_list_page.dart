import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/muhud/presentation/bloc/chapter_list_bloc.dart';
import 'package:ishari/features/muhud/presentation/bloc/chapter_list_event.dart';
import 'package:ishari/features/muhud/presentation/bloc/chapter_list_state.dart';
import 'package:ishari/features/muhud/presentation/widgets/chapter_list_item.dart';
import 'package:ishari/injection_container.dart';

const _kGreen = Color(0xFF51C878);
const _kGreenDark = Color(0xFF45B868);
const _kGrey = Color(0xFF79747E);

const _kGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [_kGreen, _kGreenDark],
);

class MuhudListPage extends StatelessWidget {
  const MuhudListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChapterListBloc>()..add(const ChapterListEvent.load()),
      child: const _MuhudListBody(),
    );
  }
}

class _MuhudListBody extends StatefulWidget {
  const _MuhudListBody();

  @override
  State<_MuhudListBody> createState() => _MuhudListBodyState();
}

class _MuhudListBodyState extends State<_MuhudListBody> {
  final _searchController = TextEditingController();
  String _query = '';
  String? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> _categories(List<ChapterEntity> chapters) {
    final seen = <String>{};
    return chapters.map((c) => c.category).where(seen.add).toList();
  }

  List<ChapterEntity> _filter(List<ChapterEntity> chapters) {
    var result = chapters;
    if (_selectedCategory != null) {
      result = result.where((c) => c.category == _selectedCategory).toList();
    }
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      result = result
          .where(
            (c) =>
                c.title.toLowerCase().contains(q) ||
                c.description.toLowerCase().contains(q),
          )
          .toList();
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<ChapterListBloc, ChapterListState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => Column(
                children: [
                  _GreenHeader(
                    searchController: _searchController,
                    query: _query,
                    onQueryChanged: (v) => setState(() => _query = v.trim()),
                    onQueryCleared: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                    categories: const [],
                    selectedCategory: _selectedCategory,
                    onCategorySelected: (c) =>
                        setState(() => _selectedCategory = c),
                  ),
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(color: _kGreen),
                    ),
                  ),
                ],
              ),
              loaded: (chapters) {
                final categories = _categories(chapters);
                final filtered = _filter(chapters);
                return Column(
                  children: [
                    // ── Green header: title + search + tabs ─────────────
                    _GreenHeader(
                      searchController: _searchController,
                      query: _query,
                      onQueryChanged: (v) =>
                          setState(() => _query = v.trim()),
                      onQueryCleared: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                      categories: categories,
                      selectedCategory: _selectedCategory,
                      onCategorySelected: (c) =>
                          setState(() => _selectedCategory = c),
                    ),

                    // ── Chapter list ─────────────────────────────────────
                    Expanded(
                      child: filtered.isEmpty
                          ? Center(
                              child: Text(
                                _query.isNotEmpty
                                    ? 'Tidak ada hasil untuk "$_query"'
                                    : 'Belum ada data',
                                style: const TextStyle(color: _kGrey),
                              ),
                            )
                          : ListView.builder(
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final chapter = filtered[index];
                                return Column(
                                  children: [
                                    ChapterListItem(
                                      chapter: chapter,
                                      onTap: () {
                                        final id = int.tryParse(chapter.id);
                                        if (id != null) {
                                          unawaited(
                                            context.push('/chapter/$id'),
                                          );
                                        }
                                      },
                                    ),
                                    if (index < filtered.length - 1)
                                      const Divider(
                                        height: 1,
                                        indent: 72,
                                        endIndent: 20,
                                        color: Color(0xFFEFEFEF),
                                      ),
                                  ],
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
              error: (message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.wifi_off_outlined,
                        size: 48,
                        color: _kGrey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: _kGrey),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () => context
                            .read<ChapterListBloc>()
                            .add(const ChapterListEvent.load()),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                        style: FilledButton.styleFrom(
                          backgroundColor: _kGreen,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Green gradient header: title bar + search + category tabs
// ─────────────────────────────────────────────────────────────────────────────

class _GreenHeader extends StatelessWidget {
  const _GreenHeader({
    required this.searchController,
    required this.query,
    required this.onQueryChanged,
    required this.onQueryCleared,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final TextEditingController searchController;
  final String query;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onQueryCleared;
  final List<String> categories;
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: _kGradient),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Title bar
            const SizedBox(
              height: 56,
              child: Center(
                child: Text(
                  'Muhud',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: TextField(
                controller: searchController,
                onChanged: onQueryChanged,
                style: const TextStyle(fontSize: 14, color: Color(0xFF1C1B1F)),
                decoration: InputDecoration(
                  hintText: 'Cari kitab...',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF79747E),
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: _kGreen,
                    size: 20,
                  ),
                  suffixIcon: query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            size: 18,
                            color: _kGrey,
                          ),
                          onPressed: onQueryCleared,
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Category tabs (on green background)
            if (categories.isNotEmpty) ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                child: Row(
                  children: [
                    _CategoryTab(
                      label: 'Semua',
                      isActive: selectedCategory == null,
                      onTap: () => onCategorySelected(null),
                    ),
                    ...categories.map(
                      (cat) => _CategoryTab(
                        label: cat,
                        isActive: selectedCategory == cat,
                        onTap: () => onCategorySelected(cat),
                      ),
                    ),
                  ],
                ),
              ),
            ] else
              const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Category tab item — white text on green background
// ─────────────────────────────────────────────────────────────────────────────

class _CategoryTab extends StatelessWidget {
  const _CategoryTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? Colors.white : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive
                ? Colors.white
                : Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}
