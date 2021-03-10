library intercom_flutter;

import 'dart:async';

import 'package:intercom_flutter/intercom_flutter_platform_interface.dart';

class Intercom {
  static Future<void> initialize(
    String appId, {
    String? androidApiKey,
    String? iosApiKey,
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
  static Future<void> setBottomPadding(int padding) {
    return IntercomFlutterPlatform.instance.setBottomPadding(padding);
  }

  static Future<void> setUserHash(String userHash) {
    return IntercomFlutterPlatform.instance.setUserHash(userHash);
  }

  static Future<void> registerIdentifiedUser({String? userId, String? email}) {
    return IntercomFlutterPlatform.instance
        .registerIdentifiedUser(userId: userId, email: email);
  }

  static Future<void> registerUnidentifiedUser() {
    return IntercomFlutterPlatform.instance.registerUnidentifiedUser();
  }

  /// Updates the attributes of the current Intercom user.
  ///
  /// The [language] param should be an an ISO 639-1 two-letter code such as `en` for English or `fr` for French.
  /// You’ll need to use a four-letter code for Chinese like `zh-CN`.
  /// check this link https://www.intercom.com/help/en/articles/180-localize-intercom-to-work-with-multiple-languages.
  ///
  /// See also:
  ///  * [Localize Intercom to work with multiple languages](https://www.intercom.com/help/en/articles/180-localize-intercom-to-work-with-multiple-languages)
  static Future<void> updateUser({
    String? email,
    String? name,
    String? phone,
    String? company,
    String? companyId,
    String? userId,
    int? signedUpAt,
    String? language,
    Map<String, dynamic>? customAttributes,
  }) {
    return IntercomFlutterPlatform.instance.updateUser(
      email: email,
      name: name,
      phone: phone,
      company: company,
      companyId: companyId,
      userId: userId,
      signedUpAt: signedUpAt,
      language: language,
      customAttributes: customAttributes,
    );
  }

  static Future<void> logout() {
    return IntercomFlutterPlatform.instance.logout();
  }

  static Future<void> setLauncherVisibility(IntercomVisibility visibility) {
    return IntercomFlutterPlatform.instance.setLauncherVisibility(visibility);
  }

  static Future<int> unreadConversationCount() {
    return IntercomFlutterPlatform.instance.unreadConversationCount();
  }

  static Future<void> setInAppMessagesVisibility(
      IntercomVisibility visibility) {
    return IntercomFlutterPlatform.instance
        .setInAppMessagesVisibility(visibility);
  }

  static Future<void> displayMessenger() {
    return IntercomFlutterPlatform.instance.displayMessenger();
  }

  static Future<void> hideMessenger() {
    return IntercomFlutterPlatform.instance.hideMessenger();
  }

  static Future<void> displayHelpCenter() {
    return IntercomFlutterPlatform.instance.displayHelpCenter();
  }

  static Future<void> logEvent(String name, [Map<String, dynamic>? metaData]) {
    return IntercomFlutterPlatform.instance.logEvent(name, metaData);
  }

  static Future<void> sendTokenToIntercom(String token) {
    return IntercomFlutterPlatform.instance.sendTokenToIntercom(token);
  }

  static Future<void> handlePushMessage() {
    return IntercomFlutterPlatform.instance.handlePushMessage();
  }

  static Future<void> displayMessageComposer(String message) {
    return IntercomFlutterPlatform.instance.displayMessageComposer(message);
  }

  static Future<bool> isIntercomPush(Map<String, dynamic> message) async {
    return IntercomFlutterPlatform.instance.isIntercomPush(message);
  }

  static Future<void> handlePush(Map<String, dynamic> message) async {
    return IntercomFlutterPlatform.instance.handlePush(message);
  }
}
