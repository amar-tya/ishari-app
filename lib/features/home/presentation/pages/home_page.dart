import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/core/app_state.dart';
import 'package:ishari/features/auth/domain/entities/user_entity.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/home/domain/entities/hadi_entity.dart';
import 'package:ishari/features/home/presentation/bloc/home_bloc.dart';
import 'package:ishari/features/home/presentation/widgets/bookmark_section.dart';
import 'package:ishari/features/home/presentation/widgets/category_chips.dart';
import 'package:ishari/features/home/presentation/widgets/chapter_card.dart';
import 'package:ishari/features/home/presentation/widgets/featured_chapter_card.dart';
import 'package:ishari/features/home/presentation/widgets/hadi_section.dart';
import 'package:ishari/features/home/presentation/widgets/home_header.dart';
import 'package:ishari/features/home/presentation/widgets/home_search_bar.dart';
import 'package:ishari/injection_container.dart';

/// Beranda tab — provides [HomeBloc] and renders the full homepage layout.
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final isGuest = AppState.isGuestMode.value;
        final authState = context.read<AuthBloc>().state;
        final userId = authState.maybeWhen(
          authenticated: (user) => user.id,
          orElse: () => null,
        );
        return sl<HomeBloc>()
          ..add(HomeEvent.load(userId: isGuest ? null : userId));
      },
      child: const _HomeTabBody(),
    );
  }
}

class _HomeTabBody extends StatelessWidget {
  const _HomeTabBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return state.when(
          initial: () => const SizedBox.shrink(),
          loading: () => const _LoadingView(),
          loaded: (featured, chapters, category, hadiList) => _LoadedView(
            featuredChapter: featured,
            chapters: chapters,
            selectedCategory: category,
            hadiList: hadiList,
          ),
          error: (message) => _ErrorView(message: message),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Loading state
// ─────────────────────────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF6F8F7),
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF51C878),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error state
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F7),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.wifi_off_outlined,
                  size: 48,
                  color: Color(0xFF79747E),
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF79747E)),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () =>
                      context.read<HomeBloc>().add(const HomeEvent.refresh()),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF51C878),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Loaded state — the full homepage layout
// ─────────────────────────────────────────────────────────────────────────────

class _LoadedView extends StatelessWidget {
  const _LoadedView({
    required this.featuredChapter,
    required this.chapters,
    required this.selectedCategory,
    required this.hadiList,
  });

  final ChapterEntity featuredChapter;
  final List<ChapterEntity> chapters;
  final String selectedCategory;
  final List<HadiEntity> hadiList;

  @override
  Widget build(BuildContext context) {
    final isGuest = AppState.isGuestMode.value;
    final authState = context.watch<AuthBloc>().state;
    final user = authState.maybeWhen<UserEntity?>(
      authenticated: (u) => u,
      orElse: () => null,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F7),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF51C878),
          onRefresh: () async {
            context.read<HomeBloc>().add(HomeEvent.refresh(userId: user?.id));
            // Wait until the bloc leaves the loading state
            await context.read<HomeBloc>().stream.firstWhere(
              (s) => s.maybeWhen(loading: () => false, orElse: () => true),
            );
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // 1. Header
                    HomeHeader(user: isGuest ? null : user),
                    const SizedBox(height: 14),

                    // 2. Search bar
                    const HomeSearchBar(),
                    const SizedBox(height: 24),

                    // 3. Featured chapter card
                    FeaturedChapterCard(
                      chapter: featuredChapter,
                      isGuest: isGuest,
                      onTap: () {
                        final id = int.tryParse(featuredChapter.id);
                        if (id != null) AppState.muhudChapterRequest.value = id;
                      },
                    ),
                    const SizedBox(height: 24),

                    // 4a. Category section header
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Jelajahi Kategori',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1C1B1F),
                            ),
                          ),
                          Text(
                            'Lihat semua',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF51C878),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 4b. Category chips
                    CategoryChips(selectedCategory: selectedCategory),
                    const SizedBox(height: 14),
                  ],
                ),
              ),

              // 4c. Chapter cards — horizontal scroll
              SliverToBoxAdapter(
                child: chapters.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Belum ada chapter untuk kategori ini.',
                          style: TextStyle(color: Color(0xFF79747E)),
                        ),
                      )
                    : SizedBox(
                        height: 148,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ).copyWith(bottom: 4),
                          itemCount: chapters.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (_, i) => ChapterCard(
                            chapter: chapters[i],
                            onTap: () {
                              final id = int.tryParse(chapters[i].id);
                              if (id != null) {
                                AppState.muhudChapterRequest.value = id;
                              }
                            },
                          ),
                        ),
                      ),
              ),

              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // 5. Bookmark section
                    BookmarkSection(isGuest: isGuest),
                    const SizedBox(height: 24),

                    // 6. Hadi section
                    if (hadiList.isNotEmpty) ...[
                      HadiSection(hadiList: hadiList),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
