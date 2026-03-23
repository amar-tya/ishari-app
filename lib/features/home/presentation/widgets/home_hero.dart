import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// QS Al-Ahzab:56 headline section at the top of the homepage.
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
            'QS AL-AHZAB: 56',
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF10B981),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sesungguhnya Allah\ndan para malaikat-Nya\nbershalawat untuk Nabi..',
            style: GoogleFonts.poppins(
              fontSize: 27,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111111),
              letterSpacing: -0.7,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}
