import 'package:flutter/material.dart';
import 'package:intercom_flutter/intercom.dart';

void main() async {
  await Intercom.initialize('appId',
      androidApiKey: 'androidApiKey', iosApiKey: 'iosApiKey');
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Intercom example app'),
        ),
        body: new Center(
          child: new FlatButton(
              onPressed: () {
                Intercom.displayMessenger();
              },
              child: Text('Show messenger')),
        ),
      ),
    );
  }
}
