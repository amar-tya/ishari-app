import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ishari/features/muhud/domain/entities/verse_with_details_entity.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_bloc.dart';
import 'package:ishari/features/muhud/presentation/bloc/muhud_event.dart';
import 'package:ishari/features/muhud/presentation/widgets/audio_selection_sheet.dart';
import 'package:ishari/features/muhud/presentation/widgets/verse_card.dart';

class VerseList extends StatelessWidget {
  const VerseList({
    required this.verses,
    required this.bookmarkedVerseIds,
    required this.showTranslation,
    required this.showArabic,
    required this.showTransliteration,
    this.playingVerseId,
    super.key,
  });

  final List<VerseWithDetailsEntity> verses;
  final Set<int> bookmarkedVerseIds;
  final bool showTranslation;
  final bool showArabic;
  final bool showTransliteration;
  final int? playingVerseId;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: verses.length,
      itemBuilder: (_, index) {
        final verse = verses[index];
        final isBookmarked = bookmarkedVerseIds.contains(verse.verse.id);
        final isPlaying = playingVerseId == verse.verse.id;

        return VerseCard(
          verse: verse,
          isBookmarked: isBookmarked,
          isPlaying: isPlaying,
          showTranslation: showTranslation,
          showArabic: showArabic,
          showTransliteration: showTransliteration,
          onBookmarkToggle: () => context
              .read<MuhudBloc>()
              .add(MuhudEvent.toggleBookmark(verseId: verse.verse.id)),
          onPlayTap: () => _handlePlayTap(context, verse, isPlaying),
        );
      },
    );
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
