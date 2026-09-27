package com.ishari.app

import android.os.Bundle
import androidx.core.view.WindowCompat
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

// Extends AudioServiceActivity (not plain FlutterActivity) so this activity
// shares the same FlutterEngine as the audio_service background service —
// required by just_audio_background for lockscreen/notification controls.
class MainActivity : AudioServiceActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        WindowCompat.setDecorFitsSystemWindows(window, false)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Register native ad factory used by NativeAdCard widget
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "nativeAd",
            NativeAdFactoryImpl(context),
        )
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "nativeAd")
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
