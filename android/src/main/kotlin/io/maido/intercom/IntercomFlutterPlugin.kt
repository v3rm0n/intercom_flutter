package io.maido.intercom

import android.app.Application
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.intercom.android.sdk.Company
import io.intercom.android.sdk.Intercom
import io.intercom.android.sdk.UserAttributes
import io.intercom.android.sdk.identity.Registration
import io.intercom.android.sdk.push.IntercomPushClient



class IntercomFlutterPlugin(private val application: Application) : MethodCallHandler {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "maido.io/intercom")
      channel.setMethodCallHandler(IntercomFlutterPlugin(registrar.context() as Application))

    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when {
      call.method == "initialize" -> {
        val apiKey = call.argument<String>("androidApiKey")
        val appId = call.argument<String>("appId")
        Intercom.initialize(application, apiKey, appId)
        result.success("Intercom initialized")
      }
      call.method == "setUserHash" -> {
        val userHash = call.argument<String>("userHash")
        if(userHash != null) {
          Intercom.client().setUserHash(userHash);
          result.success("User hash added")
        }
      }
      call.method == "registerIdentifiedUserWithUserId" -> {
        val userId = call.argument<String>("userId")
        if(userId != null) {
          var registration = Registration.create()
          registration = registration.withUserId(userId)
          Intercom.client().registerIdentifiedUser(registration)
          result.success("User created")
        }
      }
      call.method == "registerIdentifiedUserWithEmail" -> {
        val email = call.argument<String>("email")
        if(email != null) {
          var registration = Registration.create()
          registration = registration.withEmail(email)
          Intercom.client().registerIdentifiedUser(registration)
          result.success("User created")
        }
      }
      call.method == "registerUnidentifiedUser" -> {
        Intercom.client().registerUnidentifiedUser()
        result.success("User created")
      }
      call.method == "logout" -> {
        Intercom.client().logout()
        result.success("logout")
      }
      call.method == "setLauncherVisibility" -> {
        val visibility = call.argument<String>("visibility")
        if(visibility != null) {
          Intercom.client().setLauncherVisibility(Intercom.Visibility.valueOf(visibility))
          result.success("Showing launcher: $visibility")
        }
      }
      call.method == "displayMessenger" -> {
        Intercom.client().displayMessenger()
        result.success("Launched")
      }
      call.method == "displayHelpCenter" -> {
        Intercom.client().displayHelpCenter()
        result.success("Launched")
      }
      call.method == "setInAppMessageVisibility" -> {
        val visibility = call.argument<String>("visibility")
        if(visibility != null) {
          Intercom.client().setInAppMessageVisibility(Intercom.Visibility.valueOf(visibility))
          result.success("Showing in app messages: $visibility")
        }
        result.success("Launched")
      }
      call.method == "unreadConversationCount" -> {
        val count = Intercom.client().unreadConversationCount
        result.success(count)
      }
      call.method == "updateUser" -> {
        val name = call.argument<String>("name")
        val email = call.argument<String>("email")
        val phone = call.argument<String>("phone")
        val userId = call.argument<String>("userId")
        val company = call.argument<String>("company")
        val companyId = call.argument<String>("companyId")
        val customAttributes = call.argument<Map<String, Any?>>("customAttributes")
        val userAttributes = UserAttributes.Builder()
        if (email != null) {
          userAttributes.withEmail(email)
        }
        if (name != null) {
          userAttributes.withName(name)
        }
        if (phone != null) {
          userAttributes.withPhone(phone)
        }
        if (userId != null) {
          userAttributes.withUserId(userId)
        }
        if (company != null && companyId != null) {
          val icmCompany = Company.Builder()
          icmCompany.withName(company)
          icmCompany.withCompanyId(companyId)
          userAttributes.withCompany(icmCompany.build())
        }
        if (customAttributes != null) {
          for((key, value) in customAttributes){
            userAttributes.withCustomAttribute(key, value)
          }
        }
        Intercom.client().updateUser(userAttributes.build())
        result.success("User updated")
      }
      call.method == "logEvent" -> {
        val name = call.argument<String>("name")
        val metaData = call.argument<Map<String, Any>>("metaData")
        if(name != null) {
          Intercom.client().logEvent(name, metaData);
          result.success("Logged event")
        }
      }

      call.method == "sendTokenToIntercom" -> {
        val token = call.argument<String>("token")
        val metaData = call.argument<Map<String, Any>>("metaData")
        if(token != null) {
          IntercomPushClient().sendTokenToIntercom(application, token)

          result.success("Token sent to Intercom")
        }
      }
      call.method == "handlePushMessage" -> {
        Intercom.client().handlePushMessage()
        result.success("Push message handled")
      }
      else -> result.notImplemented()
    }
  }
}
