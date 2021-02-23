library intercom_flutter;

import 'dart:async';

import 'package:flutter/services.dart';

enum IntercomVisibility { gone, visible }

class Intercom {
  static const MethodChannel _channel =
      const MethodChannel('maido.io/intercom');
  static const EventChannel _unreadChannel =
      const EventChannel('maido.io/intercom/unread');

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

  static Stream<dynamic> getUnreadStream() {
    return _unreadChannel.receiveBroadcastStream();
  }

  /// This method allows you to set a fixed bottom padding for in app messages and the launcher.
  ///
  /// It is useful if your app has a tab bar or similar UI at the bottom of your window.
  /// [padding] is the size of the bottom padding in points.
  static Future<dynamic> setBottomPadding(int padding) {
    return _channel.invokeMethod('setBottomPadding', {'bottomPadding': padding});
  }

  static Future<dynamic> setUserHash(String userHash) {
    return _channel.invokeMethod('setUserHash', {'userHash': userHash});
  }

  static Future<dynamic> registerIdentifiedUser({String userId, String email}) {
    if (userId?.isNotEmpty ?? false) {
      if (email?.isNotEmpty ?? false) {
        throw ArgumentError(
            'The parameter `email` must be null if `userId` is provided.');
      }
      return _channel.invokeMethod('registerIdentifiedUserWithUserId', {
        'userId': userId,
      });
    } else if (email?.isNotEmpty ?? false) {
      return _channel.invokeMethod('registerIdentifiedUserWithEmail', {
        'email': email,
      });
    } else {
      throw ArgumentError(
          'An identification method must be provided as a parameter, either `userId` or `email`.');
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
    int signedUpAt,
    String lang,
    Map<String, dynamic> customAttributes,
  }) {
    return _channel.invokeMethod('updateUser', <String, dynamic>{
      'email': email,
      'name': name,
      'phone': phone,
      'company': company,
      'companyId': companyId,
      'userId': userId,
      'signedUpAt': signedUpAt,
      'lang': lang,
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

  static Future<dynamic> hideMessenger() {
    return _channel.invokeMethod('hideMessenger');
  }

  static Future<dynamic> displayHelpCenter() {
    return _channel.invokeMethod('displayHelpCenter');
  }

  static Future<dynamic> logEvent(String name,
      [Map<String, dynamic> metaData]) {
    return _channel.invokeMethod(
        'logEvent', {'name': name, 'metaData': metaData});
  }

  static Future<dynamic> sendTokenToIntercom(String token) {
    assert(token != null && token.isNotEmpty);
    print("Start sending token to Intercom");
    return _channel.invokeMethod('sendTokenToIntercom', {'token': token});
  }

  static Future<dynamic> handlePushMessage() {
    return _channel.invokeMethod('handlePushMessage');
  }

  static Future<dynamic> displayMessageComposer(String message) {
    return _channel
        .invokeMethod('displayMessageComposer', {'message': message});
  }

  static Future<bool> isIntercomPush(Map<String, dynamic> message) async {
    if (!message.values.every((item) => item is String)) {
      return false;
    }

    return await _channel
        .invokeMethod<bool>('isIntercomPush', {'message': message});
  }

  static Future<void> handlePush(Map<String, dynamic> message) async {
    if (!message.values.every((item) => item is String)) {
      throw new ArgumentError(
          'Intercom push messages can only have string values');
    }

    return await _channel
        .invokeMethod<void>('handlePush', {'message': message});
  }
}
