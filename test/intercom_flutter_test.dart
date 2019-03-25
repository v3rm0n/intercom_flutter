import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:test/test.dart';

import 'test_method_channel.dart';

void main() {
  group('Intercom', () {
    setUp(() {
      setUpTestMethodChannel('maido.io/intercom');
    });

    test('initialize', () {
      final appId = 'mock';
      final androidApiKey = 'android-key';
      final iosApiKey = 'ios-key';

      Intercom.initialize(appId,
          androidApiKey: androidApiKey, iosApiKey: iosApiKey);

      expectMethodCall('initialize', arguments: {
        'appId': appId,
        'androidApiKey': androidApiKey,
        'iosApiKey': iosApiKey
      });
    });

    test('registerIdentifiedUser with userId', () {
      Intercom.registerIdentifiedUser(userId: 'test');
      expectMethodCall('registerIdentifiedUser',
          arguments: {'userId': 'test', 'email': null});
    });

    test('registerIdentifiedUser with email', () {
      Intercom.registerIdentifiedUser(email: 'test');
      expectMethodCall('registerIdentifiedUser',
          arguments: {'email': 'test', 'userId': null});
    });

    test('setUserHash', () {
      Intercom.setUserHash('test');
      expectMethodCall('setUserHash', arguments: {
        'userHash': 'test',
      });
    });

    test('logout', () {
      Intercom.logout();
      expectMethodCall('logout');
    });

    test('displayMessenger', () {
      Intercom.displayMessenger();
      expectMethodCall('displayMessenger');
    });

    test('displayHelpCenter', () {
      Intercom.displayHelpCenter();
      expectMethodCall('displayHelpCenter');
    });

    test('unreadConversationCount', () {
      Intercom.unreadConversationCount();
      expectMethodCall('unreadConversationCount');
    });

    test('setInAppMessagesVisibility - visible', () {
      Intercom.setInAppMessagesVisibility(IntercomVisibility.visible);
      expectMethodCall('setInAppMessagesVisibility', arguments: {
        'visibility': 'VISIBLE',
      });
    });

    test('setInAppMessagesVisibility - gone', () {
      Intercom.setInAppMessagesVisibility(IntercomVisibility.gone);
      expectMethodCall('setInAppMessagesVisibility', arguments: {
        'visibility': 'GONE',
      });
    });

    test('registerUnidentifiedUser', () {
      Intercom.registerUnidentifiedUser();
      expectMethodCall('registerUnidentifiedUser');
    });

    test('setLauncherVisibility - visible', () {
      Intercom.setLauncherVisibility(IntercomVisibility.visible);
      expectMethodCall('setLauncherVisibility', arguments: {
        'visibility': 'VISIBLE',
      });
    });

    test('setLauncherVisibility - gone', () {
      Intercom.setLauncherVisibility(IntercomVisibility.gone);
      expectMethodCall('setLauncherVisibility', arguments: {
        'visibility': 'GONE',
      });
    });

    test('updateUser', () {
      Intercom.updateUser(
          email: 'test@example.com',
          name: 'John Doe',
          userId: '1',
          phone: '+37256123456',
          company: 'Some Company LLC',
          companyId: '2');
      expectMethodCall('updateUser', arguments: {
        'email': 'test@example.com',
        'name': 'John Doe',
        'userId': '1',
        'phone': '+37256123456',
        'company': 'Some Company LLC',
        'companyId': '2',
        'customAttributes': null
      });
    });
  });
}
