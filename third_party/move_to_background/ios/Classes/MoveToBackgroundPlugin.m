#import "MoveToBackgroundPlugin.h"

@implementation MoveToBackgroundPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"move_to_background"
            binaryMessenger:[registrar messenger]];
  MoveToBackgroundPlugin* instance = [[MoveToBackgroundPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"moveTaskToBack" isEqualToString:call.method]) {
    [[UIApplication sharedApplication] performSelector:@selector(suspend)];
    result(@(YES));
  } else {
    result(FlutterMethodNotImplemented);
  }
}
@end
