import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ishari/core/ads/ad_config.dart';
import 'package:ishari/core/utils/app_logger.dart';

/// Displays a 320×50 AdMob banner ad styled to match the app's design.
///
/// Renders [SizedBox.shrink] until the ad is loaded — no layout space wasted.
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _ad;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    final ad = BannerAd(
      adUnitId: AdConfig.bannerUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (mounted) setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          appLogger.w('BannerAd failed to load: $error');
          ad.dispose();
        },
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

    final adHeight = _ad!.size.height.toDouble();
    return SizedBox(
      height: adHeight + 12, // ad height + vertical margins
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8DF)),
        ),
        alignment: Alignment.center,
        child: SizedBox(
          width: _ad!.size.width.toDouble(),
          height: adHeight,
          child: AdWidget(ad: _ad!),
        ),
      ),
    );
  }
}
