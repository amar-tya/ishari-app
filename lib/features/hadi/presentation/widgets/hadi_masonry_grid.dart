import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ishari/features/hadi/domain/entities/hadi_summary_entity.dart';
import 'package:ishari/features/hadi/presentation/widgets/hadi_avatar.dart';
import 'package:ishari/shared/widgets/native_ad_card.dart';

const _kDark = Color(0xFF111111);
const _kMute = Color(0xFF777777);
const _kBorder = Color(0xFFE2E8DF);

/// True 2-column masonry grid of hadi cards, following the same pattern as
/// ChapterMasonryGrid (home): hadi are split into sections of
/// [_hadiPerAd], each laid out as its own masonry (even index → left
/// column, odd → right). When ads are enabled, a full-width native ad sits
/// between sections — never as a tile inside the grid (AdMob "ads disguised
/// as content" policy).
class HadiMasonryGrid extends StatelessWidget {
  const HadiMasonryGrid({
    required this.hadiList,
    required this.audioCountFor,
    super.key,
  });

  final List<HadiSummaryEntity> hadiList;
  final int Function(String hadiId) audioCountFor;

  static const int _hadiPerAd = 4;

  @override
  Widget build(BuildContext context) {
    final withAds = hadiList.length > _hadiPerAd && NativeAdCard.isEnabled;
    final sectionSize = withAds ? _hadiPerAd : hadiList.length;

    final children = <Widget>[];
    for (var start = 0; start < hadiList.length; start += sectionSize) {
      final end = (start + sectionSize).clamp(0, hadiList.length);
      children.add(
        _MasonrySection(
          hadiList: hadiList,
          start: start,
          end: end,
          audioCountFor: audioCountFor,
        ),
      );
      if (withAds && end < hadiList.length) {
        children.add(
          const Padding(
            padding: EdgeInsets.only(top: 6, bottom: 16),
            child: NativeAdCard(),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

class _MasonrySection extends StatelessWidget {
  const _MasonrySection({
    required this.hadiList,
    required this.start,
    required this.end,
    required this.audioCountFor,
  });

  final List<HadiSummaryEntity> hadiList;
  final int start;
  final int end;
  final int Function(String hadiId) audioCountFor;

  Widget _column(int parity) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = start; i < end; i++)
          if ((i - start) % 2 == parity) ...[
            _HadiGridCard(
              hadi: hadiList[i],
              index: i,
              audioCount: audioCountFor(hadiList[i].id),
            ),
            const SizedBox(height: 10),
          ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _column(0)),
        const SizedBox(width: 10),
        Expanded(child: _column(1)),
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
