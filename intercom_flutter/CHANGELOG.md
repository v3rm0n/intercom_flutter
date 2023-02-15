# Changelog

## 7.6.4

* Added method `displayHelpCenterCollections`.

## 7.6.3

* Added method `displayMessages`.

## 7.6.2

* Bump Intercom iOS SDK version to 14.0.6 ([#280](https://github.com/v3rm0n/intercom_flutter/pull/280))
* Bump Intercom Android SDK version to 14.0.4 ([#280](https://github.com/v3rm0n/intercom_flutter/pull/280))

## 7.6.1

* Bump Intercom iOS SDK version to 14.0.2
* Bump Intercom Android SDK version to 14.0.3
* Added extra documentation to fix Android exception after background push notification is received ([#270](https://github.com/v3rm0n/intercom_flutter/issues/270#issuecomment-1330510979))

## 7.6.0

* Bump Intercom iOS SDK version to 14.0.0 ([#269](https://github.com/v3rm0n/intercom_flutter/pull/269))
* Bump Intercom Android SDK version to 14.0.0 ([#269](https://github.com/v3rm0n/intercom_flutter/pull/269))

## 7.5.0

* Bump Intercom iOS SDK version to 13.0.0
* Bump Android `compileSdkVersion` to 33

## 7.4.1

* Bump Intercom Android SDK version to 12.5.1 [(#261)](https://github.com/v3rm0n/intercom_flutter/pull/261)
* Android 13 support

## 7.4.0

* Bump Intercom Android SDK version to 12.4.3 ([#259](https://github.com/v3rm0n/intercom_flutter/pull/259))
* Bump Intercom iOS SDK version to 12.4.3 ([#259](https://github.com/v3rm0n/intercom_flutter/pull/259))

## 7.3.0

* Bump Intercom Android SDK version to 12.4.2 ([#248](https://github.com/v3rm0n/intercom_flutter/pull/248))
* Bump Intercom iOS SDK version to 12.4.2 ([#248](https://github.com/v3rm0n/intercom_flutter/pull/248))

## 7.2.0

* Updated dependency `intercom_flutter_platform_interface: ^1.2.0`
* Updated dependency `intercom_flutter_web: ^0.2.0`
* Bump Intercom Android SDK version to 12.2.2
* Bump Intercom iOS SDK version to 12.2.1
* Implemented `displaySurvey`.

## 7.1.0

* Implemented `displayArticle` for web ([#231](https://github.com/v3rm0n/intercom_flutter/pull/231)).
* Bump Intercom Android SDK version to 12.1.1
* Bump Intercom iOS SDK version to 12.1.1
* Updated dependency `intercom_flutter_platform_interface: ^1.1.0`
* Updated dependency `intercom_flutter_web: ^0.1.0`
* Added method `loginIdentifiedUser` with `IntercomStatusCallback` support.
* Deprecated `registerIdentifiedUser` in favor of `loginIdentifiedUser`.
* Added method `loginUnidentifiedUser` with `IntercomStatusCallback` support.
* Deprecated `registerUnidentifiedUser` in favor of `loginUnidentifiedUser`.
* Added parameter `statusCallback` in `updateUser` to support `IntercomStatusCallback`.
* Renamed the following methods in the MethodChannel:
    - `registerIdentifiedUserWithUserId` to `loginIdentifiedUserWithUserId`.
    - `regsiterIdentifiedUserWithEmail` to `loginIdentifiedUserWithEmail`.
    - `registerUnidentifiedUser` to `loginUnidentifiedUser`.

## 7.0.0
> Note: This release has breaking changes.

* Updated `displayArticle` method documentation. ([#224](https://github.com/v3rm0n/intercom_flutter/pull/224))
* API methods are now available at instance level instead of static. ([#226](https://github.com/v3rm0n/intercom_flutter/pull/226))
    - Now use `Intercom.instance` instead of just `Intercom`, for e.g: `Intercom.instance.displayMessenger()`.

## 6.2.0

* Bump Intercom Android SDK version to 12.0.0 ([#220](https://github.com/v3rm0n/intercom_flutter/pull/220))
* Bump Intercom iOS SDK version to 12.0.0 ([#220](https://github.com/v3rm0n/intercom_flutter/pull/220))

## 6.1.0

* Bump Intercom Android SDK version to 10.7.0 ([#217](https://github.com/v3rm0n/intercom_flutter/pull/217))
* Bump Intercom iOS SDK version to 11.2.0 ([#217](https://github.com/v3rm0n/intercom_flutter/pull/217))

## 6.0.0
> Note: This release has breaking changes.

* Bump Intercom Android SDK version to 10.6.1 ([#204](https://github.com/v3rm0n/intercom_flutter/pull/204))
* Bump Intercom iOS SDK version to 11.0.1 ([#204](https://github.com/v3rm0n/intercom_flutter/pull/204))
* Resolved issue [#151](https://github.com/v3rm0n/intercom_flutter/issues/151)
* Changed Android push intercepting technique ([#192](https://github.com/v3rm0n/intercom_flutter/pull/192))
* Updated README ([#205](https://github.com/v3rm0n/intercom_flutter/pull/205))
* **BREAKING**
    - Intercom iOS SDK v11 requires minimum deployment target version 13. So iOS minimum version is updated from 10 to 13. See https://github.com/intercom/intercom-ios/blob/master/CHANGELOG.md#1100
    - The service `io.maido.intercom.PushInterceptService` is deleted. Now plugin itself will handle the push messages using the new added receiver `io.maido.intercom.PushInterceptReceiver`.
      - remove the service `io.maido.intercom.PushInterceptService`, if you have, from your `AndroidManifest.xml`.
      - remove the code to handle the background Intercom push from your `firebase_messaging` background handler. Now it is not required to handle manually.
  
## 5.3.0
* Added API documentation ([#194](https://github.com/v3rm0n/intercom_flutter/pull/194))
* Bump Intercom Android SDK version to 10.6.0 ([#195](https://github.com/v3rm0n/intercom_flutter/pull/195))
* Bump Intercom iOS SDK version to 10.4.0 ([#195](https://github.com/v3rm0n/intercom_flutter/pull/195))
* Bump android kotlin version to 1.5.30 ([#196](https://github.com/v3rm0n/intercom_flutter/pull/196))
* Bump android `com.android.tools.build:gradle` to 7.0.4 ([#196](https://github.com/v3rm0n/intercom_flutter/pull/196))
* Bump android `compileSdkVersion` to 31 ([#196](https://github.com/v3rm0n/intercom_flutter/pull/196))
* Bump android `gradle` plugin version to 7.3.3 ([#196](https://github.com/v3rm0n/intercom_flutter/pull/196))
* Updated README ([#197](https://github.com/v3rm0n/intercom_flutter/pull/197))
* Updated dependency `intercom_flutter_platform_interface: ^1.0.1`
* Updated dependency `intercom_flutter_web: ^0.0.4`

## 5.2.0
* Bump Intercom Android SDK version to 10.4.2 ([#187](https://github.com/v3rm0n/intercom_flutter/pull/187))
* Bump Intercom iOS SDK version to 10.3.4 ([#187](https://github.com/v3rm0n/intercom_flutter/pull/187))

## 5.1.0+1
* Resolved issue [#181](https://github.com/v3rm0n/intercom_flutter/issues/181)

## 5.1.0
* Bump Intercom Android SDK version to 10.4.0 ([#178](https://github.com/v3rm0n/intercom_flutter/pull/178))
* Bump Intercom iOS SDK version to 10.3.0 ([#178](https://github.com/v3rm0n/intercom_flutter/pull/178))

## 5.0.3
* Resolved issue [#173](https://github.com/v3rm0n/intercom_flutter/issues/173)

## 5.0.2
* Updated README: Removed the `<br/>` tag that was being shown on the pub.dev.
* Updated intercom_flutter pod version to `5.0.0`.

## 5.0.1
* Clear warning `PushInterceptService.java uses unchecked or unsafe operations.`

## 5.0.0
* Added web support
* Bump Intercom iOS SDK version to 10.0.2
    - this will solve the displayArticle issue. See https://github.com/intercom/intercom-ios/blob/master/CHANGELOG.md#1002

## 4.0.0
* Bump Intercom Android SDK version to 10.0.0
* Bump Intercom iOS SDK version to 10.0.0
* Adjustment to encode the iOS device token with HexString.
* Added support for displayCarousel
* Added support for displayArticle
    - Note: Intercom iOS SDK has an issue with displayArticle if your Intercom account does have that feature enabled. It crashes the app. The bug is already reported at https://forum.intercom.com/s/question/0D52G000050ZFNoSAO/intercom-display-article-crash-on-ios. As per the conversation with Intercom support, they are working on the issue. The fix may take some time.
* Internal Changes:
    - used `hideIntercom()` as `hideMessenger()` is deprecated and removed in Intercom SDK 10.0.0
    - Android - updated gradle version and dependencies.

## 3.2.1
* Fix `application has not been initialized` crash on Android when calling from background isolate.

## 3.2.0
* Migrate to use intercom_flutter_platform_interface

## 3.1.0
* Added support for language_override

## 3.0.0
* Migrate to null-safety

## 2.3.4
* Added support for setting bottom padding

## 2.3.3
* Added signedUpAt user attribute

## 2.3.2
* Fix crash if app is closed before fully initialised

## 2.3.1
* Fix Android build issue
* Updated Android dependencies

## 2.3.0
* Migrate Android side to Flutter's v2 Android Plugin APIs

## 2.2.1
* Implement sendTokenToIntercom method on iOS side to support push notifications

## 2.2.0+1
* Fix project dependencies

## 2.2.0
* Added unread messages count listener

## 2.1.1
* Fix incremental installation error

## 2.1.0
* Bump Intercom SDK version to 6.0.0 (thanks @marbarroso)
* Bump minimum Android supported version to Lollipop (API 21)
* Bump minimum iOS supported version to iOS 10.0

## 2.0.7
* Fixed background notifications being swallowed by intercom_flutter in Android (thanks @LinusU)

## 2.0.6
* Added hideMessenger (thanks @Spikes042)

## 2.0.5+2
* Fix iOS build error

## 2.0.5+1
* Fix example project dependencies

## 2.0.5
* Add displayMessageComposer (thanks @knaeckeKami)
* Add support for Android 10
* Add support for iOS 13

## 2.0.4
* Support for push notifications

## 2.0.3
* Upgraded Intercom SDK to 5.3
* Upgraded Kotlin, Android Studio, Gradle and CocoaPods to latest version
* Upgraded minimum Flutter version to `1.0.0`
* Upgraded minimum Dart version to `2.0.0`
* Fixed iOS warning

## 2.0.2
* Added logEvent method (thanks @MrAlek)
* Fixed registerIdentifiedUser (thanks @Spikes042)

## 2.0.1
* Added argument validation to registerIdentifiedUser (thanks @Zazo032)

## 2.0.0
* Changed message channel name
* Added email to user registration

## 1.0.12
* Added setUserHash (thanks @Spikes042)

## 1.0.11
* Added unreadConversationCount and setInAppMessagesVisible
* Migrated to AndroidX (thanks @LeonidVeremchuk and @Zazo032)

## 1.0.10
* Updated author

## 1.0.9
* Added support for companies
* Added support for custom attributes

## 1.0.8
* Fixed issues with nullability in Intercom Android SDK

## 1.0.7
* Added Help Center support

## 1.0.6

* Fixed null check in ObjectiveC

## 1.0.5

* Fixed ObjectiveC warnings

## 1.0.4

* Converter Swift code to ObjectiveC

## 1.0.3

* Updated iOS project to Swift 4.2

## 1.0.2

* Fixed plugin name in all places

## 1.0.1

* Fixed ios headers

## 1.0.0

* Added user attributes (name, email, phone, userId and company)
* Renamed package to `intercom_flutter` because of the name clash with Intercom pod

## 0.0.4

* Fixed pod name in podspec

## 0.0.3

* Added example project
* Formatted code
* Added test

## 0.0.2

* Changed minimum SDK version to `2.0.0-dev.28.0`

## 0.0.1

* Implemented `initialize`, `registerIdentifiedUser`, `registerUnidentifiedUser`, `logout`, `setLauncherVisibility`, `displayMessenger` on both Android and iOS
