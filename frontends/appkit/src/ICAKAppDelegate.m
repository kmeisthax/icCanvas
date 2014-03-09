#import <icCanvasAppKit.h>

@implementation ICAKAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSRect r = {{100,100}, {250, 250}};
    self.window = [[NSWindow alloc] initWithContentRect:r styleMask:NSTitledWindowMask backing:NSBackingStoreBuffered defer:TRUE];
    [self.window makeKeyAndOrderFront:nil];
}

@end