import 'package:ishari/core/env/app_env.dart';

/// Central access point for AdMob Ad Unit IDs.
///
/// Values are read from [AppEnv] which in turn reads from env/current.env
/// (obfuscated via envied). Switch environments with:
///   scripts\use_dev.bat   → dev IDs
///   scripts\use_prod.bat  → production IDs
abstract final class AdConfig {
  static String get bannerUnitId => AppEnv.admobBannerUnitId;
  static String get nativeUnitId => AppEnv.admobNativeUnitId;
  static String get interstitialUnitId => AppEnv.admobInterstitialUnitId;
}
