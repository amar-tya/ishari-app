import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Idle state for the search tab — shown when no query has been entered.
class SearchIdleView extends StatelessWidget {
  const SearchIdleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFE2E8DF),
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.search_rounded,
                size: 24,
                color: Color(0xFF777777),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Cari shalawat',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF111111),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Ketik nama bab, kitab, atau kata dalam bahasa Arab '
              'maupun Latin.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF777777),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
