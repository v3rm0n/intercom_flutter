import 'dart:async';

import 'package:flutter/services.dart';

class IntercomFlutter {
  static const MethodChannel _channel = const MethodChannel('intercom_flutter');

  static Future<dynamic> initialize(String appId, String apiKey) {
    return _channel
        .invokeMethod('initialize', {'appId': appId, 'apiKey': apiKey});
  }

  static Future<dynamic> registerIdentifiedUser(String userId) {
    return _channel.invokeMethod('registerIdentifiedUser', {'userId': userId});
  }

  static Future<dynamic> registerUnidentifiedUser() {
    return _channel.invokeMethod('registerUnidentifiedUser');
  }

  static Future<dynamic> logout() {
    return _channel.invokeMethod('logout');
  }

  static Future<dynamic> setLauncherVisibility(String visibility) {
    return _channel
        .invokeMethod('setLauncherVisibility', {'visibility': visibility});
  }

  static Future<dynamic> displayMessenger() {
    return _channel.invokeMethod('displayMessenger');
  }
}
