# intercom_flutter

Flutter wrapper for Intercom [Android](https://github.com/intercom/intercom-android) and [iOS](https://github.com/intercom/intercom-ios) projects.

## Usage

Import `package:intercom/intercom.dart` and use the methods in `Intercom` class.

Example:
```dart
import 'package:intercom/intercom.dart';

void main() {
    Intercom.initialize('appIdHere', iosApiKey: 'iosKeyHere', androidApiKey: 'androidKeyHere');
    runApp(App());
}

class App extends StatelessWidget {

    @override 
    Widget build(BuildContext context) {
        return FlatButton(child : Text('Open Intercom', onPressed: () {
            Intercom.displayMessenger();
        }));
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

### iOS
Make sure that you have a `NSPhotoLibraryUsageDescription` entry in your `Info.plist`.
