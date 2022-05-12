#import "IntercomFlutterPlugin.h"
#import <Intercom/Intercom.h>

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
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    IntercomFlutterPlugin* instance = [[IntercomFlutterPlugin alloc] init];
    FlutterMethodChannel* channel =
    [FlutterMethodChannel methodChannelWithName:@"maido.io/intercom"
                                binaryMessenger:[registrar messenger]];
    [registrar addMethodCallDelegate:instance channel:channel];
    FlutterEventChannel* unreadChannel = [FlutterEventChannel eventChannelWithName:@"maido.io/intercom/unread"
    binaryMessenger:[registrar messenger]];
    UnreadStreamHandler* unreadStreamHandler =
        [[UnreadStreamHandler alloc] init];
    [unreadChannel setStreamHandler:unreadStreamHandler];
    
}

- (void) handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result{
    if([@"initialize" isEqualToString:call.method]) {
        NSString *iosApiKey = call.arguments[@"iosApiKey"];
        NSString *appId = call.arguments[@"appId"];
        [Intercom setApiKey:iosApiKey forAppId:appId];
        result(@"Initialized Intercom");
    }
    else if([@"loginUnidentifiedUser" isEqualToString:call.method]) {
        [Intercom loginUnidentifiedUserWithSuccess:^{
            // Handle success
            result(@"Registered unidentified user");
        } failure:^(NSError * _Nonnull error) {
            // Handle error
            NSInteger errorCode = error.code;
            NSString *errorMsg = error.localizedDescription;
            
            result([FlutterError errorWithCode:[@(errorCode) stringValue]
                                       message:errorMsg
                                       details: [self getIntercomError:errorCode:errorMsg]]);
        }];
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
    else if([@"loginIdentifiedUserWithUserId" isEqualToString:call.method]) {
        NSString *userId = call.arguments[@"userId"];
        ICMUserAttributes *attributes = [ICMUserAttributes new];
        attributes.userId = userId;
        [Intercom loginUserWithUserAttributes:attributes success:^{
            // Handle success
            result(@"Registered user");
        } failure:^(NSError * _Nonnull error) {
            // Handle failure
            NSInteger errorCode = error.code;
            NSString *errorMsg = error.localizedDescription;
            
            result([FlutterError errorWithCode:[@(errorCode) stringValue]
                                       message:errorMsg
                                       details: [self getIntercomError:errorCode:errorMsg]]);
        }];
    }
    else if([@"loginIdentifiedUserWithEmail" isEqualToString:call.method]) {
        NSString *email = call.arguments[@"email"];
        ICMUserAttributes *attributes = [ICMUserAttributes new];
        attributes.email = email;
        [Intercom loginUserWithUserAttributes:attributes success:^{
            // Handle success
            result(@"Registered user");
        } failure:^(NSError * _Nonnull error) {
            // Handle failure
            NSInteger errorCode = error.code;
            NSString *errorMsg = error.localizedDescription;
            
            result([FlutterError errorWithCode:[@(errorCode) stringValue]
                                       message:errorMsg
                                       details: [self getIntercomError:errorCode:errorMsg]]);
        }];
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
        [Intercom hideIntercom];
        result(@"Messenger hidden");
    }
    else if([@"displayHelpCenter" isEqualToString:call.method]) {
        [Intercom presentHelpCenter];
        result(@"Presented help center");
    }
    else if([@"updateUser" isEqualToString:call.method]) {
        [Intercom updateUser:[self getAttributes:call] success:^{
            // Handle success
            result(@"Updated user");
        } failure:^(NSError * _Nonnull error) {
            // Handle failure
            NSInteger errorCode = error.code;
            NSString *errorMsg = error.localizedDescription;
            
            result([FlutterError errorWithCode:[@(errorCode) stringValue]
                                       message:errorMsg
                                       details: [self getIntercomError:errorCode:errorMsg]]);
        }];
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
            NSData *encodedToken=[self createDataWithHexString:token];
            // NSData* encodedToken=[token dataUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"%@", encodedToken);
            [Intercom setDeviceToken:encodedToken failure:^(NSError * _Nonnull error) {
                // Handle failure
                NSLog(@"Error setting device token: %@", error.localizedDescription);
            }];
            result(@"Token set");
        }
    } else if([@"displayArticle" isEqualToString:call.method]) {
        NSString *articleId = call.arguments[@"articleId"];
        NSLog(@"%@", articleId);
        if(articleId != (id)[NSNull null] && articleId != nil) {
            [Intercom presentArticle:articleId];
            result(@"displaying article");
        }
    } else if([@"displayCarousel" isEqualToString:call.method]) {
        NSString *carouselId = call.arguments[@"carouselId"];
        if(carouselId != (id)[NSNull null] && carouselId != nil) {
            [Intercom presentCarousel:carouselId];
            result(@"displaying carousel");
        }
    } else if([@"displaySurvey" isEqualToString:call.method]) {
        NSString *surveyId = call.arguments[@"surveyId"];
        if(surveyId != (id)[NSNull null] && surveyId != nil) {
            [Intercom presentSurvey:surveyId];
            result(@"displaying survey");
        }
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}

- (NSMutableDictionary *) getIntercomError:(NSInteger)errorCode :(NSString *)errorMessage {
    NSMutableDictionary *details = [NSMutableDictionary dictionary];
    [details setObject:[NSNumber numberWithInteger:errorCode]  forKey: @"errorCode"];
    [details setObject: errorMessage forKey:  @"errorMessage"];
    
    return details;
}

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
    
    NSString *language = call.arguments[@"language"];
    if(language != (id)[NSNull null]) {
        attributes.languageOverride = language;
    }
    
    return attributes;
}

- (NSData *) createDataWithHexString:(NSString*)inputString {
    NSUInteger inLength = [inputString length];

    unichar *inCharacters = alloca(sizeof(unichar) * inLength);
    [inputString getCharacters:inCharacters range:NSMakeRange(0, inLength)];

    UInt8 *outBytes = malloc(sizeof(UInt8) * ((inLength / 2) + 1));

    NSInteger i, o = 0;
    UInt8 outByte = 0;

    for (i = 0; i < inLength; i++) {
        UInt8 c = inCharacters[i];
        SInt8 value = -1;

        if      (c >= '0' && c <= '9') value =      (c - '0');
        else if (c >= 'A' && c <= 'F') value = 10 + (c - 'A');
        else if (c >= 'a' && c <= 'f') value = 10 + (c - 'a');

        if (value >= 0) {
            if (i % 2 == 1) {
                outBytes[o++] = (outByte << 4) | value;
                outByte = 0;
            } else {
                outByte = value;
            }

        } else {
            if (o != 0) break;
        }
    }

    NSData *a = [[NSData alloc] initWithBytesNoCopy:outBytes length:o freeWhenDone:YES];
    return a;
}
@end
