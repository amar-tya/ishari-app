import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/features/audio/domain/entities/audio_category.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_list_bloc.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_list_event.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_list_state.dart';
import 'package:ishari/features/audio/presentation/widgets/audio_category_list_sheet.dart';

const _kDark = Color(0xFF111111);
const _kMute = Color(0xFF777777);
const _kBorder = Color(0xFFE2E8DF);
const _kLime = Color(0xFFCAFF00);
const _kBg = Color(0xFFF0F5EE);
const _kGreen = Color(0xFF3DA85F);

/// Filter bottom sheet — 3 category sections (Hadi/Muhud/Rodad Cabang), each
/// up to 5 chips + "Open List" drill-down ([AudioCategoryListSheet]) when a
/// category has more values. Reset/Batal/Terapkan act on
/// [AudioListBloc]'s draftSelected; only "Terapkan" commits it to
/// appliedSelected.
class AudioFilterSheet extends StatelessWidget {
  const AudioFilterSheet({super.key});

  static Future<void> show(BuildContext context) {
    final bloc = context.read<AudioListBloc>()
      ..add(const AudioListEvent.openFilterSheet());
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          BlocProvider.value(value: bloc, child: const AudioFilterSheet()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioListBloc, AudioListState>(
      builder: (context, state) {
        final sections = state.categorySubValues;
        return Container(
          decoration: const BoxDecoration(
            color: _kBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(
            20,
            18,
            20,
            22 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter',
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        letterSpacing: -0.3,
                        color: _kDark,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: _kBorder, width: 1.5),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: Color(0xFF555555),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                for (final category in AudioCategory.values)
                  if (sections[category] != null)
                    _CategorySection(
                      category: category,
                      values: sections[category]!,
                    ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => context.read<AudioListBloc>().add(
                          const AudioListEvent.resetFilterDraft(),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          child: Center(
                            child: Text(
                              'Reset',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: _kMute,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: _kBorder, width: 1.5),
                            color: Colors.white,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Batal',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: _kDark,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context.read<AudioListBloc>().add(
                            const AudioListEvent.applyFilter(),
                          );
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: _kDark,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Terapkan',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: _kLime,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.category, required this.values});

  final AudioCategory category;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    final chips = values.take(5).toList();
    final hasMore = values.length > 5;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.label.toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: _kMute,
                  letterSpacing: 0.3,
                ),
              ),
              if (hasMore)
                GestureDetector(
                  onTap: () => AudioCategoryListSheet.show(context, category),
                  child: Text(
                    'Open List',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: _kGreen,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final value in chips)
                _Chip(category: category, value: value),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.category, required this.value});

  final AudioCategory category;
  final String value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioListBloc, AudioListState>(
      buildWhen: (prev, curr) =>
          prev.draftSelected[category] != curr.draftSelected[category],
      builder: (context, state) {
        final selected =
            state.draftSelected[category]?.contains(value) ?? false;
        return GestureDetector(
          onTap: () => context.read<AudioListBloc>().add(
            AudioListEvent.toggleDraftChip(category, value),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            decoration: BoxDecoration(
              color: selected ? _kDark : Colors.white,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: selected ? _kDark : _kBorder,
                width: 1.5,
              ),
            ),
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: selected ? _kLime : const Color(0xFF555555),
              ),
            ),
          ),
        );
      },
    );
  }
}
