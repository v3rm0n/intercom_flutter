import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

final _log = <MethodCall>[];
final _responses = <MethodCallStubbing, dynamic>{};

var _expectCounter = 0;

void setUpTestMethodChannel(String methodChannel) {
  final channel = MethodChannel(methodChannel);
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (methodCall) async {
    _log.add(methodCall);
    final matchingStubbing =
        _responses.keys.firstWhereOrNull((s) => s.matches(methodCall));
    if (matchingStubbing != null) {
      return _responses[matchingStubbing];
    }
    return;
  });
  addTearDown(() {
    _log.clear();
    _responses.clear();
    _expectCounter = 0;
  });
}

class MethodCallStubbing {
  final Matcher nameMatcher;
  final Matcher argMatcher;

  const MethodCallStubbing(this.nameMatcher, this.argMatcher);

  void thenReturn(dynamic answer) {
    _responses[this] = answer;
  }

  bool matches(MethodCall methodCall) {
    return nameMatcher.matches(methodCall.method, {}) &&
        argMatcher.matches(methodCall.arguments, {});
  }
}

MethodCallStubbing whenMethodCall(Matcher nameMatcher, Matcher argMatcher) {
  return MethodCallStubbing(nameMatcher, argMatcher);
}

void expectMethodCall(String name, {Map<String, Object?>? arguments}) {
  expect(
    _log[_expectCounter++],
    isMethodCall(name, arguments: arguments),
  );
}
