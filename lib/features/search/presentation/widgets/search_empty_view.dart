import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Shown when a search query returns zero results.
class SearchEmptyView extends StatelessWidget {
  const SearchEmptyView({required this.query, super.key});

  final String query;

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
                Icons.search_off_rounded,
                size: 24,
                color: Color(0xFF777777),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ditemukan',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF111111),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 6),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF777777),
                  height: 1.6,
                ),
                children: [
                  const TextSpan(text: 'Tidak ada bab yang cocok dengan '),
                  TextSpan(
                    text: '"$query"',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111111),
                    ),
                  ),
                  const TextSpan(text: '. Coba kata kunci lain.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
