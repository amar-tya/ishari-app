import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';

/// Compact bookmark info widget with liquid glass style.
///
/// - Guest: shows a lock CTA inside the glass card.
/// - Logged-in: shows bookmark count + navigate arrow.
class BookmarkSection extends StatelessWidget {
  const BookmarkSection({
    required this.isGuest,
    super.key,
    this.bookmarkCount = 0,
    this.onTap,
  });

  final bool isGuest;

  /// Total saved bookmarks (placeholder until BookmarkBloc is implemented).
  final int bookmarkCount;

  /// Called when the widget is tapped (navigate to bookmark tab).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: isGuest ? null : onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF10B981).withValues(alpha: 0.35),
                ),
              ),
              child: isGuest
                  ? const _GuestContent()
                  : _LoggedInContent(count: bookmarkCount),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoggedInContent extends StatelessWidget {
  const _LoggedInContent({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Icon box
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF10B981).withValues(alpha: 0.4),
            ),
          ),
          child: const Icon(
            Icons.bookmark,
            color: Colors.white,
            size: 22,
          ),
        ),
        const SizedBox(width: 14),
        // Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$count Shalawat',
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                  height: 1,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'tersimpan di bookmark kamu',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        // Color dots
        const Row(
          children: [
            _Dot(color: Color(0xFF34D399)),
            SizedBox(width: 5),
            _Dot(color: Color(0xFF818CF8)),
            SizedBox(width: 5),
            _Dot(color: Color(0xFFF472B6)),
          ],
        ),
        const SizedBox(width: 10),
        // Arrow button
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: const Icon(
            Icons.chevron_right,
            color: Colors.white,
            size: 18,
          ),
        ),
      ],
    );
  }
}

class _GuestContent extends StatelessWidget {
  const _GuestContent();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF10B981).withValues(alpha: 0.4),
            ),
          ),
          child: const Icon(Icons.lock_outline, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Masuk untuk bookmark',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Simpan shalawat favoritmu',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () =>
              context.read<AuthBloc>().add(const AuthEvent.signInWithGoogle()),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: const Icon(
              Icons.chevron_right,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
