#import "NativeAdsPlugin.h"
#import <native_ads/native_ads-Swift.h>

@implementation NativeAdsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftNativeAdsPlugin registerWithRegistrar:registrar];
}
@end
