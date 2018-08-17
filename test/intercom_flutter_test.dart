import 'package:intercom_flutter/intercom_flutter.dart';
import 'package:test/test.dart';

import 'test_method_channel.dart';

void main() {
  group('Intercom', () {
    setUp(() {
      setUpTestMethodChannel('app.getchange.com/intercom');
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

    test('registerIdentifiedUser', () {
      Intercom.registerIdentifiedUser('test');
      expectMethodCall('registerIdentifiedUser', arguments: {
        'userId': 'test',
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

    test('registerUnidentifiedUser', () {
      Intercom.registerUnidentifiedUser();
      expectMethodCall('registerUnidentifiedUser');
    });

    test('setLauncherVisibility - visible', () {
      Intercom.setLauncherVisibility(IntercomLauncherVisibility.visible);
      expectMethodCall('setLauncherVisibility', arguments: {
        'visibility': 'VISIBLE',
      });
    });

    test('setLauncherVisibility - gone', () {
      Intercom.setLauncherVisibility(IntercomLauncherVisibility.gone);
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
          company: 'Some Company LLC');
      expectMethodCall('updateUser', arguments: {
        'email': 'test@example.com',
        'name': 'John Doe',
        'userId': '1',
        'phone': '+37256123456',
        'company': 'Some Company LLC',
      });
    });
  });
}
