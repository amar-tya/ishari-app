import 'package:flutter/material.dart';
import 'package:ishari/features/home/domain/entities/hadi_entity.dart';

const _avatarColors = [
  Color(0xFF51C878),
  Color(0xFF42A5F5),
  Color(0xFFFF8A65),
  Color(0xFFAB47BC),
];

/// Vertical list of Pimpinan Shalawat (hadi) cards.
class HadiSection extends StatelessWidget {
  const HadiSection({super.key, required this.hadiList});

  final List<HadiEntity> hadiList;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Pimpinan Shalawat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1C1B1F),
                ),
              ),
              Text(
                'Lihat semua',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF51C878),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              for (int i = 0; i < hadiList.length; i++) ...[
                if (i > 0) const SizedBox(height: 12),
                _HadiItem(hadi: hadiList[i], colorIndex: i),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _HadiItem extends StatelessWidget {
  const _HadiItem({required this.hadi, required this.colorIndex});

  final HadiEntity hadi;
  final int colorIndex;

  @override
  Widget build(BuildContext context) {
    final colors = _avatarColors[colorIndex % _avatarColors.length];

    return GestureDetector(
      onTap: () {
        // TODO: navigate to HadiDetailPage
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors,
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                hadi.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1B1F),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
