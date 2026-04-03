import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ishari/core/ads/ad_config.dart';

/// A native ad card sized to fit within the chapter masonry grid.
///
/// Renders [SizedBox.shrink] until the ad is loaded.
/// The Android layout is defined in res/layout/native_ad.xml.
class NativeAdCard extends StatefulWidget {
  const NativeAdCard({super.key});

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

    return SizedBox(
      height: 200,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF111111),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF222222)),
        ),
        child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AdWidget(ad: _ad!),
          ),
          // "Ad" label overlay — top-right corner
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFCAFF00),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Ad',
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111111),
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}
