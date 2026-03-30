import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/features/home/presentation/bloc/home_bloc.dart';
import 'package:ishari/shared/widgets/filter_chips_row.dart';

const _categories = [
  'Diwan',
  'Diba',
  // 'Syaraful Anam',
  'Muradah',
  // 'Muhud',
  'Rowi',
];

/// Horizontally scrollable category filter chips for the home tab.
///
/// Delegates rendering to [FilterChipsRow] and dispatches
/// [HomeEvent.categorySelected] on selection.
class CategoryChips extends StatelessWidget {
  const CategoryChips({required this.selectedCategory, super.key});

  final String selectedCategory;

  @override
  Widget build(BuildContext context) {
    return FilterChipsRow(
      categories: _categories,
      selectedCategory: selectedCategory,
      onSelected: (cat) {
        context.read<HomeBloc>().add(HomeEvent.categorySelected(cat));
      },
    );
  }
}
