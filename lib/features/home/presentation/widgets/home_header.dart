import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/features/auth/domain/entities/user_entity.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ishari/features/home/presentation/widgets/home_menu_sheets.dart';

/// Compact header: avatar + greeting + name (left), bell + more-menu (right).
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
          const SizedBox(width: 8),
          _MoreButton(user: user, isGuest: isGuest),
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

enum _MenuAction { contactUs, login, logout }

class _MoreButton extends StatelessWidget {
  const _MoreButton({required this.user, required this.isGuest});

  final UserEntity? user;
  final bool isGuest;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuAction>(
      offset: const Offset(0, 44),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      elevation: 8,
      shadowColor: Colors.black26,
      onSelected: (action) {
        switch (action) {
          case _MenuAction.contactUs:
            unawaited(showContactSheet(context));
          case _MenuAction.login:
            context.read<AuthBloc>().add(const AuthEvent.signInWithGoogle());
          case _MenuAction.logout:
            final name =
                isGuest ? null : user?.displayName?.split(' ').first;
            unawaited(showLogoutSheet(context, displayName: name));
        }
      },
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: _MenuAction.contactUs,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: _MenuItemContent(
            iconBg: Color(0xFFE8FAF0),
            icon: Icons.email_rounded,
            iconColor: Color(0xFF51C878),
            label: 'Hubungi Kami',
            subtitle: 'Email & WhatsApp',
          ),
        ),
        if (isGuest)
          const PopupMenuItem(
            value: _MenuAction.login,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: _MenuItemContent(
              iconBg: Color(0xFFE8FAF0),
              icon: Icons.login_rounded,
              iconColor: Color(0xFF51C878),
              label: 'Masuk',
              subtitle: 'Login ke akun kamu',
            ),
          ),
        if (!isGuest)
          const PopupMenuItem(
            value: _MenuAction.logout,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: _MenuItemContent(
              iconBg: Color(0xFFFFF0EF),
              icon: Icons.logout_rounded,
              iconColor: Color(0xFFB3261E),
              label: 'Keluar',
              subtitle: 'Logout dari akun',
              labelColor: Color(0xFFB3261E),
            ),
          ),
      ],
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE2E8DF), width: 1.5),
        ),
        child: const Icon(Icons.more_vert, size: 18, color: Color(0xFF555555)),
      ),
    );
  }
}

class _MenuItemContent extends StatelessWidget {
  const _MenuItemContent({
    required this.iconBg,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.subtitle,
    this.labelColor = const Color(0xFF1C1B1F),
  });

  final Color iconBg;
  final IconData icon;
  final Color iconColor;
  final String label;
  final String subtitle;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: labelColor,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF79747E),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
