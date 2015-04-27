#import <icCanvasAppKit.h>
#import <icCanvasManagerObjC.h>

@interface ICAKAppDelegate (Private)

- (void)wireDrawingObject:(ICAKDrawing*)drawing;

@end

@implementation ICAKAppDelegate {
    ICMApplication* coreApp;
    NSTimer* _active_task_timer;
    
    ICAKDockingController* _dock_ctrl;
    ICAKToolPaletteController* _tpal_ctrl;

    ICMGLRenderer* _gl_render;
    ICAKGLContextManager* _gl_ctxts;

    NSView* _osView;
    NSWindow* _wnd;
}

- (id)init {
    self = [super init];
    
    if (self != nil) {
        self->coreApp = [ICMApplication getInstance];
        self->_dock_ctrl = [[ICAKDockingController alloc] init];
        self->_tpal_ctrl = [[ICAKToolPaletteController alloc] init];
        
        //Create a hidden window to bind NSOpenGLContext to.
        self->_wnd = [[NSWindow alloc] init];
        self->_osView = [[NSView alloc] init];
        self->_wnd.contentView = self->_osView;

        self->_gl_ctxts = [[ICAKGLContextManager alloc] init];

        intptr_t ctxt = [self->_gl_ctxts createMainContextWithVersionMajor:3 andMinor:2];
        self->_gl_render = [[ICMGLRenderer alloc] initWithContextManager:self->_gl_ctxts andContext:ctxt andDrawable:(intptr_t)(__bridge void*)self->_osView];

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
    if (self->_active_task_timer == nil) {
        //Attach ICMApplication background tasks
        NSInvocation* appInvoke = [NSInvocation invocationWithMethodSignature:[self->coreApp methodSignatureForSelector:@selector(backgroundTick)]];
        [appInvoke setSelector:@selector(backgroundTick)];
        appInvoke.target = self->coreApp;
        self->_active_task_timer = [NSTimer timerWithTimeInterval:0.0 invocation:appInvoke repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self->_active_task_timer forMode:NSDefaultRunLoopMode];
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
