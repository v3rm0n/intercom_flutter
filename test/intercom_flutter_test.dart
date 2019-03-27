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

      Intercom.initialize(
        appId,
        androidApiKey: androidApiKey,
        iosApiKey: iosApiKey,
      );

      expectMethodCall('initialize', arguments: {
        'appId': appId,
        'androidApiKey': androidApiKey,
        'iosApiKey': iosApiKey,
      });
    });

    group('registerIdentifiedUser', () {
      test('with userId', () {
        Intercom.registerIdentifiedUser(userId: 'test');
        expectMethodCall('registerIdentifiedUser', arguments: {
          'userId': 'test',
        });
      });

      test('with email', () {
        Intercom.registerIdentifiedUser(email: 'test');
        expectMethodCall('registerIdentifiedUser', arguments: {
          'email': 'test',
        });
      });

      test('with userId and email', () {}, skip: 'WIP');

      test('without parameters', () {
        expect(() => Intercom.registerIdentifiedUser(), throwsArgumentError);
      });
    });

    test('registerUnidentifiedUser', () {
      Intercom.registerUnidentifiedUser();
      expectMethodCall('registerUnidentifiedUser');
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

    group('setInAppMessagesVisibility', () {
      test('visible', () {
        Intercom.setInAppMessagesVisibility(IntercomVisibility.visible);
        expectMethodCall('setInAppMessagesVisibility', arguments: {
          'visibility': 'VISIBLE',
        });
      });

      test('gone', () {
        Intercom.setInAppMessagesVisibility(IntercomVisibility.gone);
        expectMethodCall('setInAppMessagesVisibility', arguments: {
          'visibility': 'GONE',
        });
      });
    });

    group('setLauncherVisibility', () {
      test('visible', () {
        Intercom.setLauncherVisibility(IntercomVisibility.visible);
        expectMethodCall('setLauncherVisibility', arguments: {
          'visibility': 'VISIBLE',
        });
      });

      test('gone', () {
        Intercom.setLauncherVisibility(IntercomVisibility.gone);
        expectMethodCall('setLauncherVisibility', arguments: {
          'visibility': 'GONE',
        });
      });
    });

    test('updateUser', () {
      Intercom.updateUser(
        email: 'test@example.com',
        name: 'John Doe',
        userId: '1',
        phone: '+37256123456',
        company: 'Some Company LLC',
        companyId: '2',
      );
      expectMethodCall('updateUser', arguments: {
        'email': 'test@example.com',
        'name': 'John Doe',
        'userId': '1',
        'phone': '+37256123456',
        'company': 'Some Company LLC',
        'companyId': '2',
        'customAttributes': null,
      });
    });
  });
}
