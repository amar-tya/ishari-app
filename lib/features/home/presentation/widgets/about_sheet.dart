import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

const _websiteUrl = 'https://ishari.vercel.app';
const _privacyUrl = 'https://ishari.vercel.app/privacy';

Future<void> showAboutSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const _AboutSheet(),
  );
}

class _AboutSheet extends StatefulWidget {
  const _AboutSheet();

  @override
  State<_AboutSheet> createState() => _AboutSheetState();
}

class _AboutSheetState extends State<_AboutSheet> {
  String _version = '–';

  @override
  void initState() {
    super.initState();
    unawaited(
      PackageInfo.fromPlatform().then((info) {
        if (mounted) setState(() => _version = info.version);
      }),
    );
  }

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
          const SizedBox(height: 24),
          // Logo + App info
          SvgPicture.asset(
            'assets/icons/ishari_mark.svg',
            width: 52,
            height: 52,
          ),
          const SizedBox(height: 12),
          Text(
            'Shalawat Hadrah ISHARI',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF111111),
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Versi $_version',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: const Color(0xFF999999),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(color: Color(0xFFF0F0F0), height: 1),
          const SizedBox(height: 20),
          // Description
          Text(
            'Aplikasi shalawat dan bacaan ISHARI — baca, dengarkan, dan tandai sholawat favorit kapan saja.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: const Color(0xFF79747E),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(color: Color(0xFFF0F0F0), height: 1),
          const SizedBox(height: 20),
          // Developer info
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Dikembangkan oleh ',
                style: TextStyle(fontSize: 13, color: Color(0xFF79747E)),
              ),
              Text(
                'Amar Firmansyah dan Tim',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1C1B1F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Link buttons
          _LinkButton(
            icon: Icons.language_rounded,
            iconColor: const Color(0xFF5C6BC0),
            iconBg: const Color(0xFFEEF2FF),
            label: 'Website',
            onTap: () => _launch(_websiteUrl),
          ),
          const SizedBox(height: 10),
          _LinkButton(
            icon: Icons.shield_outlined,
            iconColor: const Color(0xFF2E7D32),
            iconBg: const Color(0xFFE8F5E9),
            label: 'Kebijakan Privasi',
            onTap: () => _launch(_privacyUrl),
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

class _LinkButton extends StatelessWidget {
  const _LinkButton({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF1C1B1F),
          side: const BorderSide(color: Color(0xFFE8EAE9), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 16),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.open_in_new_rounded,
              size: 16,
              color: Color(0xFFBDBDBD),
            ),
          ],
        ),
      ),
    );
  }
}
