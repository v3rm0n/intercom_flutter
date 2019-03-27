library intercom_flutter;

import 'dart:async';

import 'package:flutter/services.dart';

enum IntercomVisibility { gone, visible }

class Intercom {
  static const MethodChannel _channel =
      const MethodChannel('maido.io/intercom');

  static Future<dynamic> initialize(
    String appId, {
    String androidApiKey,
    String iosApiKey,
  }) {
    return _channel.invokeMethod('initialize', {
      'appId': appId,
      'androidApiKey': androidApiKey,
      'iosApiKey': iosApiKey,
    });
  }

  static Future<dynamic> setUserHash(String userHash) {
    return _channel.invokeMethod('setUserHash', {'userHash': userHash});
  }

  static Future<dynamic> registerIdentifiedUser({String userId, String email}) {
    if (userId.isNotEmpty) {
      assert(email.isEmpty,
          'The parameter `email` must be null if `userId` is provided.');
      return _channel.invokeMethod('registerIdentifiedUser', {
        'userId': userId,
      });
    } else if (email.isNotEmpty) {
      assert(userId.isEmpty,
          'The parameter `userId` must be null if `email` is provided.');
      return _channel.invokeMethod('registerIdentifiedUser', {
        'email': email,
      });
    } else {
      assert(userId.isNotEmpty || email.isNotEmpty,
          'An identification method must be provided as a parameter, either `userId` or `email`.');
      return registerUnidentifiedUser();
    }
  }

  static Future<dynamic> registerUnidentifiedUser() {
    return _channel.invokeMethod('registerUnidentifiedUser');
  }

  static Future<dynamic> updateUser({
    String email,
    String name,
    String phone,
    String company,
    String companyId,
    String userId,
    Map<String, dynamic> customAttributes,
  }) {
    return _channel.invokeMethod('updateUser', <String, dynamic>{
      'email': email,
      'name': name,
      'phone': phone,
      'company': company,
      'companyId': companyId,
      'userId': userId,
      'customAttributes': customAttributes,
    });
  }

  static Future<dynamic> logout() {
    return _channel.invokeMethod('logout');
  }

  static Future<dynamic> setLauncherVisibility(IntercomVisibility visibility) {
    String visibilityString =
        visibility == IntercomVisibility.visible ? 'VISIBLE' : 'GONE';
    return _channel.invokeMethod('setLauncherVisibility', {
      'visibility': visibilityString,
    });
  }

  static Future<int> unreadConversationCount() {
    return _channel.invokeMethod('unreadConversationCount');
  }

  static Future<dynamic> setInAppMessagesVisibility(
      IntercomVisibility visibility) {
    String visibilityString =
        visibility == IntercomVisibility.visible ? 'VISIBLE' : 'GONE';
    return _channel.invokeMethod('setInAppMessagesVisibility', {
      'visibility': visibilityString,
    });
  }

  static Future<dynamic> displayMessenger() {
    return _channel.invokeMethod('displayMessenger');
  }

  static Future<dynamic> displayHelpCenter() {
    return _channel.invokeMethod('displayHelpCenter');
  }
}
