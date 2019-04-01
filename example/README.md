# intercom_example

Demonstrates how to use the intercom plugin in a Flutter project. 

## initialize & identify user

see example code at [lib/main.dart](lib/main.dart)

configure your app's main function as follows

        void main() async {
          await Intercom.initialize('appId',
            androidApiKey: 'androidApiKey', iosApiKey: 'iosApiKey');

          await Intercom.registerIdentifiedUser(email: 'your_intercom_user@domain.com'); 
          // you can also use intercom user name instead of email

          runApp(MyApp());
        }

## trigger from button or Flutter UI element

        FlatButton(
            child: Text('Open Intercom'),
            onPressed: () async {
              await Intercom.displayMessenger();
        }),

## intercom platform specific config

[intercom ios installation docs](https://developers.intercom.com/installing-intercom/docs/ios-installation)

[intercom android installation docs](https://developers.intercom.com/installing-intercom/docs/android-installation)

## Getting Started with Flutter

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).
