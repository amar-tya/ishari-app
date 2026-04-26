import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/features/muhud/domain/entities/verse_with_details_entity.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_bloc.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_event.dart';
import 'package:ishari/features/muhud/presentation/widgets/add_bookmark_sheet.dart';
import 'package:ishari/features/muhud/presentation/widgets/audio_selection_sheet.dart';
import 'package:ishari/features/muhud/presentation/widgets/verse_card.dart';

class VerseList extends StatelessWidget {
  const VerseList({
    required this.verses,
    required this.bookmarkedVerseIds,
    required this.showTranslation,
    required this.showArabic,
    required this.showTransliteration,
    required this.arabFontSize,
    required this.transliterationFontSize,
    required this.translationFontSize,
    this.playingVerseId,
    this.firstCardKey,
    super.key,
  });

  final List<VerseWithDetailsEntity> verses;
  final Set<int> bookmarkedVerseIds;
  final bool showTranslation;
  final bool showArabic;
  final bool showTransliteration;
  final double arabFontSize;
  final double transliterationFontSize;
  final double translationFontSize;
  final int? playingVerseId;
  final GlobalKey? firstCardKey;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: verses.length,
      itemBuilder: (_, index) {
        final verse = verses[index];
        final isBookmarked = bookmarkedVerseIds.contains(verse.verse.id);
        final isPlaying = playingVerseId == verse.verse.id;

        return VerseCard(
          key: index == 0 ? firstCardKey : null,
          verse: verse,
          isBookmarked: isBookmarked,
          isPlaying: isPlaying,
          showTranslation: showTranslation,
          showArabic: showArabic,
          showTransliteration: showTransliteration,
          arabFontSize: arabFontSize,
          transliterationFontSize: transliterationFontSize,
          translationFontSize: translationFontSize,
          onBookmarkToggle: () =>
              _handleBookmarkTap(context, verse, isBookmarked),
          onPlayTap: () => _handlePlayTap(context, verse, isPlaying),
        );
      },
    );
  }

  Future<void> _handleBookmarkTap(
    BuildContext context,
    VerseWithDetailsEntity verse,
    bool isBookmarked,
  ) async {
    final bloc = context.read<MuhudBloc>();

    if (isBookmarked) {
      // Langsung hapus tanpa sheet
      bloc.add(MuhudEvent.toggleBookmark(verseId: verse.verse.id));
    } else {
      // Tampilkan sheet untuk note opsional
      final note = await AddBookmarkSheet.show(context);
      if (note == null || !context.mounted) return; // user cancel
      bloc.add(
        MuhudEvent.toggleBookmark(
          verseId: verse.verse.id,
          note: note.isEmpty ? null : note,
        ),
      );
    }
  }

  Future<void> _handlePlayTap(
    BuildContext context,
    VerseWithDetailsEntity verse,
    bool isPlaying,
  ) async {
    final bloc = context.read<MuhudBloc>();

    if (isPlaying) {
      bloc.add(const MuhudEvent.stopAudio());
      return;
    }

    if (verse.mediaList.isEmpty) return;

    final result = await AudioSelectionSheet.show(context, verse);
    if (result == null || !context.mounted) return;

    bloc.add(
      MuhudEvent.playVerse(
        verseId: verse.verse.id,
        hadiId: result.hadiId,
        recitationType: result.recitationType,
        mediaId: result.mediaId,
      ),
    );
  }
}
