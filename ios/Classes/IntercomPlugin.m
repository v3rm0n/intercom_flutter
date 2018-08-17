#import "IntercomPlugin.h"
#import "intercom_flutter/intercom_flutter-Swift.h"

@implementation IntercomPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftIntercomPlugin registerWithRegistrar:registrar];
}
@end
