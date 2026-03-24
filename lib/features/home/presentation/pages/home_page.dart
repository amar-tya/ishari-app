import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/core/app_state.dart';
import 'package:ishari/features/auth/domain/entities/user_entity.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/home/presentation/bloc/home_bloc.dart';
import 'package:ishari/features/home/presentation/widgets/category_chips.dart';
import 'package:ishari/features/home/presentation/widgets/chapter_masonry_grid.dart';
import 'package:ishari/features/home/presentation/widgets/home_header.dart';
import 'package:ishari/features/home/presentation/widgets/home_hero.dart';
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
            chapters: chapters,
            selectedCategory: category,
          ),
          error: (message) => _ErrorView(message: message),
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
    return const Scaffold(
      backgroundColor: Color(0xFFF5F5F2),
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF10B981)),
        ),
      ),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F2),
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
                    backgroundColor: const Color(0xFF10B981),
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
// Loaded — full homepage
// ─────────────────────────────────────────────────────────────────────────────

class _LoadedView extends StatelessWidget {
  const _LoadedView({
    required this.chapters,
    required this.selectedCategory,
  });

  final List<ChapterEntity> chapters;
  final String selectedCategory;

  @override
  Widget build(BuildContext context) {
    final isGuest = AppState.isGuestMode.value;
    final authState = context.watch<AuthBloc>().state;
    final user = authState.maybeWhen<UserEntity?>(
      authenticated: (u) => u,
      orElse: () => null,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F2),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            color: const Color(0xFF10B981),
            onRefresh: () async {
              context.read<HomeBloc>().add(HomeEvent.refresh(userId: user?.id));
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
                      const SizedBox(height: 16),
                      HomeHeader(user: isGuest ? null : user),
                      const SizedBox(height: 20),
                      const HomeHero(),
                      const SizedBox(height: 16),
                      CategoryChips(selectedCategory: selectedCategory),
                      const SizedBox(height: 24),
                      _SectionHeader(count: chapters.length),
                      const SizedBox(height: 12),
                      ChapterMasonryGrid(
                        chapters: chapters,
                        onChapterTap: (chapter) {
                          final id = int.tryParse(chapter.id);
                          if (id != null) unawaited(context.push('/chapter/$id'));
                        },
                      ),
                      const SizedBox(height: 40),
                    ],
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Chapter Shalawat',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF111111),
              letterSpacing: -0.4,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              '$count chapter',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF059669),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
