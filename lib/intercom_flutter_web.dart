import 'dart:async';
import 'dart:js' as js;

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:intercom_flutter/intercom_flutter_platform_interface.dart';
import 'package:uuid/uuid.dart';

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
      js.context.callMethod('Intercom', [
        'onUnreadCountChange',
        js.allowInterop((unreadCount) {
          _unreadController.add(unreadCount);
        }),
      ]);
    };
    return _unreadController.stream;
  }

  @override
  Future<dynamic> initialize(
    String appId, {
    String androidApiKey,
    String iosApiKey,
  }) async {
    js.context.callMethod('Intercom', [
      'boot',
      js.JsObject.jsify({
        'app_id': appId,
      }),
    ]);
    return "initialized";
  }

  @override
  Future<dynamic> setUserHash(String userHash) async {
    if (userHash != null) {
      js.context.callMethod('Intercom', [
        'update',
        js.JsObject.jsify({
          'user_hash': userHash,
        }),
      ]);
      return "user hash added";
    }
  }

  @override
  Future<dynamic> registerIdentifiedUser({String userId, String email}) async {
    if (userId?.isNotEmpty ?? false) {
      if (email?.isNotEmpty ?? false) {
        throw ArgumentError(
            'The parameter `email` must be null if `userId` is provided.');
      }
      // register the user with userId
      js.context.callMethod('Intercom', [
        'update',
        js.JsObject.jsify({
          'user_id': userId,
        }),
      ]);
      return "user created";
    } else if (email?.isNotEmpty ?? false) {
      // register the user with email
      js.context.callMethod('Intercom', [
        'update',
        js.JsObject.jsify({
          'email': email,
        }),
      ]);
      return "user created";
    } else {
      throw ArgumentError(
          'An identification method must be provided as a parameter, either `userId` or `email`.');
    }
  }

  @override
  Future<dynamic> registerUnidentifiedUser() async {
    // to register an unidentified user, a unique id will be created using the package uuid
    String userId = Uuid().v1();
    if (userId != null) {
      js.context.callMethod('Intercom', [
        'update',
        js.JsObject.jsify({
          'user_id': userId,
        }),
      ]);
      return "user created";
    }
  }

  @override
  Future<dynamic> updateUser({
    String email,
    String name,
    String phone,
    String company,
    String companyId,
    String userId,
    int signedUpAt,
    Map<String, dynamic> customAttributes,
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

    js.context.callMethod('Intercom', [
      'update',
      js.JsObject.jsify(userAttributes),
    ]);
    return "User updated";
  }

  @override
  Future<dynamic> logEvent(String name, [Map<String, dynamic> metaData]) async {
    if (name != null) {
      js.context.callMethod('Intercom', [
        'trackEvent',
        name,
        metaData != null ? js.JsObject.jsify(metaData) : null,
      ]);

      return "Logged event";
    }
  }

  @override
  Future<dynamic> setLauncherVisibility(IntercomVisibility visibility) async {
    if (visibility != null) {
      js.context.callMethod('Intercom', [
        'update',
        js.JsObject.jsify({
          'hide_default_launcher':
              visibility == IntercomVisibility.visible ? false : true
        }),
      ]);

      return "Showing launcher: $visibility";
    }
  }

  @override
  Future<dynamic> logout() async {
    js.context.callMethod('Intercom', ['shutdown']);
    return "logout";
  }

  @override
  Future<dynamic> displayMessenger() async {
    js.context.callMethod('Intercom', ['show']);
    return "Launched";
  }

  @override
  Future<dynamic> hideMessenger() async {
    js.context.callMethod('Intercom', ['hide']);
    return "Hidden";
  }

  @override
  Future<dynamic> displayMessageComposer(String message) async {
    js.context.callMethod('Intercom', ['showNewMessage', message]);
    return "Message composer displayed";
  }
}
