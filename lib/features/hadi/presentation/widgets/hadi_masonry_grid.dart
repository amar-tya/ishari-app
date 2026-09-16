import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ishari/features/hadi/domain/entities/hadi_summary_entity.dart';
import 'package:ishari/features/hadi/presentation/widgets/hadi_avatar.dart';
import 'package:ishari/shared/widgets/native_ad_card.dart';

const _kDark = Color(0xFF111111);
const _kMute = Color(0xFF777777);
const _kBorder = Color(0xFFE2E8DF);

/// True 2-column masonry grid of hadi cards, following the same pattern as
/// ChapterMasonryGrid (home): a flat list of items — hadi interspersed with
/// an ad slot after every 4 hadi (skipped entirely when fewer than 5 hadi) —
/// distributed across left and right columns (even flat-index → left, odd →
/// right). Native ads appear as single-column items.
class HadiMasonryGrid extends StatelessWidget {
  const HadiMasonryGrid({
    required this.hadiList,
    required this.audioCountFor,
    super.key,
  });

  final List<HadiSummaryEntity> hadiList;
  final int Function(String hadiId) audioCountFor;

  @override
  Widget build(BuildContext context) {
    final items = <_GridItem>[];
    for (var i = 0; i < hadiList.length; i++) {
      items.add(_HadiItem(hadiList[i], i));
      if ((i + 1) % 4 == 0 && hadiList.length >= 5) {
        items.add(const _AdItem());
      }
    }

    final left = <_GridItem>[];
    final right = <_GridItem>[];
    for (var i = 0; i < items.length; i++) {
      if (i.isEven) {
        left.add(items[i]);
      } else {
        right.add(items[i]);
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _MasonryColumn(items: left, audioCountFor: audioCountFor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MasonryColumn(items: right, audioCountFor: audioCountFor),
        ),
      ],
    );
  }
}

sealed class _GridItem {
  const _GridItem();
}

class _HadiItem extends _GridItem {
  const _HadiItem(this.hadi, this.index);
  final HadiSummaryEntity hadi;
  final int index;
}

class _AdItem extends _GridItem {
  const _AdItem();
}

class _MasonryColumn extends StatelessWidget {
  const _MasonryColumn({
    required this.items,
    required this.audioCountFor,
  });

  final List<_GridItem> items;
  final int Function(String hadiId) audioCountFor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final item in items) ...[
          switch (item) {
            _HadiItem(:final hadi, :final index) => _HadiGridCard(
              hadi: hadi,
              index: index,
              audioCount: audioCountFor(hadi.id),
            ),
            _AdItem() => const NativeAdCard(),
          },
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _HadiGridCard extends StatelessWidget {
  const _HadiGridCard({
    required this.hadi,
    required this.index,
    required this.audioCount,
  });

  final HadiSummaryEntity hadi;
  final int index;
  final int audioCount;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/hadi/${hadi.id}'),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: _kBorder, width: 1.5),
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HadiAvatar(
              name: hadi.name,
              index: index,
              size: 56,
              photoUrl: hadi.photoUrl,
            ),
            const SizedBox(height: 12),
            Text(
              hadi.name,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13.5,
                letterSpacing: -0.2,
                color: _kDark,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            Text(
              '$audioCount audio tersedia',
              style: const TextStyle(
                fontSize: 11,
                color: _kMute,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
