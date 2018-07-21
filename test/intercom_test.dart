import 'package:intercom/intercom.dart';
import 'package:test/test.dart';

import 'test_method_channel.dart';

void main() {
  group('Intercom', () {
    setUp(() {
      setUpTestMethodChannel('app.getchange.com/intercom');
    });

    test('test', () {
      final appId = 'mock';
      final androidApiKey = 'android-key';
      final iosApiKey = 'ios-key';
      Intercom.initialize(appId,
          androidApiKey: androidApiKey, iosApiKey: iosApiKey);

      expectMethodCall('initialize', arguments: {});
    });
  });
}
