import 'package:flutter/material.dart';
import 'package:ishari/features/auth/domain/entities/user_entity.dart';

/// Greeting header: avatar + "Halo, [Nama]!" + notification bell.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, this.user});

  /// Authenticated user. `null` for guest mode.
  final UserEntity? user;

  @override
  Widget build(BuildContext context) {
    final isGuest = user == null;
    final displayName =
        isGuest ? 'Tamu' : (user!.displayName?.split(' ').first ?? 'Sahabat');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _Avatar(user: user),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, $displayName!',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1C1B1F),
                  ),
                ),
                const Text(
                  "Assalamu'alaikum",
                  style: TextStyle(fontSize: 12, color: Color(0xFF79747E)),
                ),
              ],
            ),
          ),
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
        radius: 23,
        backgroundImage: NetworkImage(user!.avatarUrl!),
      );
    }

    const initial = 'A'; // fallback initial

    return Container(
      width: 46,
      height: 46,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF51C878),
        boxShadow: [
          BoxShadow(
            color: Color(0x5951C878),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        user != null
            ? (user!.displayName?.isNotEmpty == true
                ? user!.displayName![0].toUpperCase()
                : initial)
            : '?',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
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
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Center(
            child: Icon(Icons.notifications_outlined, size: 20, color: Color(0xFF49454F)),
          ),
          if (hasNotification)
            Positioned(
              top: 8,
              right: 9,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
