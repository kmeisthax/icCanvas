#import <icCanvasAppKit.h>
#import <icCanvasManagerObjC.h>

@implementation ICAKAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSRect r = {{100,100}, {250, 250}};
    self.window = [[NSWindow alloc] initWithContentRect:r styleMask:(NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask) backing:NSBackingStoreBuffered defer:TRUE];
    [self.window makeKeyAndOrderFront:nil];
    [self.window setCollectionBehavior:(self.window.collectionBehavior|NSWindowCollectionBehaviorFullScreenPrimary)];
    
    ICMDrawing* drawing = [[ICMDrawing alloc] init];
    
    ICAKCanvasView* cv = [[ICAKCanvasView alloc] initWithDrawing: drawing];
    NSScrollView* scv = [[NSScrollView alloc] initWithFrame: [[self.window contentView] frame]];
    
    NSPoint center = {0,0};
    [cv sizeToFitCanvas];
    
    [scv setHasVerticalScroller:YES];
    [scv setHasHorizontalScroller:YES];
    [scv setBorderType:NSNoBorder];
    [scv setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    [scv setDocumentView:cv];
    [scv setHasHorizontalRuler:YES];
    [scv setHasVerticalRuler:YES];
    [scv setRulersVisible:YES];
    [scv setDrawsBackground:NO];
    [[scv documentView] scrollPoint:center];
    
    [self.window setContentView:scv];
}

@end