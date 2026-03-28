import 'package:flutter/material.dart';
import 'package:ishari/features/muhud/domain/entities/hadi_media_entity.dart';
import 'package:ishari/features/muhud/domain/entities/verse_media_entity.dart';
import 'package:ishari/features/muhud/domain/entities/verse_media_type.dart';
import 'package:ishari/features/muhud/domain/entities/verse_with_details_entity.dart';

/// Bottom sheet untuk memilih hadi dan gaya recitation sebelum memutar audio.
class AudioSelectionSheet extends StatefulWidget {
  const AudioSelectionSheet({required this.verse, super.key});

  final VerseWithDetailsEntity verse;

  /// Shows the bottom sheet and returns `(hadiId, recitationType, mediaId)` if
  /// user taps Putar, or `null` if dismissed.
  static Future<
    ({String hadiId, VerseMediaType recitationType, int mediaId})?
  > show(
    BuildContext context,
    VerseWithDetailsEntity verse,
  ) {
    return showModalBottomSheet<
      ({String hadiId, VerseMediaType recitationType, int mediaId})
    >(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AudioSelectionSheet(verse: verse),
    );
  }

  @override
  State<AudioSelectionSheet> createState() => _AudioSelectionSheetState();
}

class _AudioSelectionSheetState extends State<AudioSelectionSheet> {
  String? _selectedHadiId;
  int? _selectedMediaId;

  List<HadiMediaEntity> get _uniqueHadis {
    final seen = <String>{};
    return widget.verse.mediaList
        .map((m) => m.hadi)
        .where((h) => seen.add(h.id))
        .toList();
  }

  List<VerseMediaEntity> get _availableMedia {
    if (_selectedHadiId == null) return [];
    return widget.verse.mediaList
        .where((m) => m.hadi.id == _selectedHadiId)
        .toList();
  }

  /// Returns label for a chip. Appends index number if multiple entries share
  /// the same type (e.g. "Yahum 1", "Yahum 2").
  String _mediaLabel(VerseMediaEntity media, List<VerseMediaEntity> allMedia) {
    final sameType = allMedia.where((m) => m.type == media.type).toList();
    if (sameType.length <= 1) return media.type.label;
    return '${media.type.label} ${sameType.indexOf(media) + 1}';
  }

  bool get _canPlay => _selectedHadiId != null && _selectedMediaId != null;

  @override
  void initState() {
    super.initState();
    final hadis = _uniqueHadis;
    if (hadis.isNotEmpty) _selectedHadiId = hadis.first.id;
    final media = _availableMedia;
    if (media.isNotEmpty) _selectedMediaId = media.first.id;
  }

  @override
  Widget build(BuildContext context) {
    final hadis = _uniqueHadis;
    final mediaItems = _availableMedia;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8DF),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pusat Pilihan Audio',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF111111),
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pilih bacaan untuk Bait ${widget.verse.verse.verseNumber}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF777777),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (hadis.isEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Belum ada audio untuk ayat ini.',
                style: TextStyle(color: Color(0xFF777777)),
              ),
            ),
            const SizedBox(height: 16),
          ] else ...[
            // Hadi section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'PILIH PIMPINAN HADI',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF777777),
                  letterSpacing: 0.6,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: List.generate(hadis.length, (i) {
                  final hadi = hadis[i];
                  final selected = _selectedHadiId == hadi.id;
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: i < hadis.length - 1 ? 8 : 0,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedHadiId = hadi.id;
                          final avail = _availableMedia;
                          if (!avail.any((m) => m.id == _selectedMediaId)) {
                            _selectedMediaId =
                                avail.isNotEmpty ? avail.first.id : null;
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFFF0F5EE)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: selected
                                ? const Color(0xFF111111)
                                : const Color(0xFFE2E8DF),
                            width: selected ? 2 : 1.5,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: selected
                                    ? const Color(0xFFCAFF00)
                                    : const Color(0xFFE8F0E6),
                              ),
                              child: hadi.photoUrl != null
                                  ? ClipOval(
                                      child: Image.network(
                                        hadi.photoUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            _HadiInitial(
                                          name: hadi.name,
                                          selected: selected,
                                        ),
                                      ),
                                    )
                                  : _HadiInitial(
                                      name: hadi.name,
                                      selected: selected,
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                hadi.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: selected
                                      ? const Color(0xFF111111)
                                      : const Color(0xFF555555),
                                ),
                              ),
                            ),
                            if (selected)
                              const Icon(
                                Icons.check_circle_rounded,
                                size: 18,
                                color: Color(0xFF111111),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            // Recitation style section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'GAYA BACAAN',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF777777),
                  letterSpacing: 0.6,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: mediaItems.map((media) {
                  final selected = _selectedMediaId == media.id;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedMediaId = media.id),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      height: 32,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF111111)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: selected
                              ? const Color(0xFF111111)
                              : const Color(0xFFD0D8CE),
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _mediaLabel(media, mediaItems),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: selected
                              ? Colors.white
                              : const Color(0xFF777777),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            // Play button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: _canPlay
                    ? () {
                        final selectedMedia = widget.verse.mediaList
                            .firstWhere((m) => m.id == _selectedMediaId);
                        Navigator.of(context).pop((
                          hadiId: _selectedHadiId!,
                          recitationType: selectedMedia.type,
                          mediaId: _selectedMediaId!,
                        ));
                      }
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: 52,
                  decoration: BoxDecoration(
                    color: _canPlay
                        ? const Color(0xFF111111)
                        : const Color(0xFFE2E8DF),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_arrow_rounded,
                        color: _canPlay
                            ? const Color(0xFFCAFF00)
                            : const Color(0xFFAAAAAA),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Putar',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                          color: _canPlay
                              ? const Color(0xFFCAFF00)
                              : const Color(0xFFAAAAAA),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HadiInitial extends StatelessWidget {
  const _HadiInitial({required this.name, required this.selected});

  final String name;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w900,
          color: selected ? const Color(0xFF111111) : const Color(0xFF777777),
        ),
      ),
    );
  }
}
