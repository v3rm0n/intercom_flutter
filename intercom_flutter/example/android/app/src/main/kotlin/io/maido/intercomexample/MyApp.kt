package io.maido.intercomexample

import android.app.Application
import io.maido.intercom.IntercomFlutterPlugin

class MyApp : Application() {
  override fun onCreate() {
    super.onCreate()

    // Initialize the Intercom SDK here also as Android requires to initialize it in the onCreate of
    // the application.
    IntercomFlutterPlugin.initSdk(this, appId = "appId", androidApiKey = "androidApiKey")
  }
}
