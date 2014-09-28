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
    [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints"];

    //Attach ICMApplication background tasks
    NSInvocation* appInvoke = [NSInvocation invocationWithMethodSignature:[self->coreApp methodSignatureForSelector:@selector(backgroundTick)]];
    [appInvoke setSelector:@selector(backgroundTick)];
    appInvoke.target = self->coreApp;
    NSTimer* appTimer = [NSTimer timerWithTimeInterval:0.0 invocation:appInvoke repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:appTimer forMode:NSDefaultRunLoopMode];
    
    //Force creation of new document
    [[NSDocumentController sharedDocumentController] openUntitledDocumentAndDisplay:YES error: nil];
}

- (BOOL)applicationOpenUntitledFile:(NSApplication *)theApplication {
    NSDocumentController *dc = [NSDocumentController sharedDocumentController];
    
    [dc makeUntitledDocumentOfType:@"icCanvas Drawing" error:nil];
    
    return YES;
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender {
    return YES;
}

@end