import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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

const _kBg = Color(0xFFF0F5EE);

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
      backgroundColor: _kBg,
      body: SafeArea(
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF111111),
            strokeWidth: 2.5,
          ),
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
      backgroundColor: _kBg,
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
                  color: Color(0xFF777777),
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF777777)),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () =>
                      context.read<HomeBloc>().add(const HomeEvent.refresh()),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF111111),
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
      backgroundColor: _kBg,
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            color: const Color(0xFF111111),
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
                      const SizedBox(height: 18),
                      const HomeHero(),
                      const SizedBox(height: 14),
                      CategoryChips(selectedCategory: selectedCategory),
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

