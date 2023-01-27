import 'package:flutter/services.dart';
import 'package:intercom_flutter_platform_interface/intercom_flutter_platform_interface.dart';
import 'package:intercom_flutter_platform_interface/intercom_status_callback.dart';

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

  @Deprecated("use loginIdentifiedUser")
  @override
  Future<void> registerIdentifiedUser({String? userId, String? email}) {
    return loginIdentifiedUser(userId: userId, email: email);
  }

  @override
  Future<void> loginIdentifiedUser({
    String? userId,
    String? email,
    IntercomStatusCallback? statusCallback,
  }) async {
    if (userId?.isNotEmpty ?? false) {
      if (email?.isNotEmpty ?? false) {
        throw ArgumentError(
            'The parameter `email` must be null if `userId` is provided.');
      }
      try {
        await _channel.invokeMethod('loginIdentifiedUserWithUserId', {
          'userId': userId,
        });
        statusCallback?.onSuccess?.call();
      } on PlatformException catch (e) {
        statusCallback?.onFailure?.call(_convertExceptionToIntercomError(e));
      }
    } else if (email?.isNotEmpty ?? false) {
      try {
        await _channel.invokeMethod('loginIdentifiedUserWithEmail', {
          'email': email,
        });
        statusCallback?.onSuccess?.call();
      } on PlatformException catch (e) {
        statusCallback?.onFailure?.call(_convertExceptionToIntercomError(e));
      }
    } else {
      throw ArgumentError(
          'An identification method must be provided as a parameter, either `userId` or `email`.');
    }
  }

  @Deprecated("use loginUnidentifiedUser")
  @override
  Future<void> registerUnidentifiedUser() {
    return loginUnidentifiedUser();
  }

  @override
  Future<void> loginUnidentifiedUser(
      {IntercomStatusCallback? statusCallback}) async {
    try {
      await _channel.invokeMethod('loginUnidentifiedUser');
      statusCallback?.onSuccess?.call();
    } on PlatformException catch (e) {
      statusCallback?.onFailure?.call(_convertExceptionToIntercomError(e));
    }
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
    IntercomStatusCallback? statusCallback,
  }) async {
    try {
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
      statusCallback?.onSuccess?.call();
    } on PlatformException catch (e) {
      statusCallback?.onFailure?.call(_convertExceptionToIntercomError(e));
    }
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
  Future<void> displayMessages() async {
    await _channel.invokeMethod('displayMessages');
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

  @override
  Future<void> displayArticle(String articleId) async {
    await _channel.invokeMethod('displayArticle', {'articleId': articleId});
  }

  @override
  Future<void> displayCarousel(String carouselId) async {
    await _channel.invokeMethod('displayCarousel', {'carouselId': carouselId});
  }

  @override
  Future<void> displaySurvey(String surveyId) async {
    await _channel.invokeMethod('displaySurvey', {'surveyId': surveyId});
  }

  /// Convert the [PlatformException] details to [IntercomError].
  /// From the Platform side if the intercom operation failed then error details
  /// will be sent as details in [PlatformException].
  IntercomError _convertExceptionToIntercomError(PlatformException e) {
    var details = e.details ?? {};

    return IntercomError(
        details['errorCode'] ?? -1, details['errorMessage'] ?? e.message ?? "");
  }
}
