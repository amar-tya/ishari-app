import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ishari/core/ads/ad_config.dart';
import 'package:ishari/core/feature_flags/feature_flags_service.dart';
import 'package:ishari/injection_container.dart';

/// A full-width native ad card, placed between content sections — never as
/// a tile inside a content grid (AdMob "ads disguised as content" policy).
///
/// Renders [SizedBox.shrink] until the ad is loaded.
/// The Android layout is defined in res/layout/native_ad.xml.
class NativeAdCard extends StatefulWidget {
  const NativeAdCard({super.key});

  /// Remote kill-switch for every native ad slot. Callers check this before
  /// reserving a slot so a disabled ad leaves no gap in the list.
  static bool get isEnabled =>
      sl.isRegistered<FeatureFlagsService>() &&
      sl<FeatureFlagsService>().isEnabled('feature_native_ads_enabled');

  @override
  State<NativeAdCard> createState() => _NativeAdCardState();
}

class _NativeAdCardState extends State<NativeAdCard> {
  NativeAd? _ad;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    final ad = NativeAd(
      adUnitId: AdConfig.nativeUnitId,
      factoryId: 'nativeAd',
      request: const AdRequest(),
      nativeAdOptions: NativeAdOptions(
        mediaAspectRatio: MediaAspectRatio.landscape,
        // Keep AdChoices top-right so it never overlaps the "Iklan" badge
        // rendered top-left in native_ad.xml.
        adChoicesPlacement: AdChoicesPlacement.topRightCorner,
        videoOptions: VideoOptions(
          startMuted: true,
          clickToExpandRequested: false,
          customControlsRequested: false,
        ),
      ),
      listener: NativeAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, _) => ad.dispose(),
      ),
    );
    unawaited(ad.load());
    _ad = ad;
  }

  @override
  void dispose() {
    unawaited(_ad?.dispose() ?? Future.value());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _ad == null) return const SizedBox.shrink();

    // Styling must stay visually distinct from ChapterCard (no lime/black,
    // smaller radius) — AdMob flagged the previous look as
    // "ads disguised as content". See res/layout/native_ad.xml.
    return SizedBox(
      height: 280,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFD1D5DB)),
          ),
          child: AdWidget(ad: _ad!),
        ),
      ),
    );
  }
}
