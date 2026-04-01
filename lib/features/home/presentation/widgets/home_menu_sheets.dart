import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/core/app_state.dart';
import 'package:ishari/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Logout confirmation sheet
// ─────────────────────────────────────────────────────────────────────────────

Future<void> showLogoutSheet(
  BuildContext context, {
  required String? displayName,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetCtx) => _LogoutSheet(
      displayName: displayName,
      authBloc: context.read<AuthBloc>(),
    ),
  );
}

class _LogoutSheet extends StatelessWidget {
  const _LogoutSheet({required this.displayName, required this.authBloc});

  final String? displayName;
  final AuthBloc authBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          const SizedBox(height: 20),
          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0EF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.logout_rounded,
              size: 30,
              color: Color(0xFFB3261E),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Keluar dari Akun?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C1B1F),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            displayName != null
                ? 'Kamu akan keluar dari akun $displayName. '
                      'Progres dan bookmark tetap tersimpan.'
                : 'Kamu akan keluar dari aplikasi.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF79747E),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          // Confirm button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _doLogout();
              },
              icon: const Icon(Icons.logout_rounded, size: 18),
              label: const Text('Ya, Keluar'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFB3261E),
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Cancel button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF49454F),
                side: const BorderSide(color: Color(0xFFE8EAE9), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: const Text(
                'Batal',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _doLogout() {
    if (AppState.isGuestMode.value) {
      AppState.isGuestMode.value = false;
    } else {
      authBloc.add(const AuthEvent.signOut());
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Contact Us sheet
// ─────────────────────────────────────────────────────────────────────────────

Future<void> showContactSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const _ContactSheet(),
  );
}

class _ContactSheet extends StatelessWidget {
  const _ContactSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Hubungi Kami',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C1B1F),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Pilih cara yang paling mudah untukmu',
            style: TextStyle(fontSize: 13, color: Color(0xFF79747E)),
          ),
          const SizedBox(height: 16),
          _ContactItem(
            iconBg: const Color(0xFFE6F9EF),
            icon: Icons.chat_rounded,
            iconColor: const Color(0xFF25D366),
            label: 'WhatsApp',
            value: '+62 812-3456-7890',
            onTap: () => _launch('https://wa.me/6281234567890'),
          ),
          _ContactItem(
            iconBg: const Color(0xFFE8F0FF),
            icon: Icons.email_rounded,
            iconColor: const Color(0xFF4285F4),
            label: 'Email',
            value: 'support@ishari.app',
            onTap: () => _launch('mailto:support@ishari.app'),
          ),
        ],
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _ContactItem extends StatelessWidget {
  const _ContactItem({
    required this.iconBg,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final Color iconBg;
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1B1F),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF79747E),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFFBDBDBD),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
