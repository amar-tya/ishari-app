import 'package:flutter/material.dart';
import 'package:ishari/features/home/domain/entities/chapter_entity.dart';
import 'package:ishari/features/muhud/domain/entities/verse_with_details_entity.dart';
import 'package:ishari/features/muhud/presentation/widgets/chapter_app_bar.dart';
import 'package:ishari/features/muhud/presentation/widgets/verse_list.dart';

class ChapterReaderBody extends StatelessWidget {
  const ChapterReaderBody({
    required this.chapter,
    required this.verses,
    required this.bookmarkedVerseIds,
    required this.showTranslation,
    this.playingVerseId,
    super.key,
  });

  final ChapterEntity chapter;
  final List<VerseWithDetailsEntity> verses;
  final Set<int> bookmarkedVerseIds;
  final bool showTranslation;
  final int? playingVerseId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          ChapterAppBar(chapter: chapter, showTranslation: showTranslation),
          Expanded(
            child: VerseList(
              verses: verses,
              bookmarkedVerseIds: bookmarkedVerseIds,
              showTranslation: showTranslation,
              playingVerseId: playingVerseId,
            ),
          ),
        ],
      ),
    );
  }
}
