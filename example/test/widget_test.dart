import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intercom_example/main.dart';

void main() {
  testWidgets('Renders button', (WidgetTester tester) async {
    await tester.pumpWidget(App());

    expect(find.byType(FlatButton), findsOneWidget);
  });
}
