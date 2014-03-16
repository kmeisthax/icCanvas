#import <Cocoa/Cocoa.h>
#import <icCanvasManagerObjc.h>
#import <icCanvasAppKit.h>

int main (int argc, char* argv[]) {
    ICMBrushStroke* bsptr = [[ICMBrushStroke alloc] init];
    [bsptr penBeginWithX:32 andY:16];
    
    [NSApplication sharedApplication];
    
    ICAKAppDelegate* theDelegate = [[ICAKAppDelegate alloc] init];
    [NSApp setDelegate:theDelegate];
    [NSApp run];
}