import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intercom_flutter_web/intercom_flutter_web.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('IntercomFlutter', () {
    late IntercomFlutterWeb plugin;

    setUp(() {
      plugin = IntercomFlutterWeb();
    });

    testWidgets("initialize", (WidgetTester _) async {
      expect(plugin.initialize("mock"), completes);
    });

    group('loginIdentifiedUser', () {
      testWidgets('with userId', (WidgetTester _) async {
        expect(plugin.loginIdentifiedUser(userId: 'test'), completes);
      });

      testWidgets('with email', (WidgetTester _) async {
        expect(plugin.loginIdentifiedUser(email: 'test'), completes);
      });

      testWidgets('with userId and email should fail', (WidgetTester _) async {
        expect(plugin.loginIdentifiedUser(userId: 'testId', email: 'testEmail'),
            throwsArgumentError);
      });

      testWidgets('without parameters', (WidgetTester _) async {
        expect(plugin.loginIdentifiedUser(), throwsArgumentError);
      });
    });

    testWidgets('loginUnidentifiedUser', (WidgetTester _) async {
      expect(plugin.loginUnidentifiedUser(), completes);
    });

    testWidgets('setBottomPadding', (WidgetTester _) async {
      expect(plugin.setBottomPadding(64), completes);
    });

    testWidgets('setUserHash', (WidgetTester _) async {
      expect(plugin.setUserHash('test'), completes);
    });

    testWidgets('logout', (WidgetTester _) async {
      expect(plugin.logout(), completes);
    });

    group('toggleMessengerVisibility', () {
      testWidgets('displayMessenger', (WidgetTester _) async {
        expect(plugin.displayMessenger(), completes);
      });

      testWidgets('hideMessenger', (WidgetTester _) async {
        expect(plugin.hideMessenger(), completes);
      });
    });

    testWidgets('displayMessages', (WidgetTester _) async {
      expect(plugin.displayMessages(), completes);
    });

    testWidgets('displayHelpCenter', (WidgetTester _) async {
      expect(plugin.displayHelpCenter(), completes);
    });

    testWidgets('displayMessageComposer', (WidgetTester _) async {
      expect(plugin.displayMessageComposer("message"), completes);
    });

    group('setLauncherVisibility', () {
      testWidgets('visible', (WidgetTester _) async {
        expect(plugin.setLauncherVisibility(IntercomVisibility.visible),
            completes);
      });

      testWidgets('gone', (WidgetTester _) async {
        expect(
            plugin.setLauncherVisibility(IntercomVisibility.gone), completes);
      });
    });

    testWidgets('updateUser', (WidgetTester _) async {
      expect(
          plugin.updateUser(
            email: 'test@example.com',
            name: 'John Doe',
            userId: '1',
            phone: '+37256123456',
            company: 'Some Company LLC',
            companyId: '2',
            signedUpAt: 1590949800,
            language: 'en',
          ),
          completes);
    });

    group('logEvent', () {
      testWidgets('withoutMetaData', (WidgetTester _) async {
        expect(plugin.logEvent("TEST"), completes);
      });

      testWidgets('withMetaData', (WidgetTester _) async {
        expect(
            plugin.logEvent(
              "TEST",
              {'string': 'A string', 'number': 10, 'bool': true},
            ),
            completes);
      });
    });

    testWidgets('testStream', (WidgetTester _) async {
      expect(plugin.getUnreadStream().first, completes);
    });

    testWidgets('displayArticle', (WidgetTester _) async {
      expect(plugin.displayArticle("123456"), completes);
    });

    testWidgets('displaySurvey', (WidgetTester _) async {
      expect(plugin.displaySurvey("123456"), completes);
    });

    testWidgets('displayConversation', (WidgetTester _) async {
      expect(plugin.displayConversation("123456"), completes);
    });

    testWidgets('displayTickets', (WidgetTester _) async {
      expect(plugin.displayTickets(), completes);
    });

    testWidgets('displayHome', (WidgetTester _) async {
      expect(plugin.displayHome(), completes);
    });

    testWidgets('isUserLoggedIn', (WidgetTester _) async {
      expect(plugin.isUserLoggedIn(), completes);
    });

    testWidgets('fetchLoggedInUserAttributes', (WidgetTester _) async {
      expect(plugin.fetchLoggedInUserAttributes(), completes);
    });
  });
}
