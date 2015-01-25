#import <Cocoa/Cocoa.h>

@interface ICAKAppDelegate : NSObject <NSApplicationDelegate, ICMApplicationDelegate>

@property (retain) NSWindow *window;

- (id)init;

@end
