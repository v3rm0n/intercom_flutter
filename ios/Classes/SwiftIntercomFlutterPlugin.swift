import Flutter
import UIKit
import Intercom
    
public class SwiftIntercomFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "app.getchange.com/intercom", binaryMessenger: registrar.messenger())
    let instance = SwiftIntercomFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if(call.method == "initialize") {
        if let args = call.arguments as? [String: String] {
            let apiKey = args["iosApiKey"]
            let appId = args["appId"]
            Intercom.setApiKey(apiKey!, forAppId:appId!)
            result("Intercom initialized")
        } else {
            result("Intercom initialization failed")
        }
    } else if(call.method == "registerUnidentifiedUser") {
        Intercom.registerUnidentifiedUser()
        result("Registered unidentified user")
    } else if (call.method == "registerIdentifiedUser") {
        if let args = call.arguments as? [String: String] {
            let userId = args["userId"]
            Intercom.registerUser(withUserId: userId!)
            result("User registered")
        } else {
            result("Registering user failed")
        }
    } else if (call.method == "setLauncherVisibility") {
        if let args = call.arguments as? [String: String] {
            let visibility = args["visibility"]
            Intercom.setLauncherVisible(visibility == "VISIBLE")
            result("Set launcher visible")
        } else {
            result("Setting launcher visible failed")
        }
    } else if (call.method == "displayMessenger") {
        Intercom.presentMessenger()
        result("Presenting messenger")
    } else if (call.method == "updateUser") {
        if let args = call.arguments as? [String: String] {
            let email = args["email"]
            let name = args["name"]
            let userId = args["userId"]
            let phone = args["phone"]
            let company = args["company"]
            let userAttributes = ICMUserAttributes()
            if (email != nil) {
                userAttributes.email = email
            }
            if (name != nil) {
                userAttributes.name = name
            }
            if (phone != nil) {
                userAttributes.phone = phone
            }
            if (userId != nil) {
                userAttributes.userId = userId
            }
            if (company != nil) {
                let icmCompany = ICMCompany()
                icmCompany.name = company
                userAttributes.companies = [icmCompany]
            }
            Intercom.updateUser(userAttributes)
            result("User updates")
        } else {
            result("Updating user failed")
        }

    } else if (call.method == "logout") {
        Intercom.logout()
        result("Logged out")
    }
  }
}
