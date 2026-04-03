package com.ishari.app

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.widget.Button
import android.widget.TextView
import com.google.android.gms.ads.nativead.MediaView
import com.google.android.gms.ads.nativead.NativeAd
import com.google.android.gms.ads.nativead.NativeAdView
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin.NativeAdFactory

class NativeAdFactoryImpl(private val context: Context) : NativeAdFactory {

    override fun createNativeAd(
        nativeAd: NativeAd,
        customOptions: MutableMap<String, Any>?,
    ): NativeAdView {
        val adView = LayoutInflater.from(context)
            .inflate(R.layout.native_ad, null) as NativeAdView

        adView.mediaView = adView.findViewById<MediaView>(R.id.ad_media)
        adView.headlineView = adView.findViewById<TextView>(R.id.ad_headline)
        adView.bodyView = adView.findViewById<TextView>(R.id.ad_body)
        adView.callToActionView = adView.findViewById<Button>(R.id.ad_call_to_action)

        (adView.headlineView as TextView).text = nativeAd.headline
        nativeAd.body?.let { (adView.bodyView as TextView).text = it }
            ?: run { adView.bodyView?.visibility = View.INVISIBLE }
        nativeAd.callToAction?.let { (adView.callToActionView as Button).text = it }
            ?: run { adView.callToActionView?.visibility = View.INVISIBLE }
        nativeAd.icon?.let { adView.mediaView?.setMediaContent(nativeAd.mediaContent!!) }

        adView.setNativeAd(nativeAd)
        return adView
    }
}
