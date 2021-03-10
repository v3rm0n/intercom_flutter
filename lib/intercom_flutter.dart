library intercom_flutter;

import 'dart:async';

import 'package:flutter/services.dart';

enum IntercomVisibility { gone, visible }

class Intercom {
  static const MethodChannel _channel =
      const MethodChannel('maido.io/intercom');
  static const EventChannel _unreadChannel =
      const EventChannel('maido.io/intercom/unread');

  static Future<void> initialize(
    String appId, {
    String? androidApiKey,
    String? iosApiKey,
  }) async {
    await _channel.invokeMethod('initialize', {
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
  static Future<void> setBottomPadding(int padding) async {
    await _channel.invokeMethod('setBottomPadding', {'bottomPadding': padding});
  }

  static Future<void> setUserHash(String userHash) async {
    await _channel.invokeMethod('setUserHash', {'userHash': userHash});
  }

  static Future<void> registerIdentifiedUser({String? userId, String? email}) {
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

  static Future<void> registerUnidentifiedUser() async {
    await _channel.invokeMethod('registerUnidentifiedUser');
  }

  static Future<void> updateUser({
    String? email,
    String? name,
    String? phone,
    String? company,
    String? companyId,
    String? userId,
    int? signedUpAt,
    Map<String, dynamic>? customAttributes,
  }) async {
    await _channel.invokeMethod('updateUser', <String, dynamic>{
      'email': email,
      'name': name,
      'phone': phone,
      'company': company,
      'companyId': companyId,
      'userId': userId,
      'signedUpAt': signedUpAt,
      'customAttributes': customAttributes,
    });
  }

  static Future<void> logout() async {
    await _channel.invokeMethod('logout');
  }

  static Future<void> setLauncherVisibility(
      IntercomVisibility visibility) async {
    String visibilityString =
        visibility == IntercomVisibility.visible ? 'VISIBLE' : 'GONE';
    await _channel.invokeMethod('setLauncherVisibility', {
      'visibility': visibilityString,
    });
  }

  static Future<int> unreadConversationCount() async {
    final result = await _channel.invokeMethod<int>('unreadConversationCount');
    return result ?? 0;
  }

  static Future<void> setInAppMessagesVisibility(
      IntercomVisibility visibility) async {
    String visibilityString =
        visibility == IntercomVisibility.visible ? 'VISIBLE' : 'GONE';
    await _channel.invokeMethod('setInAppMessagesVisibility', {
      'visibility': visibilityString,
    });
  }

  static Future<void> displayMessenger() async {
    await _channel.invokeMethod('displayMessenger');
  }

  static Future<void> hideMessenger() async {
    await _channel.invokeMethod('hideMessenger');
  }

  static Future<void> displayHelpCenter() async {
    await _channel.invokeMethod('displayHelpCenter');
  }

  static Future<void> logEvent(String name,
      [Map<String, dynamic>? metaData]) async {
    await _channel
        .invokeMethod('logEvent', {'name': name, 'metaData': metaData});
  }

  static Future<void> sendTokenToIntercom(String token) async {
    assert(token.isNotEmpty);
    print("Start sending token to Intercom");
    await _channel.invokeMethod('sendTokenToIntercom', {'token': token});
  }

  static Future<void> handlePushMessage() async {
    await _channel.invokeMethod('handlePushMessage');
  }

  static Future<void> displayMessageComposer(String message) async {
    await _channel.invokeMethod('displayMessageComposer', {'message': message});
  }

  static Future<bool> isIntercomPush(Map<String, dynamic> message) async {
    if (!message.values.every((item) => item is String)) {
      return false;
    }
    final result = await _channel
        .invokeMethod<bool>('isIntercomPush', {'message': message});
    return result ?? false;
  }

  static Future<void> handlePush(Map<String, dynamic> message) async {
    if (!message.values.every((item) => item is String)) {
      throw new ArgumentError(
          'Intercom push messages can only have string values');
    }

    return await _channel
        .invokeMethod<void>('handlePush', {'message': message});
  }

  /// override the language of Intercom messenger.
  ///
  /// The [language] should be an an ISO 639-1 two-letter code such as 'en' for English or 'fr' for French.
  /// You’ll need to use a four-letter code for Chinese like 'zh-CN'.
  static Future<void> overrideLanguage(String language) async {
    await _channel
        .invokeMethod<void>('overrideLanguage', {'language': language});
  }
}
