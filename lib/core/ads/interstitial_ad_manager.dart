import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ishari/core/ads/ad_config.dart';
import 'package:ishari/core/utils/app_logger.dart';

/// Singleton that manages loading and showing interstitial ads.
///
/// Shows an interstitial every [_showInterval] chapter opens.
/// Preloads the next ad immediately after one is dismissed.
class InterstitialAdManager {
  InterstitialAdManager._();

  static final InterstitialAdManager instance = InterstitialAdManager._();

  static const int _showInterval = 3;

  InterstitialAd? _ad;
  int _openCount = 0;
  bool _isLoading = false;

  /// Call once after [MobileAds.instance.initialize()] in main().
  void preload() => _loadAd();

  /// Call when the user taps a chapter.
  ///
  /// Increments the open counter. If the counter is a multiple of
  /// [_showInterval] and an ad is ready, it is shown and [onComplete] is
  /// called after dismissal. Otherwise [onComplete] is called immediately.
  void showIfReady(VoidCallback onComplete) {
    _openCount++;

    if (_openCount % _showInterval == 0 && _ad != null) {
      unawaited(_show(onComplete));
    } else {
      onComplete();
    }
  }

  void _loadAd() {
    if (_isLoading) return;
    _isLoading = true;

    unawaited(InterstitialAd.load(
      adUnitId: AdConfig.interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          _isLoading = false;
        },
        onAdFailedToLoad: (error) {
          _ad = null;
          _isLoading = false;
          appLogger.w('InterstitialAd failed to load: $error');
        },
      ),
    ));
  }

  Future<void> _show(VoidCallback onComplete) async {
    final ad = _ad;
    if (ad == null) {
      onComplete();
      return;
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (_) {
        _ad = null;
        _loadAd();
        onComplete();
      },
      onAdFailedToShowFullScreenContent: (_, _) {
        _ad = null;
        _loadAd();
        onComplete();
      },
    );

    _ad = null;
    await ad.show();
  }

  Future<void> dispose() async {
    await _ad?.dispose();
    _ad = null;
  }
}
