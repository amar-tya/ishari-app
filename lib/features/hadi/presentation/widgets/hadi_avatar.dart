import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const List<({Color bg, Color fg})> _kVariants = [
  (bg: Color(0xFF111111), fg: Color(0xFFCAFF00)),
  (bg: Color(0xFFCAFF00), fg: Color(0xFF111111)),
  (bg: Color(0xFFE8F0E6), fg: Color(0xFF111111)),
];

/// Avatar circle with a deterministic color + initials derived from [name],
/// matching the Claude Design mock (`Hadi.dc.html`): 3-variant color cycle
/// by list index, initials from the first two words after stripping the
/// "Hadi " prefix.
class HadiAvatar extends StatelessWidget {
  const HadiAvatar({
    required this.name,
    required this.index,
    this.size = 52,
    super.key,
  });

  final String name;
  final int index;
  final double size;

  String get _initials {
    final stripped = name.startsWith('Hadi ') ? name.substring(5) : name;
    final words = stripped.trim().split(RegExp(r'\s+'));
    final letters = words
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0])
        .join();
    return letters.isEmpty ? '?' : letters.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final variant = _kVariants[index % _kVariants.length];
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: variant.bg),
      alignment: Alignment.center,
      child: Text(
        _initials,
        style: GoogleFonts.dmSans(
          fontWeight: FontWeight.w800,
          fontSize: size * 0.31,
          color: variant.fg,
        ),
      ),
    );
  }
}
