import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/features/audio/domain/entities/audio_category.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_list_bloc.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_list_event.dart';
import 'package:ishari/features/audio/presentation/bloc/audio_list_state.dart';

const _kDark = Color(0xFF111111);
const _kMute = Color(0xFF777777);
const _kBorder = Color(0xFFE2E8DF);
const _kLime = Color(0xFFCAFF00);
const _kBg = Color(0xFFF0F5EE);

/// "Open List" drill-down for one filter category — full checkbox list with
/// its own search, pushed as a second `showModalBottomSheet` stacked on top
/// of [AudioFilterSheet]. Selections write straight to the shared
/// [AudioListBloc]'s draftSelected via toggleDraftChip.
class AudioCategoryListSheet extends StatefulWidget {
  const AudioCategoryListSheet({required this.category, super.key});

  final AudioCategory category;

  static Future<void> show(BuildContext context, AudioCategory category) {
    final bloc = context.read<AudioListBloc>();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: bloc,
        child: AudioCategoryListSheet(category: category),
      ),
    );
  }

  @override
  State<AudioCategoryListSheet> createState() => _AudioCategoryListSheetState();
}

class _AudioCategoryListSheetState extends State<AudioCategoryListSheet> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioListBloc, AudioListState>(
      builder: (context, state) {
        final allValues =
            state.categorySubValues[widget.category] ?? const <String>[];
        final q = _query.trim().toLowerCase();
        final items = q.isEmpty
            ? allValues
            : allValues.where((v) => v.toLowerCase().contains(q)).toList();
        final selected =
            state.draftSelected[widget.category] ?? const <String>{};

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
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
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
                        Icons.arrow_back_rounded,
                        size: 18,
                        color: Color(0xFF555555),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.category.label,
                    style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      letterSpacing: -0.3,
                      color: _kDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: _kBorder, width: 1.5),
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      size: 18,
                      color: Color(0xFF555555),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onChanged: (v) => setState(() => _query = v),
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          color: _kDark,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Cari…',
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 13.5,
                            color: const Color(0xFFAAAAAA),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 11,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Flexible(
                child: items.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: Text(
                            'Tidak ditemukan.',
                            style: GoogleFonts.poppins(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: _kMute,
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: items.length,
                        separatorBuilder: (_, _) =>
                            Container(height: 1.5, color: _kBorder),
                        itemBuilder: (context, i) {
                          final value = items[i];
                          final checked = selected.contains(value);
                          return GestureDetector(
                            onTap: () => context.read<AudioListBloc>().add(
                              AudioListEvent.toggleDraftChip(
                                widget.category,
                                value,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 4,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: checked ? _kLime : Colors.white,
                                      border: Border.all(
                                        color: checked ? _kDark : _kBorder,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    alignment: Alignment.center,
                                    child: checked
                                        ? const Icon(
                                            Icons.check_rounded,
                                            size: 14,
                                            color: _kDark,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    value,
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: _kDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
