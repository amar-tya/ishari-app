import 'package:flutter/material.dart';
import 'package:ishari/features/auth/domain/entities/user_entity.dart';

/// Compact header: avatar circle + greeting + display name (left), bell icon (right).
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Selamat Datang 👋',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF777777),
                ),
              ),
              const SizedBox(height: 1),
              Text(
                displayName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111111),
                  letterSpacing: -0.2,
                ),
              ),
            ],
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

    final isGuest = user == null;
    final initial = !isGuest && (user!.displayName?.isNotEmpty == true)
        ? user!.displayName![0].toUpperCase()
        : '?';

    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isGuest ? const Color(0xFFE8F0E6) : const Color(0xFFCAFF00),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          color: isGuest ? const Color(0xFFAAAAAA) : const Color(0xFF111111),
          fontSize: 14,
          fontWeight: FontWeight.w900,
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
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E8DF), width: 1.5),
      ),
      child: Stack(
        children: [
          const Center(
            child: Icon(
              Icons.notifications_outlined,
              size: 18,
              color: Color(0xFF555555),
            ),
          ),
          if (hasNotification)
            Positioned(
              top: 7,
              right: 7,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF4D4F),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFF0F5EE),
                    width: 1.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
