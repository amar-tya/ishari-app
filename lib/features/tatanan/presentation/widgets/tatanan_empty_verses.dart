import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/shared/widgets/reader/reader_colors.dart';

class TatananEmptyVerses extends StatelessWidget {
  const TatananEmptyVerses({required this.onAdd, super.key});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F0E6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.format_list_numbered_rounded,
                size: 32,
                color: Color(0xFF777777),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Tatanan masih kosong',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: kReaderDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap tombol + untuk menambahkan ayat.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 13, color: kReaderMuted),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: onAdd,
              child: Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: kReaderDark,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, size: 16, color: kReaderLime),
                    const SizedBox(width: 7),
                    Text(
                      'Tambah Ayat',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
