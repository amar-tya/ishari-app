import 'package:flutter/material.dart';
import 'package:ishari/features/tatanan/domain/entities/tatanan_verse_entity.dart';
import 'package:ishari/features/tatanan/domain/repositories/tatanan_repository.dart';
import 'package:ishari/features/tatanan/presentation/bloc/tatanan_settings_cubit.dart';
import 'package:ishari/features/tatanan/presentation/widgets/tatanan_verse_item.dart';

/// Read-only list of a tatanan's verses.
class TatananVerseList extends StatelessWidget {
  const TatananVerseList({
    required this.verses,
    required this.settings,
    required this.padding,
    super.key,
  });

  final List<TatananVerseEntity> verses;
  final TatananSettingsState settings;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      itemCount: verses.length,
      itemBuilder: (context, i) => TatananVerseItem(
        key: ValueKey(verses[i].id),
        verse: verses[i],
        isEditMode: false,
        showArabic: settings.showArabic,
        showTransliteration: settings.showTransliteration,
        arabFontSize: settings.arabFontSize,
        transliterationFontSize: settings.transliterationFontSize,
      ),
    );
  }
}

/// Edit mode: drag verses into a new order or remove them.
class TatananReorderableVerseList extends StatelessWidget {
  const TatananReorderableVerseList({
    required this.verses,
    required this.settings,
    required this.onReorder,
    required this.onRemove,
    super.key,
  });

  final List<TatananVerseEntity> verses;
  final TatananSettingsState settings;

  /// Receives the new position of every verse.
  final ValueChanged<List<VersePositionUpdate>> onReorder;
  final ValueChanged<TatananVerseEntity> onRemove;

  void _reorder(int oldIndex, int newIndex) {
    final adjustedIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
    final reordered = List<TatananVerseEntity>.from(verses);
    final item = reordered.removeAt(oldIndex);
    reordered.insert(adjustedIndex, item);
    onReorder(
      reordered
          .asMap()
          .entries
          .map(
            (e) => VersePositionUpdate(
              verseId: e.value.verseId,
              position: e.key + 1,
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      itemCount: verses.length,
      onReorder: _reorder,
      itemBuilder: (context, i) {
        final verse = verses[i];
        return TatananVerseItem(
          key: ValueKey(verse.id),
          verse: verse,
          isEditMode: true,
          showArabic: settings.showArabic,
          showTransliteration: settings.showTransliteration,
          arabFontSize: settings.arabFontSize,
          transliterationFontSize: settings.transliterationFontSize,
          onRemove: () => onRemove(verse),
        );
      },
    );
  }
}
