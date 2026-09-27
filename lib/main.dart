import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ishari/core/app_loader.dart';
import 'package:ishari/core/env/app_env.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  // Must run before any AudioPlayer is constructed (GetIt lazily builds one
  // on first use) — it swaps just_audio's platform bridge so every player
  // gets a background service + lockscreen/notification media controls.
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ishari.app.audio_playback',
    androidNotificationChannelName: 'Pemutaran Audio',
  );
  final packageInfo = await PackageInfo.fromPlatform();

  await SentryFlutter.init(
    (options) {
      options
        ..dsn = AppEnv.sentryDsn
        ..release = '${packageInfo.version}+${packageInfo.buildNumber}'
        ..environment = AppEnv.isDevelopment ? 'development' : 'production'
        ..tracesSampleRate = AppEnv.isProduction ? 0.2 : 0.0
        ..enableTombstone = true;
    },
    appRunner: () => runApp(const AppLoader()),
  );
}
