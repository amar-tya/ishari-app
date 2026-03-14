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
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
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
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1C1B1F),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Ayat ${widget.verse.verse.verseNumber}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF79747E),
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
                style: TextStyle(color: Color(0xFF79747E)),
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
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF79747E),
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: hadis.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 12),
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
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected
                                ? const Color(0xFF51C878)
                                : const Color(0xFFF0F0F0),
                            border: selected
                                ? Border.all(
                                    color: const Color(0xFF51C878), width: 2)
                                : null,
                          ),
                          child: hadi.photoUrl != null
                              ? ClipOval(
                                  child: Image.network(
                                    hadi.photoUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, trace) =>
                                        _HadiInitial(
                                      name: hadi.name,
                                      selected: selected,
                                    ),
                                  ),
                                )
                              : _HadiInitial(name: hadi.name, selected: selected),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: 60,
                          child: Text(
                            hadi.name,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: selected
                                  ? const Color(0xFF51C878)
                                  : const Color(0xFF1C1B1F),
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF79747E),
                  letterSpacing: 0.8,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF51C878)
                            : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(20),
                        border: selected
                            ? null
                            : Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: Text(
                        type.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color:
                              selected ? Colors.white : const Color(0xFF1C1B1F),
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
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _canPlay
                      ? () => Navigator.of(context).pop(
                            (
                              hadiId: _selectedHadiId!,
                              recitationType: _selectedType!,
                            ),
                          )
                      : null,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text(
                    'Putar',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF51C878),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: selected ? Colors.white : const Color(0xFF51C878),
        ),
      ),
    );
  }
}
