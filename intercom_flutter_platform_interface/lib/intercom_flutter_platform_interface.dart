import 'package:intercom_flutter_platform_interface/method_channel_intercom_flutter.dart';
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
  Future<void> initialize(
    String appId, {
    String? androidApiKey,
    String? iosApiKey,
  }) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Stream<dynamic> getUnreadStream() {
    throw UnimplementedError('getUnreadStream() has not been implemented.');
  }

  Future<void> setUserHash(String userHash) {
    throw UnimplementedError('setUserHash() has not been implemented.');
  }

  Future<void> registerIdentifiedUser({String? userId, String? email}) {
    throw UnimplementedError(
        'registerIdentifiedUser() has not been implemented.');
  }

  Future<void> registerUnidentifiedUser() {
    throw UnimplementedError(
        'registerUnidentifiedUser() has not been implemented.');
  }

  /// Updates the attributes of the current Intercom user.
  ///
  /// The [language] param should be an an ISO 639-1 two-letter code such as `en` for English or `fr` for French.
  /// You’ll need to use a four-letter code for Chinese like `zh-CN`.
  /// check this link https://www.intercom.com/help/en/articles/180-localize-intercom-to-work-with-multiple-languages.
  ///
  /// See also:
  ///  * [Localize Intercom to work with multiple languages](https://www.intercom.com/help/en/articles/180-localize-intercom-to-work-with-multiple-languages)
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
  }) {
    throw UnimplementedError('updateUser() has not been implemented.');
  }

  Future<void> logout() {
    throw UnimplementedError('logout() has not been implemented.');
  }

  Future<void> setLauncherVisibility(IntercomVisibility visibility) {
    throw UnimplementedError(
        'setLauncherVisibility() has not been implemented.');
  }

  Future<int> unreadConversationCount() {
    throw UnimplementedError(
        'unreadConversationCount() has not been implemented.');
  }

  Future<void> setInAppMessagesVisibility(IntercomVisibility visibility) {
    throw UnimplementedError(
        'setInAppMessagesVisibility() has not been implemented.');
  }

  Future<void> displayMessenger() {
    throw UnimplementedError('displayMessenger() has not been implemented.');
  }

  Future<void> hideMessenger() {
    throw UnimplementedError('hideMessenger() has not been implemented.');
  }

  Future<void> displayHelpCenter() {
    throw UnimplementedError('displayHelpCenter() has not been implemented.');
  }

  Future<void> logEvent(String name, [Map<String, dynamic>? metaData]) {
    throw UnimplementedError('logEvent() has not been implemented.');
  }

  Future<void> sendTokenToIntercom(String token) {
    throw UnimplementedError('sendTokenToIntercom() has not been implemented.');
  }

  Future<void> handlePushMessage() {
    throw UnimplementedError('handlePushMessage() has not been implemented.');
  }

  Future<void> displayMessageComposer(String message) {
    throw UnimplementedError(
        'displayMessageComposer() has not been implemented.');
  }

  Future<bool> isIntercomPush(Map<String, dynamic> message) async {
    throw UnimplementedError('isIntercomPush() has not been implemented.');
  }

  Future<void> handlePush(Map<String, dynamic> message) async {
    throw UnimplementedError('handlePush() has not been implemented.');
  }

  /// This method allows you to set a fixed bottom padding for in app messages and the launcher.
  ///
  /// It is useful if your app has a tab bar or similar UI at the bottom of your window.
  /// [padding] is the size of the bottom padding in points.
  Future<void> setBottomPadding(int padding) {
    throw UnimplementedError('setBottomPadding() has not been implemented.');
  }

  /// To display an Article, pass in an [articleId] from your Intercom workspace.
  ///
  /// An article must be ‘live’ to be used in this feature.
  /// If it is in a draft or paused state,
  /// end-users will see an error if the app tries to open the content.
  Future<void> displayArticle(String articleId) {
    throw UnimplementedError('displayArticle() has not been implemented.');
  }

  /// To display a Carousel, pass in a [carouselId] from your Intercom workspace.
  ///
  /// A carousel must be ‘live’ to be used in this feature.
  /// If it is in a draft or paused state,
  /// end-users will see an error if the app tries to open the content.
  Future<void> displayCarousel(String carouselId) {
    throw UnimplementedError('displayCarousel() has not been implemented.');
  }
}
