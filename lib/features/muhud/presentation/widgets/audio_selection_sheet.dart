import 'package:flutter/material.dart';
import 'package:ishari/features/muhud/domain/entities/hadi_media_entity.dart';
import 'package:ishari/features/muhud/domain/entities/verse_media_type.dart';
import 'package:ishari/features/muhud/domain/entities/verse_with_details_entity.dart';

/// Bottom sheet untuk memilih hadi dan gaya recitation sebelum memutar audio.
class AudioSelectionSheet extends StatefulWidget {
  const AudioSelectionSheet({required this.verse, super.key});

  final VerseWithDetailsEntity verse;

  /// Shows the bottom sheet and returns `(hadiId, recitationType)` if user
  /// taps Putar, or `null` if dismissed.
  static Future<({String hadiId, VerseMediaType recitationType})?> show(
    BuildContext context,
    VerseWithDetailsEntity verse,
  ) {
    return showModalBottomSheet<({String hadiId, VerseMediaType recitationType})>(
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
  VerseMediaType? _selectedType;

  List<HadiMediaEntity> get _uniqueHadis {
    final seen = <String>{};
    return widget.verse.mediaList
        .map((m) => m.hadi)
        .where((h) => seen.add(h.id))
        .toList();
  }

  List<VerseMediaType> get _availableTypes {
    if (_selectedHadiId == null) return VerseMediaType.values;
    return widget.verse.mediaList
        .where((m) => m.hadi.id == _selectedHadiId)
        .map((m) => m.type)
        .toSet()
        .toList();
  }

  bool get _canPlay => _selectedHadiId != null && _selectedType != null;

  @override
  void initState() {
    super.initState();
    final hadis = _uniqueHadis;
    if (hadis.isNotEmpty) _selectedHadiId = hadis.first.id;
    final types = _availableTypes;
    if (types.isNotEmpty) _selectedType = types.first;
  }

  @override
  Widget build(BuildContext context) {
    final hadis = _uniqueHadis;
    final types = _availableTypes;

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
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: hadis.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) {
                  final hadi = hadis[i];
                  final selected = _selectedHadiId == hadi.id;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedHadiId = hadi.id;
                        final avail = _availableTypes;
                        if (!avail.contains(_selectedType)) {
                          _selectedType =
                              avail.isNotEmpty ? avail.first : null;
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 80,
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
                        horizontal: 8,
                        vertical: 12,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
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
                          const SizedBox(height: 8),
                          Text(
                            hadi.name,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: selected
                                  ? const Color(0xFF111111)
                                  : const Color(0xFF777777),
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
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
                children: types.map((type) {
                  final selected = _selectedType == type;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedType = type),
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
                        type.label,
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
                    ? () => Navigator.of(context).pop(
                          (
                            hadiId: _selectedHadiId!,
                            recitationType: _selectedType!,
                          ),
                        )
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
