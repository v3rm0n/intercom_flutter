import 'package:flutter/material.dart';
import 'package:intercom_flutter/intercom_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: make sure to add keys from your Intercom workspace.
  await Intercom.instance.initialize(
    'appId',
    androidApiKey: 'androidApiKey',
    iosApiKey: 'iosApiKey',
  );
  // TODO: don't forget to set up the custom application class on Android side.
  runApp(SampleApp());
}

class SampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Intercom example app'),
        ),
        body: Center(
          child: TextButton(
            onPressed: () {
              // NOTE:
              // Messenger will load the messages only if the user is registered
              // in Intercom.
              // Either identified or unidentified.
              // So make sure to login the user in Intercom first before opening
              // the intercom messenger.
              // Otherwise messenger will not load.
              Intercom.instance.displayMessenger();
            },
            child: Text('Show messenger'),
          ),
        ),
      ),
    );
  }
}
