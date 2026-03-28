import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Horizontally scrollable filter chips.
///
/// Generic and reusable — pass any list of [categories], the
/// [selectedCategory], and an [onSelected] callback. The active chip is filled
/// dark; inactive chips are outlined.
class FilterChipsRow extends StatelessWidget {
  const FilterChipsRow({
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  });

  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelected;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final cat = categories[i];
          final isActive = cat == selectedCategory;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onSelected(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color:
                    isActive ? const Color(0xFF111111) : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
                border: isActive
                    ? null
                    : Border.all(
                        color: const Color(0xFFD0D8CE),
                        width: 1.5,
                      ),
              ),
              alignment: Alignment.center,
              child: Text(
                cat,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isActive
                      ? Colors.white
                      : const Color(0xFF777777),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
