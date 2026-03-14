import 'package:flutter/material.dart';
import 'package:ishari/features/home/domain/entities/hadi_entity.dart';

const _avatarColors = [
  [Color(0xFF51C878), Color(0xFF3DA85F)],
  [Color(0xFF42A5F5), Color(0xFF1E88E5)],
  [Color(0xFFFF8A65), Color(0xFFF4511E)],
  [Color(0xFFAB47BC), Color(0xFF8E24AA)],
];

/// Horizontally scrollable row of Pimpinan Shalawat (hadi) avatars.
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
          child: Row(
            children: List.generate(hadiList.length, (i) {
              final hadi = hadiList[i];
              return Expanded(child: _HadiItem(hadi: hadi, colorIndex: i));
            }),
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
    final firstLetter = hadi.name.isNotEmpty ? hadi.name[0].toUpperCase() : '?';

    return GestureDetector(
      onTap: () {
        // TODO: navigate to HadiDetailPage
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: hadi.photoUrl != null
                ? CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(hadi.photoUrl!),
                  )
                : Center(
                    child: Text(
                      firstLetter,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 6),
          Text(
            hadi.name,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF49454F),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
