import 'package:intercom_flutter/method_channel_intercom_flutter.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

enum IntercomVisibility { gone, visible }

abstract class IntercomFlutterPlatform extends PlatformInterface {
  IntercomFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static IntercomFlutterPlatform _instance = MethodChannelIntercomFlutter();

  /// The default instance of to use.
  static IntercomFlutterPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  static set instance(IntercomFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// function to initialize the Intercom SDK
  Future<dynamic> initialize(
    String appId, {
    String androidApiKey,
    String iosApiKey,
  }) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Stream<dynamic> getUnreadStream() {
    throw UnimplementedError('getUnreadStream() has not been implemented.');
  }

  Future<dynamic> setUserHash(String userHash) {
    throw UnimplementedError('setUserHash() has not been implemented.');
  }

  Future<dynamic> registerIdentifiedUser({String userId, String email}) {
    throw UnimplementedError(
        'registerIdentifiedUser() has not been implemented.');
  }

  Future<dynamic> registerUnidentifiedUser() {
    throw UnimplementedError(
        'registerUnidentifiedUser() has not been implemented.');
  }

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
    throw UnimplementedError('updateUser() has not been implemented.');
  }

  Future<dynamic> logout() {
    throw UnimplementedError('logout() has not been implemented.');
  }

  Future<dynamic> setLauncherVisibility(IntercomVisibility visibility) {
    throw UnimplementedError(
        'setLauncherVisibility() has not been implemented.');
  }

  Future<int> unreadConversationCount() {
    throw UnimplementedError(
        'unreadConversationCount() has not been implemented.');
  }

  Future<dynamic> setInAppMessagesVisibility(IntercomVisibility visibility) {
    throw UnimplementedError(
        'setInAppMessagesVisibility() has not been implemented.');
  }

  Future<dynamic> displayMessenger() {
    throw UnimplementedError('displayMessenger() has not been implemented.');
  }

  Future<dynamic> hideMessenger() {
    throw UnimplementedError('hideMessenger() has not been implemented.');
  }

  Future<dynamic> displayHelpCenter() {
    throw UnimplementedError('displayHelpCenter() has not been implemented.');
  }

  Future<dynamic> logEvent(String name, [Map<String, dynamic> metaData]) {
    throw UnimplementedError('logEvent() has not been implemented.');
  }

  Future<dynamic> sendTokenToIntercom(String token) {
    throw UnimplementedError('sendTokenToIntercom() has not been implemented.');
  }

  Future<dynamic> handlePushMessage() {
    throw UnimplementedError('handlePushMessage() has not been implemented.');
  }

  Future<dynamic> displayMessageComposer(String message) {
    throw UnimplementedError(
        'displayMessageComposer() has not been implemented.');
  }

  Future<bool> isIntercomPush(Map<String, dynamic> message) async {
    throw UnimplementedError('isIntercomPush() has not been implemented.');
  }

  Future<void> handlePush(Map<String, dynamic> message) async {
    throw UnimplementedError('handlePush() has not been implemented.');
  }
}
