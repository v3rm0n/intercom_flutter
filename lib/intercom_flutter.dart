library intercom_flutter;

import 'dart:async';

import 'package:intercom_flutter/intercom_flutter_platform_interface.dart';

class Intercom {
  static Future<dynamic> initialize(
    String appId, {
    String androidApiKey,
    String iosApiKey,
  }) {
    return IntercomFlutterPlatform.instance
        .initialize(appId, androidApiKey: androidApiKey, iosApiKey: iosApiKey);
  }

  static Stream<dynamic> getUnreadStream() {
    return IntercomFlutterPlatform.instance.getUnreadStream();
  }
  
  /// This method allows you to set a fixed bottom padding for in app messages and the launcher.
  ///
  /// It is useful if your app has a tab bar or similar UI at the bottom of your window.
  /// [padding] is the size of the bottom padding in points.
  static Future<dynamic> setBottomPadding(int padding) {
    return _channel.invokeMethod('setBottomPadding', {'bottomPadding': padding});
  }

  static Future<dynamic> setUserHash(String userHash) {
    return IntercomFlutterPlatform.instance.setUserHash(userHash);
  }

  static Future<dynamic> registerIdentifiedUser({String userId, String email}) {
    return IntercomFlutterPlatform.instance
        .registerIdentifiedUser(userId: userId, email: email);
  }

  static Future<dynamic> registerUnidentifiedUser() {
    return IntercomFlutterPlatform.instance.registerUnidentifiedUser();
  }

  static Future<dynamic> updateUser({
    String email,
    String name,
    String phone,
    String company,
    String companyId,
    String userId,
    int signedUpAt,
    Map<String, dynamic> customAttributes,
  }) {
    return IntercomFlutterPlatform.instance.updateUser(
      email: email,
      name: name,
      phone: phone,
      company: company,
      companyId: companyId,
      userId: userId,
      signedUpAt: signedUpAt,
      customAttributes: customAttributes,
    );
  }

  static Future<dynamic> logout() {
    return IntercomFlutterPlatform.instance.logout();
  }

  static Future<dynamic> setLauncherVisibility(IntercomVisibility visibility) {
    return IntercomFlutterPlatform.instance.setLauncherVisibility(visibility);
  }

  static Future<int> unreadConversationCount() {
    return IntercomFlutterPlatform.instance.unreadConversationCount();
  }

  static Future<dynamic> setInAppMessagesVisibility(
      IntercomVisibility visibility) {
    return IntercomFlutterPlatform.instance
        .setInAppMessagesVisibility(visibility);
  }

  static Future<dynamic> displayMessenger() {
    return IntercomFlutterPlatform.instance.displayMessenger();
  }

  static Future<dynamic> hideMessenger() {
    return IntercomFlutterPlatform.instance.hideMessenger();
  }

  static Future<dynamic> displayHelpCenter() {
    return IntercomFlutterPlatform.instance.displayHelpCenter();
  }

  static Future<dynamic> logEvent(String name,
      [Map<String, dynamic> metaData]) {
    return IntercomFlutterPlatform.instance.logEvent(name, metaData);
  }

  static Future<dynamic> sendTokenToIntercom(String token) {
    return IntercomFlutterPlatform.instance.sendTokenToIntercom(token);
  }

  static Future<dynamic> handlePushMessage() {
    return IntercomFlutterPlatform.instance.handlePushMessage();
  }

  static Future<dynamic> displayMessageComposer(String message) {
    return IntercomFlutterPlatform.instance.displayMessageComposer(message);
  }

  static Future<bool> isIntercomPush(Map<String, dynamic> message) async {
    return IntercomFlutterPlatform.instance.isIntercomPush(message);
  }

  static Future<void> handlePush(Map<String, dynamic> message) async {
    return IntercomFlutterPlatform.instance.handlePush(message);
  }
}
