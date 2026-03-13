import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/features/home/presentation/bloc/home_bloc.dart';

const _categories = [
  'Diwan',
  'Diba',
  'Muradah',
  'Muhud',
  'Rowi',
  'Syaraful Anam',
];

/// Horizontally scrollable category filter chips.
///
/// Reads [HomeBloc] to determine the active chip and dispatches
/// [HomeEvent.categorySelected] on tap.
class CategoryChips extends StatelessWidget {
  const CategoryChips({super.key, required this.selectedCategory});

  final String selectedCategory;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final cat = _categories[i];
          final isActive = cat == selectedCategory;
          return GestureDetector(
            onTap: () => context
                .read<HomeBloc>()
                .add(HomeEvent.categorySelected(cat)),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF51C878)
                    : Colors.white,
                borderRadius: BorderRadius.circular(100),
                border: isActive
                    ? null
                    : Border.all(color: const Color(0xFFC8E6C9), width: 1.5),
              ),
              alignment: Alignment.center,
              child: Text(
                cat,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? Colors.white
                      : const Color(0xFF51C878),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
