import 'package:flutter/material.dart';
import 'package:ishari/core/app_state.dart';

/// Bookmark section.
///
/// - Guest: shows a lock banner with a CTA to sign in.
/// - Logged-in: placeholder — full BookmarkBloc implementation is a future task.
class BookmarkSection extends StatelessWidget {
  const BookmarkSection({super.key, required this.isGuest});

  final bool isGuest;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Bookmark Saya',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1C1B1F),
                ),
              ),
              if (!isGuest)
                const Text(
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: isGuest ? const _GuestBookmarkBanner() : const _LoggedInBookmarkPlaceholder(),
        ),
      ],
    );
  }
}

class _GuestBookmarkBanner extends StatelessWidget {
  const _GuestBookmarkBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8EAE9)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.lock_outline,
            size: 32,
            color: Color(0xFF51C878),
          ),
          const SizedBox(height: 12),
          const Text(
            'Masuk untuk menyimpan\nshalawat favoritmu',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1B1F),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                AppState.isGuestMode.value = false;
                // The GoRouter redirect will send the user to /introduction
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF51C878),
              ),
              child: const Text('Masuk Sekarang'),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoggedInBookmarkPlaceholder extends StatelessWidget {
  const _LoggedInBookmarkPlaceholder();

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with real BookmarkBloc once implemented
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8EAE9)),
      ),
      child: const Column(
        children: [
          Icon(Icons.bookmark_outline, size: 32, color: Color(0xFF51C878)),
          SizedBox(height: 8),
          Text(
            'Belum ada bookmark',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF79747E),
            ),
          ),
        ],
      ),
    );
  }
}
