package io.maido.intercom

import android.app.Application
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import com.google.firebase.messaging.RemoteMessage
import io.intercom.android.sdk.push.IntercomPushClient

class PushInterceptReceiver : BroadcastReceiver() {

    private val intercomPushClient = IntercomPushClient()

    override fun onReceive(context: Context?, intent: Intent?) {
        if (context == null) return

        val application = context.applicationContext as Application

        val dataBundle = intent?.extras ?: return

        val remoteMessage = RemoteMessage(dataBundle)
        val message = remoteMessage.data

        if (intercomPushClient.isIntercomPush(message)) {
            Log.d(TAG, "Intercom message received")
            intercomPushClient.handlePush(application, message)
        } else {
            Log.d(TAG, "Push message received, not for Intercom")
        }
    }

    companion object {
        private const val TAG = "PushInterceptReceiver"
    }
}
