import 'package:flutter/services.dart';
import 'package:intercom_flutter_platform_interface/intercom_flutter_platform_interface.dart';

const MethodChannel _channel = MethodChannel('maido.io/intercom');
const EventChannel _unreadChannel = EventChannel('maido.io/intercom/unread');

/// An implementation of [IntercomFlutterPlatform] that uses method channels.
class MethodChannelIntercomFlutter extends IntercomFlutterPlatform {
  @override
  Future<void> initialize(
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

  @override
  Stream<dynamic> getUnreadStream() {
    return _unreadChannel.receiveBroadcastStream();
  }

  @override
  Future<void> setUserHash(String userHash) async {
    await _channel.invokeMethod('setUserHash', {'userHash': userHash});
  }

  @override
  Future<void> registerIdentifiedUser({String? userId, String? email}) {
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
  Future<void> registerUnidentifiedUser() async {
    await _channel.invokeMethod('registerUnidentifiedUser');
  }

  @override
  Future<void> updateUser({
    String? email,
    String? name,
    String? phone,
    String? company,
    String? companyId,
    String? userId,
    int? signedUpAt,
    String? language,
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
      'language': language,
      'customAttributes': customAttributes,
    });
  }

  @override
  Future<void> logout() async {
    await _channel.invokeMethod('logout');
  }

  @override
  Future<void> setLauncherVisibility(IntercomVisibility visibility) async {
    String visibilityString =
        visibility == IntercomVisibility.visible ? 'VISIBLE' : 'GONE';
    await _channel.invokeMethod('setLauncherVisibility', {
      'visibility': visibilityString,
    });
  }

  @override
  Future<int> unreadConversationCount() async {
    final result = await _channel.invokeMethod<int>('unreadConversationCount');
    return result ?? 0;
  }

  @override
  Future<void> setInAppMessagesVisibility(IntercomVisibility visibility) async {
    String visibilityString =
        visibility == IntercomVisibility.visible ? 'VISIBLE' : 'GONE';
    await _channel.invokeMethod('setInAppMessagesVisibility', {
      'visibility': visibilityString,
    });
  }

  @override
  Future<void> displayMessenger() async {
    await _channel.invokeMethod('displayMessenger');
  }

  @override
  Future<void> hideMessenger() async {
    await _channel.invokeMethod('hideMessenger');
  }

  @override
  Future<void> displayHelpCenter() async {
    await _channel.invokeMethod('displayHelpCenter');
  }

  @override
  Future<void> logEvent(String name, [Map<String, dynamic>? metaData]) async {
    await _channel
        .invokeMethod('logEvent', {'name': name, 'metaData': metaData});
  }

  @override
  Future<void> sendTokenToIntercom(String token) async {
    assert(token.isNotEmpty);
    print("Start sending token to Intercom");
    await _channel.invokeMethod('sendTokenToIntercom', {'token': token});
  }

  @override
  Future<void> handlePushMessage() async {
    await _channel.invokeMethod('handlePushMessage');
  }

  @override
  Future<void> displayMessageComposer(String message) async {
    await _channel.invokeMethod('displayMessageComposer', {'message': message});
  }

  @override
  Future<bool> isIntercomPush(Map<String, dynamic> message) async {
    if (!message.values.every((item) => item is String)) {
      return false;
    }
    final result = await _channel
        .invokeMethod<bool>('isIntercomPush', {'message': message});
    return result ?? false;
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

  @override
  Future<void> setBottomPadding(int padding) async {
    await _channel.invokeMethod('setBottomPadding', {'bottomPadding': padding});
  }
}
