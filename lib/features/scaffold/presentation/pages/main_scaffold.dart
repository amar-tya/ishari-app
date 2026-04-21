import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/core/app_state.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/bookmark/presentation/pages/bookmark_tab.dart';
import 'package:ishari/features/home/presentation/pages/home_page.dart';
import 'package:ishari/features/kitab/presentation/pages/kitab_tab.dart';
import 'package:ishari/features/search/presentation/pages/search_tab.dart';
import 'package:ishari/features/tatanan/presentation/pages/tatanan_tab.dart';

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

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
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
        ),
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
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

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
// Placeholder tabs
// ─────────────────────────────────────────────────────────────────────────────

// class _PlaceholderTab extends StatelessWidget {
//   const _PlaceholderTab({required this.icon, required this.label});

//   final IconData icon;
//   final String label;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 48, color: Colors.grey.shade300),
//           const SizedBox(height: 12),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey.shade400,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Coming soon',
//             style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
//           ),
//         ],
//       ),
//     );
//   }
// }

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
