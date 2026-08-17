import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/kitab/domain/usecases/get_chapters_by_book.dart';
import 'package:ishari/features/kitab/domain/usecases/get_pages_by_chapter.dart';
import 'package:ishari/features/kitab/presentation/bloc/book_chapters_cubit.dart';
import 'package:ishari/features/kitab/presentation/bloc/kitab_page_reader_cubit.dart';
import 'package:ishari/injection_container.dart';

const _kDark = Color(0xFF111111);
const _kLime = Color(0xFFCAFF00);
const _kMuted = Color(0xFF777777);
const _kBorder = Color(0xFFE2E8DF);

/// Per-halaman reader: swipeable pre-rendered page images for a Kitab
/// chapter (`book_pages`), the mushaf-style counterpart to the existing
/// per-ayat [ChapterReaderPage]. Background is plain white to match the
/// page images themselves (no visible frame around the mushaf page).
///
/// When [bookId] is available, the app bar shows a chapter-name dropdown
/// so the user can jump to another chapter of the same book without
/// leaving this page.
class KitabPageReaderPage extends StatefulWidget {
  const KitabPageReaderPage({required this.chapterId, this.bookId, super.key});

  static const routePath = '/kitab-page/:chapterId';

  final int chapterId;
  final int? bookId;

  @override
  State<KitabPageReaderPage> createState() => _KitabPageReaderPageState();
}

class _KitabPageReaderPageState extends State<KitabPageReaderPage> {
  late final KitabPageReaderCubit _readerCubit;
  BookChaptersCubit? _chaptersCubit;
  final _pageController = PageController();
  late int _currentChapterId;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentChapterId = widget.chapterId;
    _readerCubit = KitabPageReaderCubit(
      getPagesByChapter: sl<GetPagesByChapter>(),
    )..load(_currentChapterId);
    if (widget.bookId != null) {
      _chaptersCubit = BookChaptersCubit(
        getChaptersByBook: sl<GetChaptersByBook>(),
      )..load(widget.bookId!);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _readerCubit.close();
    _chaptersCubit?.close();
    super.dispose();
  }

  void _goToPage(int index) {
    unawaited(
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      ),
    );
  }

  void _switchChapter(ChapterEntity chapter) {
    final id = int.tryParse(chapter.id);
    if (id == null || id == _currentChapterId) return;
    setState(() {
      _currentChapterId = id;
      _currentPage = 0;
    });
    _readerCubit.load(id);
    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _readerCubit),
        if (_chaptersCubit != null) BlocProvider.value(value: _chaptersCubit!),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Row(
                  children: [
                    _IconBtn(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => context.pop(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _chaptersCubit == null
                          ? const SizedBox.shrink()
                          : BlocBuilder<BookChaptersCubit, BookChaptersState>(
                              builder: (context, state) {
                                if (state is! BookChaptersLoaded) {
                                  return const SizedBox.shrink();
                                }
                                return _ChapterDropdown(
                                  chapters: state.chapters,
                                  currentChapterId: _currentChapterId,
                                  onSelected: _switchChapter,
                                );
                              },
                            ),
                    ),
                    const SizedBox(width: 8),
                    BlocBuilder<KitabPageReaderCubit, KitabPageReaderState>(
                      builder: (context, state) {
                        if (state is! KitabPageReaderLoaded ||
                            state.pages.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return _PageBadge(
                          current: _currentPage + 1,
                          total: state.pages.length,
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child:
                    BlocBuilder<KitabPageReaderCubit, KitabPageReaderState>(
                  builder: (context, state) {
                    return switch (state) {
                      KitabPageReaderInitial() ||
                      KitabPageReaderLoading() => const Center(
                        child: CircularProgressIndicator(color: _kLime),
                      ),
                      KitabPageReaderError(:final message) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            message,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSans(color: _kMuted),
                          ),
                        ),
                      ),
                      KitabPageReaderLoaded(:final pages) when pages.isEmpty =>
                        Center(
                          child: Text(
                            'Halaman belum tersedia untuk bab ini.',
                            style: GoogleFonts.dmSans(color: _kMuted),
                          ),
                        ),
                      KitabPageReaderLoaded(:final pages) => PageView.builder(
                        key: ValueKey(_currentChapterId),
                        controller: _pageController,
                        itemCount: pages.length,
                        onPageChanged: (i) => setState(() => _currentPage = i),
                        itemBuilder: (context, index) {
                          final page = pages[index];
                          return InteractiveViewer(
                            minScale: 1,
                            maxScale: 4,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Image.network(
                                page.imageUrl,
                                fit: BoxFit.contain,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) =>
                                    Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.broken_image_outlined,
                                            size: 48,
                                            color: _kMuted,
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            'Gagal memuat halaman '
                                            '${page.pageNumber}',
                                            style: GoogleFonts.dmSans(
                                              color: _kMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: _kLime,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    };
                  },
                ),
              ),
              BlocBuilder<KitabPageReaderCubit, KitabPageReaderState>(
                builder: (context, state) {
                  if (state is! KitabPageReaderLoaded ||
                      state.pages.length < 2) {
                    return const SizedBox.shrink();
                  }
                  return _BottomPageNav(
                    current: _currentPage,
                    total: state.pages.length,
                    onPrev: _currentPage > 0
                        ? () => _goToPage(_currentPage - 1)
                        : null,
                    onNext: _currentPage < state.pages.length - 1
                        ? () => _goToPage(_currentPage + 1)
                        : null,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChapterDropdown extends StatelessWidget {
  const _ChapterDropdown({
    required this.chapters,
    required this.currentChapterId,
    required this.onSelected,
  });

  final List<ChapterEntity> chapters;
  final int currentChapterId;
  final ValueChanged<ChapterEntity> onSelected;

  @override
  Widget build(BuildContext context) {
    final current = chapters.firstWhere(
      (c) => c.id == currentChapterId.toString(),
      orElse: () => chapters.first,
    );
    return GestureDetector(
      onTap: () => _showChapterSheet(context),
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(19),
          border: Border.all(color: _kBorder, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                current.title,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _kDark,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 18,
              color: _kDark,
            ),
          ],
        ),
      ),
    );
  }

  void _showChapterSheet(BuildContext context) {
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => _ChapterSwitchSheet(
          chapters: chapters,
          currentChapterId: currentChapterId,
          onSelected: onSelected,
        ),
      ),
    );
  }
}

class _ChapterSwitchSheet extends StatelessWidget {
  const _ChapterSwitchSheet({
    required this.chapters,
    required this.currentChapterId,
    required this.onSelected,
  });

  final List<ChapterEntity> chapters;
  final int currentChapterId;
  final ValueChanged<ChapterEntity> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pindah Bab',
                style: GoogleFonts.dmSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: _kDark,
                ),
              ),
            ),
          ),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              itemCount: chapters.length,
              separatorBuilder: (_, _) => const SizedBox(height: 2),
              itemBuilder: (context, index) {
                final chapter = chapters[index];
                final isActive =
                    chapter.id == currentChapterId.toString();
                return Material(
                  color: isActive ? _kLime.withValues(alpha: 0.18) : null,
                  borderRadius: BorderRadius.circular(12),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      onSelected(chapter);
                    },
                    title: Text(
                      chapter.title,
                      style: GoogleFonts.dmSans(
                        fontWeight: FontWeight.w700,
                        color: _kDark,
                      ),
                    ),
                    subtitle: Text(
                      '${chapter.category} — ${chapter.verseCount} ayat',
                      style: GoogleFonts.dmSans(fontSize: 12, color: _kMuted),
                    ),
                    trailing: isActive
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: _kDark,
                            size: 20,
                          )
                        : const Icon(
                            Icons.chevron_right_rounded,
                            color: _kMuted,
                          ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
        ],
      ),
    );
  }
}

class _BottomPageNav extends StatelessWidget {
  const _BottomPageNav({
    required this.current,
    required this.total,
    required this.onPrev,
    required this.onNext,
  });

  final int current;
  final int total;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        4,
        16,
        MediaQuery.of(context).padding.bottom > 0 ? 4 : 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _NavIconBtn(
            icon: Icons.chevron_left_rounded,
            onTap: onPrev,
          ),
          const SizedBox(width: 16),
          Container(
            width: 72,
            height: 34,
            decoration: BoxDecoration(
              color: _kDark,
              borderRadius: BorderRadius.circular(17),
            ),
            alignment: Alignment.center,
            child: Text(
              '${current + 1} / $total',
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _kLime,
              ),
            ),
          ),
          const SizedBox(width: 16),
          _NavIconBtn(
            icon: Icons.chevron_right_rounded,
            onTap: onNext,
          ),
        ],
      ),
    );
  }
}

class _NavIconBtn extends StatelessWidget {
  const _NavIconBtn({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: enabled ? _kDark : Colors.white,
          shape: BoxShape.circle,
          border: enabled ? null : Border.all(color: _kBorder, width: 1.5),
        ),
        child: Icon(
          icon,
          color: enabled ? _kLime : _kMuted,
          size: 26,
        ),
      ),
    );
  }
}

class _PageBadge extends StatelessWidget {
  const _PageBadge({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: _kDark,
        borderRadius: BorderRadius.circular(17),
      ),
      alignment: Alignment.center,
      child: Text(
        '$current / $total',
        style: GoogleFonts.dmSans(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: _kLime,
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: _kBorder, width: 1.5),
        ),
        child: Icon(icon, color: _kDark, size: 18),
      ),
    );
  }
}
