import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intercom_flutter/intercom_flutter.dart';

import 'test_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

    test('testSendingAPNTokenToIntercom', () {
      Intercom.sendTokenToIntercom('mock_apn_token');
      expectMethodCall('sendTokenToIntercom', arguments: {
        'token': 'mock_apn_token',
      });
    });

    group('registerIdentifiedUser', () {
      test('with userId', () {
        Intercom.registerIdentifiedUser(userId: 'test');
        expectMethodCall('registerIdentifiedUserWithUserId', arguments: {
          'userId': 'test',
        });
      });

      test('with email', () {
        Intercom.registerIdentifiedUser(email: 'test');
        expectMethodCall('registerIdentifiedUserWithEmail', arguments: {
          'email': 'test',
        });
      });

      test('with userId and email should fail', () {
        expect(
          () => Intercom.registerIdentifiedUser(
            userId: 'testId',
            email: 'testEmail',
          ),
          throwsArgumentError,
        );
      });

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

    group('toggleMessengerVisibility', () {
      test('displayMessenger', () {
        Intercom.displayMessenger();
        expectMethodCall('displayMessenger');
      });

      test('hideMessenger', () {
        Intercom.hideMessenger();
        expectMethodCall('hideMessenger');
      });
    });

    test('displayHelpCenter', () {
      Intercom.displayHelpCenter();
      expectMethodCall('displayHelpCenter');
    });

    test('unreadConversationCount', () {
      Intercom.unreadConversationCount();
      expectMethodCall('unreadConversationCount');
    });

    test('displayMessageComposer', () {
      Intercom.displayMessageComposer("message");
      expectMethodCall(
        'displayMessageComposer',
        arguments: {"message": "message"},
      );
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

  group('logEvent', () {
    test('withoutMetaData', () {
      Intercom.logEvent("TEST");
      expectMethodCall('logEvent', arguments: {
        'name': 'TEST',
        'metaData': null,
      });
    });

    test('withMetaData', () {
      Intercom.logEvent(
        "TEST",
        {'string': 'A string', 'number': 10, 'bool': true},
      );
      expectMethodCall('logEvent', arguments: {
        'name': 'TEST',
        'metaData': {'string': 'A string', 'number': 10, 'bool': true},
      });
    });
  });

  group('UnreadMessageCount', () {
    const String channelName = 'maido.io/intercom/unread';
    const MethodChannel channel = MethodChannel(channelName);
    final int value = 9;

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        ServicesBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
          channelName,
          const StandardMethodCodec().encodeSuccessEnvelope(value),
          (ByteData data) {},
        );
      });
    });

    tearDown(() {
      channel.setMockMethodCallHandler(null);
    });

    test('testStream', () async {
      expect(await Intercom.getUnreadStream().first, value);
    });
  });
}
