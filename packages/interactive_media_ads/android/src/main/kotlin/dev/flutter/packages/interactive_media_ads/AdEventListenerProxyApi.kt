// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package dev.flutter.packages.interactive_media_ads

import com.google.ads.interactivemedia.v3.api.AdEvent

/**
 * ProxyApi implementation for [AdEvent.AdEventListener].
 *
 * <p>This class may handle instantiating native object instances that are attached to a Dart
 * instance or handle method calls on the associated native class or an instance of that class.
 */
class AdEventListenerProxyApi(
    override val pigeonRegistrar: ProxyApiRegistrar,
) : PigeonApiAdEventListener(pigeonRegistrar) {
    internal class AdEventListenerImpl(
        val api: AdEventListenerProxyApi,
    ) : AdEvent.AdEventListener {
        override fun onAdEvent(event: AdEvent) {
            api.pigeonRegistrar.runOnMainThread { api.onAdEvent(this, event) {} }
        }
    }

    override fun pigeon_defaultConstructor(): AdEvent.AdEventListener = AdEventListenerImpl(this)
}
