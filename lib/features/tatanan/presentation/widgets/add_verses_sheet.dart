import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/features/muhud/domain/entities/verse_with_details_entity.dart';
import 'package:ishari/features/muhud/domain/usecases/get_verses_by_chapter.dart';
import 'package:ishari/injection_container.dart';

const _kDark = Color(0xFF111111);
const _kBorder = Color(0xFFE2E8DF);
const _kLime = Color(0xFFCAFF00);
const _kMuted = Color(0xFF777777);

class AddVersesSheet extends StatefulWidget {
  const AddVersesSheet({
    required this.chapterId,
    required this.addedVerseIds,
    required this.onConfirm,
    super.key,
  });

  final int chapterId;
  final Set<int> addedVerseIds;
  final void Function(List<int> verseIds) onConfirm;

  @override
  State<AddVersesSheet> createState() => _AddVersesSheetState();
}

class _AddVersesSheetState extends State<AddVersesSheet> {
  bool _loading = true;
  String? _error;
  List<VerseWithDetailsEntity> _verses = [];
  final Set<int> _selected = {};

  @override
  void initState() {
    super.initState();
    unawaited(_loadVerses());
  }

  Future<void> _loadVerses() async {
    final result = await sl<GetVersesByChapter>()(widget.chapterId);
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _error = failure.message;
        _loading = false;
      }),
      (verses) => setState(() {
        _verses = verses;
        _loading = false;
      }),
    );
  }

  void _submit() {
    if (_selected.isEmpty) return;
    // Return in verse_number order (top to bottom)
    final ordered = _verses
        .where((v) => _selected.contains(v.verse.id))
        .map((v) => v.verse.id)
        .toList();
    Navigator.of(context).pop();
    widget.onConfirm(ordered);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: EdgeInsets.only(bottom: bottomPad),
          child: Column(
            children: [
              // Handle
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              const SizedBox(height: 16),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      'Tambah Ayat',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: _kDark,
                      ),
                    ),
                    const Spacer(),
                    if (_selected.isNotEmpty)
                      FilledButton(
                        onPressed: _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: _kDark,
                          foregroundColor: _kLime,
                          minimumSize: const Size(0, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: Text(
                          'Tambah (${_selected.length})',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Body
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                        ? Center(
                            child: Text(
                              _error!,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: _kMuted,
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                            itemCount: _verses.length,
                            itemBuilder: (context, i) {
                              final v = _verses[i];
                              final isAdded =
                                  widget.addedVerseIds.contains(v.verse.id);
                              final isSelected = _selected.contains(v.verse.id);

                              return _VerseSelectItem(
                                verse: v,
                                isAdded: isAdded,
                                isSelected: isSelected,
                                onTap: isAdded
                                    ? null
                                    : () => setState(() {
                                          if (isSelected) {
                                            _selected.remove(v.verse.id);
                                          } else {
                                            _selected.add(v.verse.id);
                                          }
                                        }),
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

class _VerseSelectItem extends StatelessWidget {
  const _VerseSelectItem({
    required this.verse,
    required this.isAdded,
    required this.isSelected,
    this.onTap,
  });

  final VerseWithDetailsEntity verse;
  final bool isAdded;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFCAFF00).withValues(alpha: 0.25)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _kDark : _kBorder,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox area
            SizedBox(
              width: 28,
              height: 28,
              child: isAdded
                  ? const Icon(
                      Icons.check_circle,
                      size: 20,
                      color: Color(0xFFAAAAAA),
                    )
                  : Icon(
                      isSelected
                          ? Icons.check_circle_rounded
                          : Icons.circle_outlined,
                      size: 20,
                      color: isSelected ? _kDark : const Color(0xFFCCCCCC),
                    ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Opacity(
                opacity: isAdded ? 0.45 : 1.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      verse.verse.arabicText,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontFamily: 'Scheherazade',
                        fontSize: 18,
                        color: _kDark,
                        height: 1.8,
                      ),
                    ),
                    if (verse.verse.transliteration.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        verse.verse.transliteration,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: _kMuted,
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
