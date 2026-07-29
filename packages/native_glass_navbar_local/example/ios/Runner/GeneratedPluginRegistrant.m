//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<integration_test/IntegrationTestPlugin.h>)
#import <integration_test/IntegrationTestPlugin.h>
#else
@import integration_test;
#endif

#if __has_include(<native_glass_navbar/NativeLiquidTabBarPlugin.h>)
#import <native_glass_navbar/NativeLiquidTabBarPlugin.h>
#else
@import native_glass_navbar;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [IntegrationTestPlugin registerWithRegistrar:[registry registrarForPlugin:@"IntegrationTestPlugin"]];
  [NativeLiquidTabBarPlugin registerWithRegistrar:[registry registrarForPlugin:@"NativeLiquidTabBarPlugin"]];
}

@end
