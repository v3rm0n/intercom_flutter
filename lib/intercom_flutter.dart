library intercom_flutter;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum IntercomVisibility { gone, visible }

typedef void MessageHandler(Map<String, dynamic> message);

class Intercom {
  static const MethodChannel _channel =
      const MethodChannel('maido.io/intercom');
  static MessageHandler _messageHandler;

  /// This is useful since end application don't need to store the token by itself.
  /// It will be send through message handler so application can use it in any way it wants.
  static String _iosDeviceToken;

  static Future<dynamic> initialize(String appId,
      {String androidApiKey, String iosApiKey, MessageHandler onMessage}) {
    // Backward compatibility, show new feature in debug mode.
    if (onMessage == null && !kReleaseMode) {
      _messageHandler = (data) => print("[INTERCOM_FLUTTER] On message: $data");
    }
    _messageHandler = onMessage;
    _channel.setMethodCallHandler(_handleMethod);
    return _channel.invokeMethod('initialize', {
      'appId': appId,
      'androidApiKey': androidApiKey,
      'iosApiKey': iosApiKey,
    });
  }

  /// Handle messages from native library.
  static Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'iosDeviceToken':
        String token = call.arguments;
        _iosDeviceToken = token;
        if (_messageHandler != null) {
          _messageHandler({"method": "iosDeviceToken", "token": token});
        }
        return null;
      default:
        throw UnsupportedError('Unrecognized JSON message');
    }
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

  static Future<dynamic> hideMessenger() {
    return _channel.invokeMethod('hideMessenger');
  }

  static Future<dynamic> displayHelpCenter() {
    return _channel.invokeMethod('displayHelpCenter');
  }

  static Future<dynamic> logEvent(String name,
      [Map<String, dynamic> metaData]) {
    return _channel
        .invokeMethod('logEvent', {'name': name, 'metaData': metaData});
  }

  static Future<dynamic> sendTokenToIntercom(String token) {
    print("Start sending token to Intercom");
    return _channel.invokeMethod('sendTokenToIntercom', {'token': token});
  }

  static Future<dynamic> registerIosTokenToIntercom() {
    print("[INTERCOM_FLUTTER] Start sending iOS token to Intercom");
    if (_iosDeviceToken != null) {
      return _channel
          .invokeMethod('sendTokenToIntercom', {'token': _iosDeviceToken});
    } else {
      return throw ErrorDescription("[INTERCOM_FLUTTER] No iOS Device token");
    }
  }

  static Future<String> getIosToken() {
    return Future.value(_iosDeviceToken);
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

  static Future<bool> requestIosNotificationPermissions() {
    return _channel.invokeMethod('requestNotificationPermissions');
  }
}
