import 'package:flutter/services.dart';
import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:intercom_flutter/intercom_flutter_platform_interface.dart';

const MethodChannel _channel = MethodChannel('maido.io/intercom');
const EventChannel _unreadChannel = EventChannel('maido.io/intercom/unread');

/// An implementation of [IntercomFlutterPlatform] that uses method channels.
class MethodChannelIntercomFlutter extends IntercomFlutterPlatform {
  @override
  Future<dynamic> initialize(
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

  @override
  Stream<dynamic> getUnreadStream() {
    return _unreadChannel.receiveBroadcastStream();
  }

  @override
  Future<dynamic> setUserHash(String userHash) {
    return _channel.invokeMethod('setUserHash', {'userHash': userHash});
  }

  @override
  Future<dynamic> registerIdentifiedUser({String userId, String email}) {
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

  @override
  Future<dynamic> registerUnidentifiedUser() {
    return _channel.invokeMethod('registerUnidentifiedUser');
  }

  @override
  Future<dynamic> updateUser({
    String email,
    String name,
    String phone,
    String company,
    String companyId,
    String userId,
    int signedUpAt,
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
      'customAttributes': customAttributes,
    });
  }

  @override
  Future<dynamic> logout() {
    return _channel.invokeMethod('logout');
  }

  @override
  Future<dynamic> setLauncherVisibility(IntercomVisibility visibility) {
    String visibilityString =
        visibility == IntercomVisibility.visible ? 'VISIBLE' : 'GONE';
    return _channel.invokeMethod('setLauncherVisibility', {
      'visibility': visibilityString,
    });
  }

  @override
  Future<int> unreadConversationCount() {
    return _channel.invokeMethod('unreadConversationCount');
  }

  @override
  Future<dynamic> setInAppMessagesVisibility(IntercomVisibility visibility) {
    String visibilityString =
        visibility == IntercomVisibility.visible ? 'VISIBLE' : 'GONE';
    return _channel.invokeMethod('setInAppMessagesVisibility', {
      'visibility': visibilityString,
    });
  }

  @override
  Future<dynamic> displayMessenger() {
    return _channel.invokeMethod('displayMessenger');
  }

  @override
  Future<dynamic> hideMessenger() {
    return _channel.invokeMethod('hideMessenger');
  }

  @override
  Future<dynamic> displayHelpCenter() {
    return _channel.invokeMethod('displayHelpCenter');
  }

  @override
  Future<dynamic> logEvent(String name, [Map<String, dynamic> metaData]) {
    return _channel
        .invokeMethod('logEvent', {'name': name, 'metaData': metaData});
  }

  @override
  Future<dynamic> sendTokenToIntercom(String token) {
    assert(token != null && token.isNotEmpty);
    print("Start sending token to Intercom");
    return _channel.invokeMethod('sendTokenToIntercom', {'token': token});
  }

  @override
  Future<dynamic> handlePushMessage() {
    return _channel.invokeMethod('handlePushMessage');
  }

  @override
  Future<dynamic> displayMessageComposer(String message) {
    return _channel
        .invokeMethod('displayMessageComposer', {'message': message});
  }

  @override
  Future<bool> isIntercomPush(Map<String, dynamic> message) async {
    if (!message.values.every((item) => item is String)) {
      return false;
    }

    return await _channel
        .invokeMethod<bool>('isIntercomPush', {'message': message});
  }

  @override
  Future<void> handlePush(Map<String, dynamic> message) async {
    if (!message.values.every((item) => item is String)) {
      throw new ArgumentError(
          'Intercom push messages can only have string values');
    }

    return await _channel
        .invokeMethod<void>('handlePush', {'message': message});
  }
}
