# intercom_flutter

[![Pub](https://img.shields.io/pub/v/intercom_flutter.svg)](https://pub.dev/packages/intercom_flutter)
![CI](https://github.com/v3rm0n/intercom_flutter/workflows/CI/badge.svg)

Flutter wrapper for Intercom [Android](https://github.com/intercom/intercom-android), [iOS](https://github.com/intercom/intercom-ios), and [Web](https://developers.intercom.com/installing-intercom/docs/basic-javascript) projects.

- Uses Intercom Android SDK Version `14.0.6`.
- The minimum Android SDK `minSdkVersion` required is 21.
- Uses Intercom iOS SDK Version `14.0.7`.
- The minimum iOS target version required is 13.

## Usage

Import `package:intercom_flutter/intercom_flutter.dart` and use the methods in `Intercom` class.

Example:
```dart
import 'package:flutter/material.dart';
import 'package:intercom_flutter/intercom_flutter.dart';

void main() async {
    // initialize the flutter binding.
    WidgetsFlutterBinding.ensureInitialized();
    // initialize the Intercom.
    // make sure to add keys from your Intercom workspace.
    await Intercom.instance.initialize('appIdHere', iosApiKey: 'iosKeyHere', androidApiKey: 'androidKeyHere');
    runApp(App());
}

class App extends StatelessWidget {

    @override
    Widget build(BuildContext context) {
        return FlatButton(
            child: Text('Open Intercom'),
            onPressed: () async {
                // messenger will load the messages only if the user is registered in Intercom.
                // either identified or unidentified.
                await Intercom.instance.displayMessenger();
            },
        );
    }
}

```

See Intercom [Android](https://developers.intercom.com/installing-intercom/docs/intercom-for-android) and [iOS](https://developers.intercom.com/installing-intercom/docs/intercom-for-ios) package documentation for more information.

### Android

Permissions:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

Optional permissions:

```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

Enable AndroidX + Jetifier support in your android/gradle.properties file (see example app):

```
android.useAndroidX=true
android.enableJetifier=true
```

### iOS
Make sure that you have a `NSPhotoLibraryUsageDescription` entry in your `Info.plist`.

### Push notifications setup
This plugin works in combination with the [`firebase_messaging`](https://pub.dev/packages/firebase_messaging) plugin to receive Push Notifications. To set this up:

* First, implement [`firebase_messaging`](https://pub.dev/packages/firebase_messaging)
* Then, add the Firebase server key to Intercom, as described [here](https://developers.intercom.com/installing-intercom/docs/android-fcm-push-notifications#section-step-3-add-your-server-key-to-intercom-for-android-settings) (you can skip 1 and 2 as you have probably done them while configuring `firebase_messaging`)
* Follow the steps as described [here](https://developers.intercom.com/installing-intercom/docs/ios-push-notifications) to enable push notification in iOS.
* Starting from Android 13 you may need to ask for notification permissions (as of version 13 `firebase_messaging` should support that)
* Ask FirebaseMessaging for the token that we need to send to Intercom, and give it to Intercom (so Intercom can send push messages to the correct device), please note that in order to receive push notifications in your iOS app, you have to send the APNS token to Intercom. The example below uses [`firebase_messaging`](https://pub.dev/packages/firebase_messaging) to get either the FCM or APNS token based on the platform:

```dart
final firebaseMessaging = FirebaseMessaging.instance;
final intercomToken = Platform.isIOS ? await firebaseMessaging.getAPNSToken() : await firebaseMessaging.getToken();

Intercom.instance.sendTokenToIntercom(intercomToken);
```

Now, if either Firebase direct (e.g. by your own backend server) or Intercom sends you a message, it will be delivered to your app.

### Web
Add the below script inside body tag in the index.html file located under web folder
```html
<script>
    window.intercomSettings = {
        hide_default_launcher: true, // set this to false, if you want to show the default launcher
    };
    (function(){var w=window;var ic=w.Intercom;if(typeof ic==="function"){ic('reattach_activator');ic('update',w.intercomSettings);}else{var d=document;var i=function(){i.c(arguments);};i.q=[];i.c=function(args){i.q.push(args);};w.Intercom=i;var l=function(){var s=d.createElement('script');s.type='text/javascript';s.async=true;s.src='https://widget.intercom.io/widget/';var x=d.getElementsByTagName('script')[0];x.parentNode.insertBefore(s, x);};if(document.readyState==='complete'){l();}else if(w.attachEvent){w.attachEvent('onload',l);}else{w.addEventListener('load',l,false);}}})();
</script>
```
#### Following functions are not yet supported on Web:

- [ ] unreadConversationCount
- [ ] setInAppMessagesVisibility
- [ ] displayHelpCenter
- [ ] sendTokenToIntercom
- [ ] handlePushMessage
- [ ] isIntercomPush
- [ ] handlePush
- [ ] displayCarousel
- [ ] displayHelpCenterCollections
