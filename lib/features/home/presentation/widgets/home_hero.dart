import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// QS Al-Ahzab:56 headline section at the top of the homepage.
///
/// Certain words are highlighted as dark pill badges with a lime dot.
class HomeHero extends StatelessWidget {
  const HomeHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'QS Al-Ahzab: 56',
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF777777),
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF111111),
                letterSpacing: -0.6,
                height: 1.3,
              ),
              children: const [
                TextSpan(text: 'Sesungguhnya '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: _WordBadge(label: 'Allah'),
                ),
                TextSpan(text: ' dan para '),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: _WordBadge(label: 'malaikat-Nya'),
                ),
                TextSpan(text: ' bershalawat untuk Nabi.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WordBadge extends StatelessWidget {
  const _WordBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 1, 8, 2),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: Color(0xFFCAFF00),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
