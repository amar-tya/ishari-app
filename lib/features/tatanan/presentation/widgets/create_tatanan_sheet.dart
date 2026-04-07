import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/muhud/domain/usecases/get_all_chapters.dart';
import 'package:ishari/injection_container.dart';

const _kDark = Color(0xFF111111);
const _kBorder = Color(0xFFE2E8DF);
const _kLime = Color(0xFFCAFF00);
// const _kMuted = Color(0xFF777777);

class CreateTatananSheet extends StatefulWidget {
  const CreateTatananSheet({required this.onConfirm, super.key});

  final void Function({
    required int chapterId,
    required String name,
    String? description,
  }) onConfirm;

  @override
  State<CreateTatananSheet> createState() => _CreateTatananSheetState();
}

class _CreateTatananSheetState extends State<CreateTatananSheet> {
  final _nameController = TextEditingController();
  ChapterEntity? _selectedChapter;
  bool _isLoading = false;
  List<ChapterEntity> _chapters = [];
  bool _chaptersLoading = true;
  String? _chaptersError;
  // inline validation errors
  String? _nameError;
  String? _chapterError;

  @override
  void initState() {
    super.initState();
    unawaited(_loadChapters());
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadChapters() async {
    final result = await sl<GetAllChapters>()();
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _chaptersError = failure.message;
        _chaptersLoading = false;
      }),
      (chapters) => setState(() {
        // Fix 1: Only show Diwan chapters
        _chapters =
            chapters.where((c) => c.category == 'Diwan').toList();
        _chaptersLoading = false;
      }),
    );
  }

  void _submit() {
    final name = _nameController.text.trim();

    // Inline validation
    setState(() {
      _nameError = name.isEmpty ? 'Nama tatanan tidak boleh kosong' : null;
      _chapterError =
          _selectedChapter == null ? 'Chapter tidak boleh kosong' : null;
    });

    if (_nameError != null || _chapterError != null) return;

    setState(() => _isLoading = true);
    final chapterId = int.tryParse(_selectedChapter!.id) ?? 0;
    Navigator.of(context).pop();
    widget.onConfirm(chapterId: chapterId, name: name);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottomPad),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Buat Tatanan Baru',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _kDark,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Name field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _nameError != null
                    ? Colors.red.shade300
                    : _kBorder,
                width: 1.5,
              ),
            ),
            child: TextField(
              controller: _nameController,
              style: GoogleFonts.poppins(fontSize: 14, color: _kDark),
              onChanged: (_) {
                if (_nameError != null) setState(() => _nameError = null);
              },
              decoration: InputDecoration(
                hintText: 'Nama tatanan…',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFFAAAAAA),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          if (_nameError != null) ...[
            const SizedBox(height: 4),
            Text(
              _nameError!,
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.red),
            ),
          ],
          const SizedBox(height: 12),
          // Chapter picker
          Row(
            children: [
              Text(
                'Pilih Chapter Diwan',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _kDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_chaptersLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else if (_chaptersError != null)
            Text(
              _chaptersError!,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.red),
            )
          else
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _chapterError != null
                      ? Colors.red.shade300
                      : _kBorder,
                  width: 1.5,
                ),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _chapters.length,
                itemBuilder: (context, i) {
                  final chapter = _chapters[i];
                  final isSelected = _selectedChapter?.id == chapter.id;
                  return InkWell(
                    onTap: () => setState(() {
                      _selectedChapter = chapter;
                      _chapterError = null; // Fix 2: clear error on pick
                    }),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _kLime.withValues(alpha: 0.3)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              chapter.title,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: _kDark,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle_rounded,
                              size: 16,
                              color: _kDark,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          // Fix 2: inline chapter error label
          if (_chapterError != null) ...[
            const SizedBox(height: 4),
            Text(
              _chapterError!,
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.red),
            ),
          ],
          const SizedBox(height: 20),
          // Submit
          FilledButton(
            onPressed: _isLoading ? null : _submit,
            style: FilledButton.styleFrom(
              backgroundColor: _kDark,
              foregroundColor: _kLime,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: _kLime,
                    ),
                  )
                : Text(
                    'Buat',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
