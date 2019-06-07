# intercom_flutter

[![Pub](https://img.shields.io/badge/Pub-2.0.3-orange.svg)](https://pub.dev/packages/intercom_flutter)
[![Codemagic build status](https://api.codemagic.io/apps/5cef7aa5a415930008ecf27b/5cef7aa5a415930008ecf27a/status_badge.svg)](https://codemagic.io/apps/5cef7aa5a415930008ecf27b/5cef7aa5a415930008ecf27a/latest_build)

Flutter wrapper for Intercom [Android](https://github.com/intercom/intercom-android) and [iOS](https://github.com/intercom/intercom-ios) projects.

## Usage

Import `package:intercom_flutter/intercom_flutter.dart` and use the methods in `Intercom` class.

Example:
```dart
import 'package:intercom_flutter/intercom_flutter.dart';

void main() async {
    await Intercom.initialize('appIdHere', iosApiKey: 'iosKeyHere', androidApiKey: 'androidKeyHere');
    runApp(App());
}

class App extends StatelessWidget {

    @override 
    Widget build(BuildContext context) {
        return FlatButton(
            child: Text('Open Intercom'),
            onPressed: () async {
                await Intercom.displayMessenger();
            },
        );
    }
}

```

See Intercom Android and iOS package documentation for more information.

### Android

Permissions:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

Optional permissions:

```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.MANAGE_DOCUMENTS"/>
```

If you get `NoClassDefFoundError`s because of missing `AppCompatActivity`, enable AndroidX + Jetifier:

```
android.useAndroidX=true
android.enableJetifier=true
```

in your `gradle.properties` file (see example app)


### iOS
Make sure that you have a `NSPhotoLibraryUsageDescription` entry in your `Info.plist`.
