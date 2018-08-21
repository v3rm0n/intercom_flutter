#import "IntercomFlutterPlugin.h"
#import "Intercom.h"

@implementation IntercomFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    IntercomFlutterPlugin* instance = [[IntercomFlutterPlugin alloc] init];
    FlutterMethodChannel* channel =
    [FlutterMethodChannel methodChannelWithName:@"app.getchange.com/intercom"
                                binaryMessenger:[registrar messenger]];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void) handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result{
    if([@"initialize" isEqualToString:call.method]){
        NSString *iosApiKey = call.arguments[@"iosApiKey"];
        NSString *appId = call.arguments[@"appId"];
        [Intercom setApiKey:iosApiKey forAppId:appId];
        result(@"");
    }
    else if([@"registerUnidentifiedUser" isEqualToString:call.method]){
        [Intercom registerUnidentifiedUser];
        result(@"");
    }
    else if([@"registerIdentifiedUser" isEqualToString:call.method]){
        NSString *userId = call.arguments[@"userId"];
        [Intercom registerUserWithUserId:userId];
        result(@"Registered user");
    }
    else if([@"setLauncherVisibility" isEqualToString:call.method]){
        NSString *visibility = call.arguments[@"visibility"];
        [Intercom setLauncherVisible:[@"VISIBLE" isEqualToString:visibility]];
        result(@"Setting launcher visibility");
    }
    else if([@"displayMessenger" isEqualToString:call.method]){
        [Intercom presentMessenger];
        result(@"Presented messenger");
    }
    else if([@"updateUser" isEqualToString:call.method]){
        ICMUserAttributes *attributes = [ICMUserAttributes new];
        [attributes setEmail:call.arguments[@"email"]];
        [attributes setName:call.arguments[@"name"]];
        [attributes setPhone:call.arguments[@"phone"]];
        [attributes setUserId:call.arguments[@"userId"]];
        
        NSString *company = call.arguments[@"company"];
        if(company){
            ICMCompany *newCompany = [ICMCompany new];
            [newCompany setName:company];
            [attributes setCompanies:@[newCompany]];
        }
        [Intercom updateUser:attributes];
        
        result(@"Updated user");
    }
    else if([@"logout" isEqualToString:call.method]){
        [Intercom logout];
        result(@"Logged out");
    }else{
        result(FlutterMethodNotImplemented);
    }
}
@end
