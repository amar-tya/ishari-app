import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ishari/core/app_state.dart';
import 'package:ishari/features/home/presentation/pages/home_page.dart';
import 'package:ishari/features/muhud/presentation/pages/muhud_tab.dart';

/// Root scaffold providing the 5-tab bottom navigation bar.
///
/// Tab 0 — Beranda (home content, fully implemented)
/// Tabs 1–4 — Placeholder screens (Kitab, Hadi, Bookmark, Profil)
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  void _onTabSelected(int index) {
    // For guest mode, gate the Bookmark tab
    if (index == 4 && AppState.isGuestMode.value) {
      _showBookmarkLockSheet();
      return;
    }
    setState(() => _selectedIndex = index);
  }

  void _showBookmarkLockSheet() {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        builder: (_) => const _BookmarkLockSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          HomeTab(),
          MuhudTab(),
          _PlaceholderTab(icon: Icons.menu_book_rounded, label: 'Kitab'),
          _PlaceholderTab(icon: Icons.people_outline, label: 'Hadi'),
          _PlaceholderTab(icon: Icons.bookmark_outline, label: 'Bookmark'),
          _PlaceholderTab(icon: Icons.person_outline, label: 'Profil'),
        ],
      ),
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onTabSelected,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Custom Bottom Navigation Bar
// ─────────────────────────────────────────────────────────────────────────────

const Color _primaryGreen = Color(0xFF51C878);
const Color _inactiveGrey = Color(0xFF79747E);
const Color _navBg = Colors.white;
const Color _navBorder = Color(0xFFE8EAE9);

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: _navBg,
          border: Border(top: BorderSide(color: _navBorder)),
          boxShadow: [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 12,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Regular nav items row
            Row(
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Beranda',
                  index: 0,
                  selectedIndex: selectedIndex,
                  onTap: onTap,
                ),
                _NavItem(
                  icon: Icons.menu_book_rounded,
                  label: 'Muhud',
                  index: 1,
                  selectedIndex: selectedIndex,
                  onTap: onTap,
                ),
                _NavItem(
                  icon: Icons.menu_book_rounded,
                  label: 'Kitab',
                  index: 2,
                  selectedIndex: selectedIndex,
                  onTap: onTap,
                ),
                _NavItem(
                  icon: Icons.person_outline,
                  label: 'Hadi',
                  index: 3,
                  selectedIndex: selectedIndex,
                  onTap: onTap,
                ),
                // Centre placeholder space for the floating Hadi button
                _NavItem(
                  icon: Icons.bookmark_outline,
                  label: 'Bookmark',
                  index: 4,
                  selectedIndex: selectedIndex,
                  onTap: onTap,
                ),
                _NavItem(
                  icon: Icons.person_outline,
                  label: 'Profil',
                  index: 5,
                  selectedIndex: selectedIndex,
                  onTap: onTap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isActive = selectedIndex == index;
    final color = isActive ? _primaryGreen : _inactiveGrey;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Placeholder tabs for Kitab, Hadi, Bookmark, Profil
// ─────────────────────────────────────────────────────────────────────────────

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming soon',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bookmark lock bottom sheet (for guest users tapping Bookmark tab)
// ─────────────────────────────────────────────────────────────────────────────

class _BookmarkLockSheet extends StatelessWidget {
  const _BookmarkLockSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, size: 48, color: _primaryGreen),
            const SizedBox(height: 16),
            const Text(
              'Masuk untuk mengakses Bookmark',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Simpan shalawat favoritmu dan akses kapan saja.',
              style: TextStyle(fontSize: 14, color: _inactiveGrey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  AppState.isGuestMode.value = false;
                  // Router redirect will handle navigation to /introduction
                },
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
