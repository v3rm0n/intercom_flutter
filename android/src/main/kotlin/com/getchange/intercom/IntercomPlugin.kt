package com.getchange.intercom

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

class IntercomPlugin(private val application: Application) : MethodCallHandler {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "app.getchange.com/intercom")
      channel.setMethodCallHandler(IntercomPlugin(registrar.context() as Application))
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
      call.method == "registerIdentifiedUser" -> {
        val userId = call.argument<String>("userId")
        val registration = Registration.create().withUserId(userId)
        Intercom.client().registerIdentifiedUser(registration)
        result.success("User created")
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
        Intercom.client().setLauncherVisibility(Intercom.Visibility.valueOf(visibility))
        result.success("Showing launcher")
      }
      call.method == "displayMessenger" -> {
        Intercom.client().displayMessenger()
        result.success("Launched")
      }
      call.method == "updateUser" -> {
        val name = call.argument<String>("name")
        val email = call.argument<String>("email")
        val phone = call.argument<String>("phone")
        val userId = call.argument<String>("userId")
        val company = call.argument<String>("company")
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
        if (company != null) {
          val icmCompany = Company.Builder()
          icmCompany.withName(company)
          userAttributes.withCompany(icmCompany.build())
        }
        Intercom.client().updateUser(userAttributes.build())
      }
      else -> result.notImplemented()
    }
  }
}
