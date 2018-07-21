import Flutter
import UIKit
import Intercom
    
public class SwiftIntercomPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "intercom_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftIntercomPlugin()
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
            Intercom.setLauncherVisible(visibility == "visible")
            result("Set launcher visible")
        } else {
            result("Setting launcher visible failed")
        }
    } else if (call.method == "displayMessenger") {
        Intercom.presentMessenger()
        result("Presenting messenger")
    } else if (call.method == "logout") {
        Intercom.logout()
        result("Logged out")
    }
  }
}
