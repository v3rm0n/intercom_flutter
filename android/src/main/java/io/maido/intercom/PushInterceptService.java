package io.maido.intercom;
import com.google.firebase.messaging.*;
import io.intercom.android.sdk.push.IntercomPushClient;
import android.util.Log;
import java.util.Map;

public class PushInterceptService extends FirebaseMessagingService {
    private static final String TAG = "PushInterceptService";
    private final IntercomPushClient intercomPushClient = new IntercomPushClient();

    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {

        super.onMessageReceived(remoteMessage);

        Map message = remoteMessage.getData();

        if (intercomPushClient.isIntercomPush(message)) {
            Log.d(TAG, "Intercom message received");
            intercomPushClient.handlePush(getApplication(), message);
        } else {
            Log.d(TAG, "Push message received, not for Intercom");
//            super.onMessageReceived(remoteMessage);
        }
    }
}