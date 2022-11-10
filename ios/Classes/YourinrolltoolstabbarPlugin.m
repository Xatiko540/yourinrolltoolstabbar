#import "YourinrolltoolstabbarPlugin.h"
#if __has_include(<yourinrolltoolstabbar/yourinrolltoolstabbar-Swift.h>)
#import <yourinrolltoolstabbar/yourinrolltoolstabbar-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "yourinrolltoolstabbar-Swift.h"
#endif

@implementation YourinrolltoolstabbarPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftYourinrolltoolstabbarPlugin registerWithRegistrar:registrar];
}
@end
