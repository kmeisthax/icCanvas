#import <icCanvasAppKit.h>
#import <icCanvasManagerObjC.h>

@implementation ICAKAppDelegate {
    ICMApplication* coreApp;
}

- (id)init {
    self = [super init];
    
    if (self != nil) {
        self->coreApp = [ICMApplication getInstance];
    }
    
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    //Attach ICMApplication background tasks
    NSInvocation* appInvoke = [NSInvocation invocationWithMethodSignature:[self->coreApp methodSignatureForSelector:@selector(backgroundTick)]];
    [appInvoke setSelector:@selector(backgroundTick)];
    appInvoke.target = self->coreApp;
    NSTimer* appTimer = [NSTimer timerWithTimeInterval:0.0 invocation:appInvoke repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:appTimer forMode:NSDefaultRunLoopMode];
    
    //Create test window
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