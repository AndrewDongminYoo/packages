// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package dev.flutter.packages.interactive_media_ads

import android.content.Context
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.BinaryMessenger

/**
 * Implementation of [InteractiveMediaAdsLibraryPigeonProxyApiRegistrar] that provides each ProxyApi
 * implementation and any additional resources needed by an implementation.
 */
open class ProxyApiRegistrar(
    binaryMessenger: BinaryMessenger,
    var context: Context,
) : InteractiveMediaAdsLibraryPigeonProxyApiRegistrar(binaryMessenger) {
    // Added to be overriden for tests. The test implementation calls `callback` immediately, instead
    // of waiting for the main thread to run it.
    internal open fun runOnMainThread(callback: Runnable) {
        Handler(Looper.getMainLooper()).post { callback.run() }
    }

    override fun getPigeonApiBaseDisplayContainer(): PigeonApiBaseDisplayContainer = BaseDisplayContainerProxyApi(this)

    override fun getPigeonApiAdDisplayContainer(): PigeonApiAdDisplayContainer = AdDisplayContainerProxyApi(this)

    override fun getPigeonApiAdsLoader(): PigeonApiAdsLoader = AdsLoaderProxyApi(this)

    override fun getPigeonApiAdsManagerLoadedEvent(): PigeonApiAdsManagerLoadedEvent = AdsManagerLoadedEventProxyApi(this)

    override fun getPigeonApiAdsLoadedListener(): PigeonApiAdsLoadedListener = AdsLoadedListenerProxyApi(this)

    override fun getPigeonApiAdErrorListener(): PigeonApiAdErrorListener = AdErrorListenerProxyApi(this)

    override fun getPigeonApiAdErrorEvent(): PigeonApiAdErrorEvent = AdErrorEventProxyApi(this)

    override fun getPigeonApiAdError(): PigeonApiAdError = AdErrorProxyApi(this)

    override fun getPigeonApiAdsRequest(): PigeonApiAdsRequest = AdsRequestProxyApi(this)

    override fun getPigeonApiContentProgressProvider(): PigeonApiContentProgressProvider = ContentProgressProviderProxyApi(this)

    override fun getPigeonApiAdsManager(): PigeonApiAdsManager = AdsManagerProxyApi(this)

    override fun getPigeonApiBaseManager(): PigeonApiBaseManager = BaseManagerProxyApi(this)

    override fun getPigeonApiAdEventListener(): PigeonApiAdEventListener = AdEventListenerProxyApi(this)

    override fun getPigeonApiAdEvent(): PigeonApiAdEvent = AdEventProxyApi(this)

    override fun getPigeonApiImaSdkFactory(): PigeonApiImaSdkFactory = ImaSdkFactoryProxyApi(this)

    override fun getPigeonApiImaSdkSettings(): PigeonApiImaSdkSettings = ImaSdkSettingsProxyApi(this)

    override fun getPigeonApiVideoAdPlayer(): PigeonApiVideoAdPlayer = VideoAdPlayerProxyApi(this)

    override fun getPigeonApiVideoProgressUpdate(): PigeonApiVideoProgressUpdate = VideoProgressUpdateProxyApi(this)

    override fun getPigeonApiVideoAdPlayerCallback(): PigeonApiVideoAdPlayerCallback = VideoAdPlayerCallbackProxyApi(this)

    override fun getPigeonApiAdMediaInfo(): PigeonApiAdMediaInfo = AdMediaInfoProxyApi(this)

    override fun getPigeonApiAdPodInfo(): PigeonApiAdPodInfo = AdPodInfoProxyApi(this)

    override fun getPigeonApiFrameLayout(): PigeonApiFrameLayout = FrameLayoutProxyApi(this)

    override fun getPigeonApiViewGroup(): PigeonApiViewGroup = ViewGroupProxyApi(this)

    override fun getPigeonApiVideoView(): PigeonApiVideoView = VideoViewProxyApi(this)

    override fun getPigeonApiView(): PigeonApiView = ViewProxyApi(this)

    override fun getPigeonApiMediaPlayer(): PigeonApiMediaPlayer = MediaPlayerProxyApi(this)
}
