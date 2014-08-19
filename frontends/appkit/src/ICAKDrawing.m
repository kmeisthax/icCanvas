#include <icCanvasAppKit.h>

@implementation ICAKDrawing {
    ICMDrawing* internal_drawing;
    NSTimer* background_timer;
}

- (id)init {
    self = [super init];
    
    if (self != nil) {
        self->internal_drawing = [[ICMDrawing alloc] init];
        
        NSInvocation* appInvoke = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(backgroundTick)]];
        [appInvoke setSelector:@selector(backgroundTick)];
        appInvoke.target = self;
        self->background_timer = [NSTimer timerWithTimeInterval:0.0 invocation:appInvoke repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self->background_timer forMode:NSDefaultRunLoopMode];
    }
    
    return self;
}

- (BOOL)readFromFileWrapper:(NSFileWrapper *)fileWrapper ofType:(NSString *)typeName error:(NSError **)outError {
    return YES;
}
- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation originalContentsURL:(NSURL *)absoluteOriginalContentsURL error:(NSError **)outError {
    return YES;
}

- (void)backgroundTick {
    int num_rendered = [[[ICMApplication getInstance] renderScheduler] collectRequestsForDrawing:self->internal_drawing];
    
    if (num_rendered != 0) {
        for (id windowController in self.windowControllers) {
            [windowController rendererDidRenderTiles];
        }
    }
}

- (void)makeWindowControllers {
    ICAKDrawingController* dc = [[ICAKDrawingController alloc] init];
    [dc setDocument:self];
    [self addWindowController:dc];
}

- (ICMDrawing*)drawing {
    return self->internal_drawing;
}

@end