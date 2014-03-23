#import <Cocoa/Cocoa.h>
#import <icCanvasManagerObjc.h>
#import <icCanvasAppKit.h>

int main (int argc, char* argv[]) {
    [NSApplication sharedApplication];
    
    ICAKAppDelegate* theDelegate = [[ICAKAppDelegate alloc] init];
    [NSApp setDelegate:theDelegate];
    [NSApp run];
}