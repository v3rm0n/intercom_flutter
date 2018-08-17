#import "IntercomFlutterPlugin.h"
#import <intercom_flutter/intercom_flutter-Swift.h>

@implementation IntercomFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftIntercomFlutterPlugin registerWithRegistrar:registrar];
}
@end
