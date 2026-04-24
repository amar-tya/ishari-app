import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ishari/core/app_state.dart';
import 'package:ishari/core/wizard/wizard_cubit.dart';
import 'package:ishari/core/wizard/wizard_state.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/bookmark/presentation/pages/bookmark_tab.dart';
import 'package:ishari/features/home/presentation/pages/home_page.dart';
import 'package:ishari/features/kitab/presentation/pages/kitab_tab.dart';
import 'package:ishari/features/search/presentation/pages/search_tab.dart';
import 'package:ishari/features/tatanan/presentation/pages/tatanan_tab.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

/// Root scaffold providing the 5-tab floating pill navigation bar.
///
/// Tab 0 — Beranda (HomeTab)
/// Tab 1 — Cari (SearchTab)
/// Tab 2 — Kitab (KitabTab)
/// Tab 3 — Bookmark (guest-gated)
/// Tab 4 — Tatanan (guest-gated)
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  // Wizard
  final List<GlobalKey> _tabKeys = List.generate(5, (_) => GlobalKey());
  bool _tabWizardShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initWizard());
  }

  Future<void> _initWizard() async {
    if (!mounted) return;
    await context.read<WizardCubit>().init();
    if (!mounted) return;
    final state = context.read<WizardCubit>().state;
    if (state is WizardActive && state.step == WizardStep.muhudSplit) {
      context.push('/chapter/2');
    }
  }

  void _onTabSelected(int index) {
    if ((index == 3 || index == 4) && AppState.isGuestMode.value) {
      _showGuestLockSheet(index);
      return;
    }
    setState(() => _selectedIndex = index);
  }

  void _showGuestLockSheet(int index) {
    final feature = index == 4 ? 'Tatanan' : 'Bookmark';
    final subtitle = index == 4
        ? 'Buat dan kelola tatanan ayat shalawatmu.'
        : 'Simpan shalawat favoritmu dan akses kapan saja.';
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        builder: (_) => _GuestLockSheet(feature: feature, subtitle: subtitle),
      ),
    );
  }

  // ── Wizard tab tour ─────────────────────────────────────────────────────────

  void _startTabTour() {
    if (!mounted || _tabWizardShown) return;
    _tabWizardShown = true;

    final isGuest = AppState.isGuestMode.value;
    final wizard = context.read<WizardCubit>();

    final targets = [
      _tabTarget(
        key: _tabKeys[0],
        identify: 'tab_beranda',
        step: '3/5',
        title: 'Beranda',
        body: 'Jelajahi daftar shalawat, diba\', rowi, dan muradah pilihan.',
      ),
      _tabTarget(
        key: _tabKeys[1],
        identify: 'tab_cari',
        step: '3/5',
        title: 'Cari',
        body: 'Cari shalawat, diba\', rowi, atau muradah dengan cepat.',
      ),
      _tabTarget(
        key: _tabKeys[2],
        identify: 'tab_kitab',
        step: '3/5',
        title: 'Kitab',
        body: 'Buka dan baca kitab-kitab shalawat yang tersedia.',
      ),
      _tabTarget(
        key: _tabKeys[3],
        identify: 'tab_bookmark',
        step: '3/5',
        title: 'Bookmark',
        body: isGuest
            ? 'Simpan ayat favorit dan akses kapan saja.\n\n🔒 Login untuk mengakses fitur ini.'
            : 'Simpan ayat favorit dan akses kapan saja.',
      ),
      _tabTarget(
        key: _tabKeys[4],
        identify: 'tab_tatanan',
        step: '3/5',
        title: 'Tatanan',
        body: isGuest
            ? 'Buat susunan shalawat sendiri sesuai kebutuhanmu.\n\n🔒 Login untuk mengakses fitur ini.'
            : 'Buat susunan shalawat sendiri sesuai kebutuhanmu.',
      ),
    ];

    TutorialCoachMark(
      targets: targets,
      colorShadow: const Color(0xFF111111),
      opacityShadow: 0.88,
      onClickTarget: (target) {
        if (!mounted) return;
        switch (target.identify) {
          case 'tab_beranda':
            setState(() => _selectedIndex = 0);
          case 'tab_cari':
            setState(() => _selectedIndex = 1);
          case 'tab_kitab':
            setState(() => _selectedIndex = 2);
          case 'tab_bookmark':
            if (!isGuest) setState(() => _selectedIndex = 3);
          case 'tab_tatanan':
            if (!isGuest) setState(() => _selectedIndex = 4);
        }
      },
      onFinish: () {
        if (!mounted) return;
        if (isGuest) {
          wizard.skipForGuest();
        } else {
          wizard.advance(); // tabTatanan → tatananCreate
          setState(() => _selectedIndex = 4); // Switch to Tatanan tab
        }
      },
      onSkip: () {
        wizard.skip();
        return true;
      },
    ).show(context: context);
  }

  TargetFocus _tabTarget({
    required GlobalKey key,
    required String identify,
    required String step,
    required String title,
    required String body,
  }) {
    return TargetFocus(
      identify: identify,
      keyTarget: key,
      shape: ShapeLightFocus.RRect,
      radius: 30,
      enableOverlayTab: false,
      enableTargetTab: true,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (_, __) => _TabTooltip(
            step: step,
            title: title,
            body: body,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WizardCubit, WizardState>(
      listener: (ctx, state) {
        if (state is WizardActive) {
          if (state.step == WizardStep.muhudSplit) {
            context.push('/chapter/2');
          } else if (state.step == WizardStep.tabBeranda && !_tabWizardShown) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _startTabTour();
            });
          } else if (state.step == WizardStep.tatananCreate) {
            setState(() => _selectedIndex = 4);
          }
        }
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          state.whenOrNull(
            authenticated: (_) {
              if (AppState.isGuestMode.value) {
                AppState.isGuestMode.value = false;
              }
            },
          );
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF0F5EE),
          extendBody: true,
          body: IndexedStack(
            index: _selectedIndex,
            children: [
              const HomeTab(),
              const SearchTab(),
              const KitabTab(),
              BookmarkTab(
                isActive: _selectedIndex == 3,
                onNavigateToHome: () => _onTabSelected(0),
              ),
              TatananTab(isActive: _selectedIndex == 4),
            ],
          ),
          bottomNavigationBar: _FloatingNavBar(
            selectedIndex: _selectedIndex,
            onTap: _onTabSelected,
            tabKeys: _tabKeys,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Wizard tab tooltip
// ─────────────────────────────────────────────────────────────────────────────

class _TabTooltip extends StatelessWidget {
  const _TabTooltip({
    required this.step,
    required this.title,
    required this.body,
  });

  final String step;
  final String title;
  final String body;

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
                  color: const Color(0xFFCAFF00),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  step,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111111),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111111),
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
          const Text(
            'Tap tab untuk lanjut →',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF777777),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Floating pill navigation bar
// ─────────────────────────────────────────────────────────────────────────────

const _kLime = Color(0xFFCAFF00);
const _kDark = Color(0xFF111111);
const _kInactiveIcon = Color(0xFFAAAAAA);

class _FloatingNavBar extends StatelessWidget {
  const _FloatingNavBar({
    required this.selectedIndex,
    required this.onTap,
    required this.tabKeys,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;
  final List<GlobalKey> tabKeys;

  static const _items = [
    _NavItemData(icon: Icons.home_rounded, label: 'Beranda'),
    _NavItemData(icon: Icons.search_rounded, label: 'Cari'),
    _NavItemData(icon: Icons.menu_book_rounded, label: 'Kitab'),
    _NavItemData(icon: Icons.bookmark_outline, label: 'Bookmark'),
    _NavItemData(icon: Icons.format_list_numbered_rounded, label: 'Tatanan'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottomPadding),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: const [
            BoxShadow(
              color: Color(0x24000000),
              blurRadius: 32,
              offset: Offset(0, 8),
            ),
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Row(
            children: [
              for (var i = 0; i < _items.length; i++)
                _NavItem(
                  key: tabKeys[i],
                  data: _items[i],
                  isActive: selectedIndex == i,
                  onTap: () => onTap(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.data,
    required this.isActive,
    required this.onTap,
    super.key,
  });

  final _NavItemData data;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: isActive ? 16 : 10,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          height: double.infinity,
          decoration: BoxDecoration(
            color: isActive ? _kLime : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                data.icon,
                size: 20,
                color: isActive ? _kDark : _kInactiveIcon,
              ),
              if (isActive) ...[
                const SizedBox(width: 5),
                Text(
                  data.label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: _kDark,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bookmark lock bottom sheet (for guest users tapping Bookmark tab)
// ─────────────────────────────────────────────────────────────────────────────

class _GuestLockSheet extends StatelessWidget {
  const _GuestLockSheet({
    required this.feature,
    required this.subtitle,
  });

  final String feature;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, size: 48, color: _kDark),
            const SizedBox(height: 16),
            Text(
              'Masuk untuk mengakses $feature',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: Color(0xFF79747E)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<AuthBloc>().add(
                    const AuthEvent.signInWithGoogle(),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: _kDark,
                ),
                child: const Text('Masuk Sekarang'),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Nanti saja'),
            ),
          ],
        ),
      ),
    );
  }
}
