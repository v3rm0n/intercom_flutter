import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:intercom_flutter_platform_interface/intercom_flutter_platform_interface.dart';
import 'package:intercom_flutter_platform_interface/intercom_status_callback.dart';
import 'package:uuid/uuid.dart';
import 'package:web/web.dart' as web;

/// export the enum [IntercomVisibility]
export 'package:intercom_flutter_platform_interface/intercom_flutter_platform_interface.dart'
    show IntercomVisibility;
export 'package:intercom_flutter_platform_interface/intercom_status_callback.dart'
    show IntercomStatusCallback, IntercomError;

/// A web implementation of the IntercomFlutter plugin.
class IntercomFlutterWeb extends IntercomFlutterPlatform {
  static void registerWith(Registrar registrar) {
    IntercomFlutterPlatform.instance = IntercomFlutterWeb();
  }

  @override
  Stream<dynamic> getUnreadStream() {
    // It's fine to let the StreamController be garbage collected once all the
    // subscribers have cancelled; this analyzer warning is safe to ignore.
    // ignore: close_sinks
    StreamController<dynamic> _unreadController =
        StreamController<dynamic>.broadcast();
    _unreadController.onListen = () {
      globalContext.callMethod(
        'Intercom'.toJS,
        'onUnreadCountChange'.toJS,
        ((JSAny unreadCount) {
          _unreadController.add(unreadCount);
        }).toJS,
      );
    };
    return _unreadController.stream;
  }

  @override
  Future<void> initialize(
    String appId, {
    String? androidApiKey,
    String? iosApiKey,
  }) async {
    if (globalContext.getProperty('Intercom'.toJS) == null) {
      // Intercom script is not added yet
      // Inject it from here in the body
      web.HTMLScriptElement script =
          web.document.createElement("script") as web.HTMLScriptElement;
      script.text = """
          window.intercomSettings = ${updateIntercomSettings('app_id', "'$appId'").dartify()};
          (function(){var w=window;var ic=w.Intercom;if(typeof ic==="function"){ic('reattach_activator');ic('update',w.intercomSettings);}else{var d=document;var i=function(){i.c(arguments);};i.q=[];i.c=function(args){i.q.push(args);};w.Intercom=i;var l=function(){var s=d.createElement('script');s.type='text/javascript';s.async=true;s.src='https://widget.intercom.io/widget/' + '$appId';var x=d.getElementsByTagName('script')[0];x.parentNode.insertBefore(s, x);};if(document.readyState==='complete'){l();}else if(w.attachEvent){w.attachEvent('onload',l);}else{w.addEventListener('load',l,false);}}})();  
      """;
      if (web.document.body != null) {
        web.document.body!.appendChild(script);
      }
    } else {
      // boot the Intercom
      globalContext.callMethod(
        'Intercom'.toJS,
        'boot'.toJS,
        updateIntercomSettings('app_id', appId),
      );
    }
    print("initialized");
  }

  @override
  Future<void> setUserHash(String userHash) async {
    globalContext.callMethod(
      'Intercom'.toJS,
      'update'.toJS,
      {'user_hash': userHash}.jsify(),
    );
    print("user hash added");
  }

  @override
  Future<void> loginIdentifiedUser({
    String? userId,
    String? email,
    IntercomStatusCallback? statusCallback,
  }) async {
    if (userId?.isNotEmpty ?? false) {
      if (email?.isNotEmpty ?? false) {
        throw ArgumentError(
            'The parameter `email` must be null if `userId` is provided.');
      }
      // register the user with userId
      globalContext.callMethod(
        'Intercom'.toJS,
        'update'.toJS,
        {'user_id': userId}.jsify(),
      );
      // send the success callback only as web does not support the statusCallback.
      statusCallback?.onSuccess?.call();
    } else if (email?.isNotEmpty ?? false) {
      // register the user with email
      globalContext.callMethod(
        'Intercom'.toJS,
        'update'.toJS,
        {'email': email}.jsify(),
      );
      // send the success callback only as web does not support the statusCallback.
      statusCallback?.onSuccess?.call();
    } else {
      throw ArgumentError(
          'An identification method must be provided as a parameter, either `userId` or `email`.');
    }
  }

  @override
  Future<void> loginUnidentifiedUser(
      {IntercomStatusCallback? statusCallback}) async {
    // to register an unidentified user, a unique id will be created using the package uuid
    String userId = Uuid().v1();
    globalContext.callMethod(
      'Intercom'.toJS,
      'update'.toJS,
      {'user_id': userId}.jsify(),
    );
    // send the success callback only as web does not support the statusCallback.
    statusCallback?.onSuccess?.call();
  }

  @override
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
    IntercomStatusCallback? statusCallback,
  }) async {
    Map<String, dynamic> userAttributes = {};

    if (name != null) {
      userAttributes['name'] = name;
    }

    if (email != null) {
      userAttributes['email'] = email;
    }

    if (phone != null) {
      userAttributes['phone'] = phone;
    }

    if (userId != null) {
      userAttributes['user_id'] = userId;
    }

    if (company != null && companyId != null) {
      Map<String, dynamic> companyObj = {};
      companyObj['company_id'] = companyId;
      companyObj['name'] = company;

      userAttributes['company'] = companyObj;
    }

    if (customAttributes != null) {
      customAttributes.forEach((key, value) {
        userAttributes[key] = value;
      });
    }

    if (signedUpAt != null) {
      userAttributes['created_at'] = signedUpAt;
    }

    if (language != null) {
      userAttributes['language_override'] = language;
    }

    globalContext.callMethod(
        'Intercom'.toJS, 'update'.toJS, userAttributes.jsify());
    // send the success callback only as web does not support the statusCallback.
    statusCallback?.onSuccess?.call();
  }

  @override
  Future<void> logEvent(String name, [Map<String, dynamic>? metaData]) async {
    globalContext.callMethod(
      'Intercom'.toJS,
      'trackEvent'.toJS,
      name.toJS,
      metaData != null ? metaData.jsify() : null,
    );

    print("Logged event");
  }

  @override
  Future<void> setLauncherVisibility(IntercomVisibility visibility) async {
    globalContext.callMethod(
      'Intercom'.toJS,
      'update'.toJS,
      updateIntercomSettings(
        'hide_default_launcher',
        visibility == IntercomVisibility.visible ? false : true,
      ),
    );

    print("Showing launcher: $visibility");
  }

  @override
  Future<void> logout() async {
    globalContext.callMethod('Intercom'.toJS, 'shutdown'.toJS);
    print("logout");
  }

  @override
  Future<void> displayMessenger() async {
    globalContext.callMethod('Intercom'.toJS, 'show'.toJS);
    print("Launched");
  }

  @override
  Future<void> hideMessenger() async {
    globalContext.callMethod('Intercom'.toJS, 'hide'.toJS);
    print("Hidden");
  }

  @override
  Future<void> displayHelpCenter() async {
    globalContext.callMethod('Intercom'.toJS, 'showSpace'.toJS, 'help'.toJS);
    print("Launched the Help Center");
  }

  @override
  Future<void> displayMessageComposer(String message) async {
    globalContext.callMethod(
        'Intercom'.toJS, 'showNewMessage'.toJS, message.toJS);
    print("Message composer displayed");
  }

  @override
  Future<void> displayMessages() async {
    globalContext.callMethod('Intercom'.toJS, 'showMessages'.toJS);
    print("Launched the Messenger with the message list");
  }

  @override
  Future<void> setBottomPadding(int padding) async {
    globalContext.callMethod(
      'Intercom'.toJS,
      'update'.toJS,
      updateIntercomSettings(
        'vertical_padding',
        padding,
      ),
    );

    print("Bottom padding set");
  }

  @override
  Future<void> displayArticle(String articleId) async {
    globalContext.callMethod(
        'Intercom'.toJS, 'showArticle'.toJS, articleId.toJS);
  }

  @override
  Future<void> displaySurvey(String surveyId) async {
    globalContext.callMethod(
        'Intercom'.toJS, 'startSurvey'.toJS, surveyId.toJS);
  }

  @override
  Future<void> displayConversation(String conversationId) async {
    globalContext.callMethod(
        'Intercom'.toJS, 'showConversation'.toJS, conversationId.toJS);
  }

  @override
  Future<void> displayTickets() async {
    globalContext.callMethod('Intercom'.toJS, 'showSpace'.toJS, 'tickets'.toJS);
    print("Launched Tickets space");
  }

  /// get the [window.IntercomSettings]
  JSObject getIntercomSettings() {
    if (globalContext.hasProperty('intercomSettings'.toJS).toDart) {
      return globalContext.getProperty('intercomSettings'.toJS) as JSObject;
    }

    return JSObject();
  }

  /// add/update property to [window.IntercomSettings]
  /// and returns the updated object
  JSObject updateIntercomSettings(String key, dynamic value) {
    var intercomSettings = getIntercomSettings();
    intercomSettings[key] = value;
    return intercomSettings;
  }
}
