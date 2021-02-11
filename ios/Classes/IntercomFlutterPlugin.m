#import "IntercomFlutterPlugin.h"
#import <Intercom/Intercom.h>
#import <UserNotifications/UserNotifications.h>

id unread;

@implementation UnreadStreamHandler
- (FlutterError*)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)eventSink {
    unread = [[NSNotificationCenter defaultCenter] addObserverForName:IntercomUnreadConversationCountDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSNumber *myNum = @([Intercom unreadConversationCount]);
        eventSink(myNum);
    }];
  return nil;
}

- (FlutterError*)onCancelWithArguments:(id)arguments {
    [[NSNotificationCenter defaultCenter] removeObserver:unread];
  return nil;
}
@end

@implementation IntercomFlutterPlugin
 FlutterMethodChannel *_channel;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel =
    [FlutterMethodChannel methodChannelWithName:@"maido.io/intercom"
                                binaryMessenger:[registrar messenger]];
    id instance = [[IntercomFlutterPlugin alloc] initWithChannel:channel];
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
    FlutterEventChannel* unreadChannel = [FlutterEventChannel eventChannelWithName:@"maido.io/intercom/unread"
    binaryMessenger:[registrar messenger]];
    UnreadStreamHandler* unreadStreamHandler =
        [[UnreadStreamHandler alloc] init];
    [unreadChannel setStreamHandler:unreadStreamHandler];

}

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];

    if (self) {
        _channel = channel;
    }
    return self;
}

- (void) handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result{
    if([@"initialize" isEqualToString:call.method]) {
        NSString *iosApiKey = call.arguments[@"iosApiKey"];
        NSString *appId = call.arguments[@"appId"];
        [Intercom setApiKey:iosApiKey forAppId:appId];
        result(@"Initialized Intercom");
    }
    else if([@"registerUnidentifiedUser" isEqualToString:call.method]) {
        [Intercom registerUnidentifiedUser];
        result(@"Registered unidentified user");
    }
    else if([@"setBottomPadding" isEqualToString:call.method]) {
        NSNumber *value = call.arguments[@"bottomPadding"];
        if(value != (id)[NSNull null] && value != nil) {
            CGFloat padding = [value doubleValue];
            [Intercom setBottomPadding:padding];
            result(@"Set bottom padding");
        }
    }
    else if([@"setUserHash" isEqualToString:call.method]) {
        NSString *userHash = call.arguments[@"userHash"];
        [Intercom setUserHash:userHash];
        result(@"User hash added");
    }
    else if([@"registerIdentifiedUserWithUserId" isEqualToString:call.method]) {
        NSString *userId = call.arguments[@"userId"];
        [Intercom registerUserWithUserId:userId];
        result(@"Registered user");
    }
    else if([@"registerIdentifiedUserWithEmail" isEqualToString:call.method]) {
        NSString *email = call.arguments[@"email"];
        [Intercom registerUserWithEmail:email];
        result(@"Registered user");
    }
    else if([@"setLauncherVisibility" isEqualToString:call.method]) {
        NSString *visibility = call.arguments[@"visibility"];
        [Intercom setLauncherVisible:[@"VISIBLE" isEqualToString:visibility]];
        result(@"Setting launcher visibility");
    }
    else if([@"setInAppMessagesVisibility" isEqualToString:call.method]) {
        NSString *visibility = call.arguments[@"visibility"];
        [Intercom setInAppMessagesVisible:[@"VISIBLE" isEqualToString:visibility]];
        result(@"Setting in app messages visibility");
    }
    else if([@"unreadConversationCount" isEqualToString:call.method]) {
        NSUInteger count = [Intercom unreadConversationCount];
        result(@(count));
    }
    else if([@"displayMessenger" isEqualToString:call.method]) {
        [Intercom presentMessenger];
        result(@"Presented messenger");
    }
    else if([@"hideMessenger" isEqualToString:call.method]) {
        [Intercom hideMessenger];
        result(@"Messenger hidden");
    }
    else if([@"displayHelpCenter" isEqualToString:call.method]) {
        [Intercom presentHelpCenter];
        result(@"Presented help center");
    }
    else if([@"updateUser" isEqualToString:call.method]) {
        [Intercom updateUser:[self getAttributes:call]];
        result(@"Updated user");
    }
    else if([@"logout" isEqualToString:call.method]) {
        [Intercom logout];
        result(@"Logged out");
    }
    else if ([@"logEvent" isEqualToString:call.method]) {
        NSString *name = call.arguments[@"name"];
        NSDictionary *metaData = call.arguments[@"metaData"];
        if(name != (id)[NSNull null] && name != nil) {
            if(metaData != (id)[NSNull null] && metaData != nil) {
                [Intercom logEventWithName:name metaData:metaData];
            } else {
                [Intercom logEventWithName:name];
            }
            result(@"Logged event");
        }
    }
    else if([@"handlePushMessage" isEqualToString:call.method]) {
        result(@"No op");
    }
    else if([@"displayMessageComposer" isEqualToString:call.method]) {
        NSString *message = call.arguments[@"message"];
        [Intercom presentMessageComposer:message];
    } else if([@"sendTokenToIntercom" isEqualToString:call.method]){
        NSString *token = call.arguments[@"token"];
        if(token != (id)[NSNull null] && token != nil) {
            NSData* encodedToken=[token dataUsingEncoding:NSUTF8StringEncoding];
            [Intercom setDeviceToken:encodedToken];
            result(@"Token set");
        }
    }
    else if([@"sendTokenToIntercom" isEqualToString:call.method]) {
        NSString *token = call.arguments[@"token"];
        if (token != nil) {
            NSData * tokenData = [self dataFromHexString:token];
            [Intercom setDeviceToken:tokenData];
            result(@"Token sent to Intercom");
        }
    }
    else if([@"requestNotificationPermissions" isEqualToString:call.method]) {
    	dispatch_async(dispatch_get_main_queue(), ^{
			UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
			UNAuthorizationOptions authorizationOptions = 0;
			authorizationOptions += UNAuthorizationOptionSound;
			authorizationOptions += UNAuthorizationOptionAlert;
			authorizationOptions += UNAuthorizationOptionBadge;
			[center requestAuthorizationWithOptions:(authorizationOptions) completionHandler:^(BOOL granted, NSError * _Nullable error) {
			  if (!granted || error != nil) {
				result(@(NO));
				return;
			  } else {
        		result(@(YES));
			  }
			}];
    	});
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}


// Convert token to string
// Source: https://stackoverflow.com/a/16411517/1123085
- (NSString *)stringWithDeviceToken:(NSData *)deviceToken {
    const char *data = [deviceToken bytes];
    NSMutableString *token = [NSMutableString string];

    for (NSUInteger i = 0; i < [deviceToken length]; i++) {
        [token appendFormat:@"%02.2hhX", data[i]];
    }

    return [token copy];
}

// Needed to change string token back to NSData
// Source: https://iphoneappcode.blogspot.com/2012/04/nsdata-to-hexstring-and-hexstring-to.html
- (NSData *)dataFromHexString:(NSString *)string
{
    NSMutableData *stringData = [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [string length] / 2; i++) {
        byte_chars[0] = [string characterAtIndex:i*2];
        byte_chars[1] = [string characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [stringData appendBytes:&whole_byte length:1];
    }
    return stringData;
}

#pragma mark - AppDelegate

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString * token = [self stringWithDeviceToken:deviceToken];
    [_channel invokeMethod:@"iosDeviceToken" arguments:token];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"Failed to register for notifications %@", str);
}

- (BOOL)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    if ([Intercom isIntercomPushNotification:userInfo]) {
        [Intercom handleIntercomPushNotification:userInfo];
        completionHandler(UIBackgroundFetchResultNoData);
        return true;
    }
    return false;
}

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
    didReceiveNotificationResponse:(UNNotificationResponse *)response
             withCompletionHandler:(void (^)(void))completionHandler NS_AVAILABLE_IOS(10.0) {
  NSDictionary *userInfo = response.notification.request.content.userInfo;
  if ([Intercom isIntercomPushNotification:userInfo]) {
          [Intercom handleIntercomPushNotification:userInfo];
          completionHandler();
      }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
    NS_AVAILABLE_IOS(10.0) {
  NSDictionary *userInfo = notification.request.content.userInfo;
  if ([Intercom isIntercomPushNotification:userInfo]) {
          [Intercom handleIntercomPushNotification:userInfo];
          completionHandler(UNNotificationPresentationOptionNone);
      }
}
#endif


- (ICMUserAttributes *) getAttributes:(FlutterMethodCall *)call {
    ICMUserAttributes *attributes = [ICMUserAttributes new];
    NSString *email = call.arguments[@"email"];
    if(email != (id)[NSNull null]) {
        attributes.email = email;
    }
    NSString *name = call.arguments[@"name"];
    if(name != (id)[NSNull null]) {
        attributes.name = name;
    }
    NSString *phone = call.arguments[@"phone"];
    if(phone != (id)[NSNull null]) {
        attributes.phone = phone;
    }
    NSString *userId = call.arguments[@"userId"];
    if(userId != (id)[NSNull null]) {
        attributes.userId = userId;
    }
    NSString *companyName = call.arguments[@"company"];
    NSString *companyId = call.arguments[@"companyId"];
    if(companyName != (id)[NSNull null] && companyId != (id)[NSNull null]) {
        ICMCompany *company = [ICMCompany new];
        company.name = companyName;
        company.companyId = companyId;
        attributes.companies = @[company];
    }
    NSDictionary *customAttributes = call.arguments[@"customAttributes"];
    if(customAttributes != (id)[NSNull null]) {
        attributes.customAttributes = customAttributes;
    }
    
    NSNumber *signedUpAt = call.arguments[@"signedUpAt"];
    if(signedUpAt != (id)[NSNull null]) {
        attributes.signedUpAt = [NSDate dateWithTimeIntervalSince1970: signedUpAt.doubleValue];
    }
    
    return attributes;
}

@end
