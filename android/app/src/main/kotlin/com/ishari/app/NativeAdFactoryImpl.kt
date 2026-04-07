package com.ishari.app

import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.ImageView
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
        adView.iconView = adView.findViewById<ImageView>(R.id.ad_icon)

        (adView.headlineView as TextView).text = nativeAd.headline

        nativeAd.body?.let { (adView.bodyView as TextView).text = it }
            ?: run { adView.bodyView?.visibility = View.GONE }

        nativeAd.callToAction?.let { (adView.callToActionView as Button).text = it }
            ?: run { adView.callToActionView?.visibility = View.GONE }

        nativeAd.icon?.let { (adView.iconView as ImageView).setImageDrawable(it.drawable) }
            ?: run { adView.iconView?.visibility = View.GONE }

        nativeAd.mediaContent?.let { adView.mediaView?.setMediaContent(it) }
            ?: run { adView.mediaView?.visibility = View.GONE }

        // Force a measure+layout pass so the SDK sees real MediaView dimensions
        // instead of 0×0 (which triggers the "mediaViews is too small for video" warning).
        val screenWidth = context.resources.displayMetrics.widthPixels
        adView.measure(
            View.MeasureSpec.makeMeasureSpec(screenWidth, View.MeasureSpec.AT_MOST),
            View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED),
        )
        adView.layout(0, 0, adView.measuredWidth, adView.measuredHeight)

        adView.setNativeAd(nativeAd)
        return adView
    }
}
