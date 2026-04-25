import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/core/ads/interstitial_ad_manager.dart';
import 'package:ishari/core/wizard/wizard_cubit.dart';
import 'package:ishari/core/wizard/wizard_state.dart';
import 'package:ishari/features/tatanan/presentation/bloc/tatanan_list/tatanan_list_bloc.dart';
import 'package:ishari/features/tatanan/presentation/widgets/create_tatanan_sheet.dart';
import 'package:ishari/features/tatanan/presentation/widgets/tatanan_card.dart';
import 'package:ishari/shared/widgets/banner_ad_widget.dart';
import 'package:ishari/shared/widgets/native_ad_card.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

const _kBg = Color(0xFFF0F5EE);
const _kDark = Color(0xFF111111);
const _kLime = Color(0xFFCAFF00);
const _kMuted = Color(0xFF777777);

class TatananListPage extends StatefulWidget {
  const TatananListPage({required this.userId, super.key});

  final String userId;

  @override
  State<TatananListPage> createState() => _TatananListPageState();
}

class _TatananListPageState extends State<TatananListPage> {
  final GlobalKey _addBtnKey = GlobalKey();
  bool _wizardShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeStartWizard());
  }

  void _maybeStartWizard() {
    if (!mounted) return;
    final state = context.read<WizardCubit>().state;
    if (state is WizardActive &&
        state.step == WizardStep.tatananCreate &&
        !_wizardShown) {
      _wizardShown = true;
      _showCreateCoach();
    }
  }

  void _showCreateCoach() {
    if (!mounted) return;
    final wizard = context.read<WizardCubit>();
    TutorialCoachMark(
      targets: [
        TargetFocus(
          identify: 'add_btn',
          keyTarget: _addBtnKey,
          shape: ShapeLightFocus.Circle,
          enableOverlayTab: false,
          enableTargetTab: true,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (_, __) => _TatananTooltip(
                step: '4/4',
                title: 'Buat Tatanan',
                body:
                    'Tap tombol + untuk membuat tatanan shalawat pertamamu. Susun ayat sesuai keinginan.',
                hint: 'Tap untuk membuka form',
              ),
            ),
          ],
        ),
      ],
      colorShadow: const Color(0xFF111111),
      opacityShadow: 0.88,
      onClickTarget: (_) {
        if (mounted) _openCreateSheet();
      },
      onFinish: () {
        // Wizard advances to tatananDetail after tatanan is created & navigated
      },
      onSkip: () {
        wizard.skip();
        return true;
      },
    ).show(context: context);
  }

  void _openCreateSheet() {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => CreateTatananSheet(
          onConfirm: ({required chapterId, required name, description}) {
            context.read<TatananListBloc>().add(
              TatananListEvent.create(
                userId: widget.userId,
                chapterId: chapterId,
                name: name,
                description: description,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WizardCubit, WizardState>(
      listener: (ctx, state) {
        if (state is WizardActive &&
            state.step == WizardStep.tatananCreate &&
            !_wizardShown) {
          _wizardShown = true;
          WidgetsBinding.instance
              .addPostFrameCallback((_) => _showCreateCoach());
        }
      },
      child: BlocListener<TatananListBloc, TatananListState>(
        listener: (context, state) {
          state.mapOrNull(
            created: (s) {
              InterstitialAdManager.instance.showIfReady(
                () {
                  context.read<WizardCubit>().advanceToTatananDetail();
                  context.push('/tatanan/${s.tatananId}');
                },
              );
            },
            error: (s) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  s.message,
                  style: GoogleFonts.poppins(fontSize: 13),
                ),
              ),
            ),
          );
        },
        child: Scaffold(
          backgroundColor: _kBg,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 14, 12, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Tatanan',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: _kDark,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      GestureDetector(
                        key: _addBtnKey,
                        onTap: () => _openCreateSheet(),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: _kDark,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.add, color: _kLime, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                // Banner ad
                const BannerAdWidget(),
                // Content
                Expanded(
                  child: BlocBuilder<TatananListBloc, TatananListState>(
                    builder: (context, state) {
                      return state.when(
                        initial: () => const SizedBox.shrink(),
                        loading: () => const Center(
                          child: CircularProgressIndicator(color: _kLime),
                        ),
                        loaded: (tatanans) => tatanans.isEmpty
                            ? _EmptyState(
                                onCreateTap: () => _openCreateSheet(),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  4,
                                  16,
                                  120,
                                ),
                                itemCount: tatanans.length >= 5
                                    ? tatanans.length + 1
                                    : tatanans.length,
                                itemBuilder: (context, i) {
                                  if (tatanans.length >= 5 && i == 4) {
                                    return const Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: NativeAdCard(),
                                    );
                                  }
                                  final dataIndex =
                                      tatanans.length >= 5 && i > 4
                                          ? i - 1
                                          : i;
                                  final t = tatanans[dataIndex];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: TatananCard(
                                      tatanan: t,
                                      onTap: () =>
                                          InterstitialAdManager.instance
                                              .showIfReady(
                                        () => context.push('/tatanan/${t.id}'),
                                      ),
                                      onDelete: () =>
                                          context.read<TatananListBloc>().add(
                                            TatananListEvent.delete(
                                              tatananId: t.id,
                                            ),
                                          ),
                                    ),
                                  );
                                },
                              ),
                        created: (_) => const Center(
                          child: CircularProgressIndicator(color: _kLime),
                        ),
                        error: (message) => Center(
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
                      );
                    },
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
// Wizard tooltip
// ─────────────────────────────────────────────────────────────────────────────

class _TatananTooltip extends StatelessWidget {
  const _TatananTooltip({
    required this.step,
    required this.title,
    required this.body,
    required this.hint,
  });

  final String step;
  final String title;
  final String body;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _kLime,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  step,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: _kDark,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: _kDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF444444),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            hint,
            style: const TextStyle(
              fontSize: 11,
              color: _kMuted,
              fontStyle: FontStyle.italic,
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
  const _EmptyState({required this.onCreateTap});

  final VoidCallback onCreateTap;

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
                Icons.format_list_numbered_rounded,
                size: 36,
                color: Color(0xFF777777),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Belum ada tatanan',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: _kDark,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Buat tatanan pertamamu dan susun\nayat shalawat sesuai keinginan.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: _kMuted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: onCreateTap,
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
                    const Icon(Icons.add, size: 16, color: Color(0xFFCAFF00)),
                    const SizedBox(width: 7),
                    Text(
                      'Buat Tatanan Pertama',
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
        ),
      ),
    );
  }
}
