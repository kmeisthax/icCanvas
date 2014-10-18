#import <icCanvasAppKit.h>
#import <icCanvasManagerObjC.h>

@interface ICAKAppDelegate (Private)

- (void)wireDrawingObject:(ICAKDrawing*)drawing;

@end

@implementation ICAKAppDelegate {
    ICMApplication* coreApp;
    
    ICAKDockingController* _dock_ctrl;
}

- (id)init {
    self = [super init];
    
    if (self != nil) {
        self->coreApp = [ICMApplication getInstance];
        self->_dock_ctrl = [[ICAKDockingController alloc] init];
    }
    
    return self;
}

- (void)wireDrawingObject:(ICAKDrawing*)drawing {
    drawing.dockingController = self->_dock_ctrl;
};

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [NSUserDefaults.standardUserDefaults setBool:NO forKey:@"NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints"];

    //Attach ICMApplication background tasks
    NSInvocation* appInvoke = [NSInvocation invocationWithMethodSignature:[self->coreApp methodSignatureForSelector:@selector(backgroundTick)]];
    [appInvoke setSelector:@selector(backgroundTick)];
    appInvoke.target = self->coreApp;
    NSTimer* appTimer = [NSTimer timerWithTimeInterval:0.0 invocation:appInvoke repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:appTimer forMode:NSDefaultRunLoopMode];
}

- (BOOL)applicationOpenUntitledFile:(NSApplication *)theApplication {
    NSDocumentController *dc = [NSDocumentController sharedDocumentController];
    
    id doc = [dc makeUntitledDocumentOfType:@"icCanvas Drawing" error:nil];
    
    if ([doc isKindOfClass:ICAKDrawing.class]) {
        ICAKDrawing* draw = (ICAKDrawing*)doc;
        draw.dockingController = self->_dock_ctrl;
    }
    
    [doc makeWindowControllers];
    [doc showWindows];
    
    return YES;
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender {
    return YES;
}

@end