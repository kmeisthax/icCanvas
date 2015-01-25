#import <icCanvasAppKit.h>
#import <icCanvasManagerObjC.h>

@interface ICAKAppDelegate (Private)

- (void)wireDrawingObject:(ICAKDrawing*)drawing;

@end

@implementation ICAKAppDelegate <ICMApplicationDelegate> {
    ICMApplication* coreApp;
    NSTimer* _active_task_timer;
    
    ICAKDockingController* _dock_ctrl;
    ICAKToolPaletteController* _tpal_ctrl;
}

- (id)init {
    self = [super init];
    
    if (self != nil) {
        self->coreApp = [ICMApplication getInstance];
        self->_dock_ctrl = [[ICAKDockingController alloc] init];
        self->_tpal_ctrl = [[ICAKToolPaletteController alloc] init];
        
        self->_tpal_ctrl.dockingController = self->_dock_ctrl;
        self->_active_task_timer = nil;
    }
    
    return self;
}

- (void)wireDrawingObject:(ICAKDrawing*)drawing {
    drawing.dockingController = self->_dock_ctrl;
};

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [NSUserDefaults.standardUserDefaults setBool:NO forKey:@"NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints"];
    
    self->coreApp.delegate = self;
}

- (void)enableBackgroundTicks {
    if (self->_active_task_timer != nil) {
        //Attach ICMApplication background tasks
        NSInvocation* appInvoke = [NSInvocation invocationWithMethodSignature:[self->coreApp methodSignatureForSelector:@selector(backgroundTick)]];
        [appInvoke setSelector:@selector(backgroundTick)];
        appInvoke.target = self->coreApp;
        self->_active_task_timer = [NSTimer timerWithTimeInterval:0.0 invocation:appInvoke repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:appTimer forMode:NSDefaultRunLoopMode];
    }
};

- (void)disableBackgroundTicks {
    if (self->_active_task_timer != nil) {
        [self->_active_task_timer invalidate];
        self->_active_task_timer = nil;
    }
};

- (BOOL)applicationOpenUntitledFile:(NSApplication *)theApplication {
    NSDocumentController *dc = [NSDocumentController sharedDocumentController];
    
    id doc = [dc makeUntitledDocumentOfType:@"icCanvas Drawing" error:nil];
    
    if ([doc isKindOfClass:ICAKDrawing.class]) {
        ICAKDrawing* draw = (ICAKDrawing*)doc;
        draw.dockingController = self->_dock_ctrl;
        draw.toolPaletteController = self->_tpal_ctrl;
    }
    
    [doc makeWindowControllers];
    [doc showWindows];
    
    return YES;
}

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender {
    return YES;
}

@end