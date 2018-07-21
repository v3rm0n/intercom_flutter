import 'dart:async';

import 'package:flutter/services.dart';

enum IntercomLauncherVisibility { gone, visible }

class Intercom {
  static const MethodChannel _channel = const MethodChannel('intercom_flutter');

  static Future<dynamic> initialize(String appId,
      {String androidApiKey, String iosApiKey}) {
    return _channel.invokeMethod('initialize', {
      'appId': appId,
      'androidApiKey': androidApiKey,
      'iosApiKey': iosApiKey
    });
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

  static Future<dynamic> setLauncherVisibility(
      IntercomLauncherVisibility visibility) {
    return _channel.invokeMethod(
        'setLauncherVisibility', {'visibility': visibility.toString()});
  }

  static Future<dynamic> displayMessenger() {
    return _channel.invokeMethod('displayMessenger');
  }
}
