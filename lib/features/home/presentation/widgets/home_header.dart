import 'package:flutter/material.dart';
import 'package:ishari/features/auth/domain/entities/user_entity.dart';

/// Compact header: avatar circle + display name (left), bell icon (right).
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, this.user});

  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    final isGuest = user == null;
    final displayName =
        isGuest ? 'Tamu' : (user!.displayName?.split(' ').first ?? 'Sahabat');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _Avatar(user: user),
          const SizedBox(width: 10),
          Text(
            displayName,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111111),
              letterSpacing: -0.2,
            ),
          ),
          const Spacer(),
          _BellButton(hasNotification: !isGuest),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.user});

  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    if (user?.avatarUrl != null) {
      return CircleAvatar(
        radius: 19,
        backgroundImage: NetworkImage(user!.avatarUrl!),
      );
    }

    final initial = user?.displayName?.isNotEmpty == true
        ? user!.displayName![0].toUpperCase()
        : (user == null ? '?' : 'S');

    return Container(
      width: 38,
      height: 38,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF10B981),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _BellButton extends StatelessWidget {
  const _BellButton({required this.hasNotification});

  final bool hasNotification;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFEAEAE7),
      ),
      child: Stack(
        children: [
          const Center(
            child: Icon(
              Icons.notifications_outlined,
              size: 20,
              color: Color(0xFF555555),
            ),
          ),
          if (hasNotification)
            Positioned(
              top: 8,
              right: 9,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFF5F5F2), width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
