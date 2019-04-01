# intercom_example

Demonstrates how to use the Intercom plugin in a Flutter project. 

## Initialize Intercom & Identify User

See example code at [lib/main.dart](lib/main.dart)

configure your app's main function as follows

```dart
void main() async {
    await Intercom.initialize('appId',
      androidApiKey: 'androidApiKey', iosApiKey: 'iosApiKey');

    await Intercom.registerIdentifiedUser(email: 'user_email@example.com'); 

    // you can also use the userId instead of email address 
    // await Intercom.registerIdentifiedUser(userId: 'intercomUserID'); 

    runApp(MyApp());
  }
```

## Display Intercom Messenger from Flutter UI Element

```dart
new FlatButton(
  onPressed: () {
    Intercom.displayMessenger();
  },
  child: Text('Show messenger')),
```

## Intercom Intstallation & Platform Configuration

[iOS Installation](https://developers.intercom.com/installing-intercom/docs/ios-installation)

[Android Installation](https://developers.intercom.com/installing-intercom/docs/android-installation)

## Getting Started with Flutter

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).
