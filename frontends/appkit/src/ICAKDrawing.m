#include <icCanvasAppKit.h>

@implementation ICAKDrawing {
    ICMDrawing* internal_drawing;
    ICMTileCache* tile_cache;

    NSTimer* background_timer;
    
    ICAKDockingController* _dock_ctrl;
    ICAKToolPaletteController* _tpal_ctrl;
}

- (id)init {
    self = [super init];
    
    if (self != nil) {
        self->tile_cache = [[ICMTileCache alloc] init];
        self->internal_drawing = [[ICMDrawing alloc] initWithTileCache:self->tile_cache];
        
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
    cairo_rectangle_t canvasRect;
    NSRect convertedRect;
    int num_rendered = [[[ICMApplication getInstance] renderScheduler] collectRequestForDrawing:self->internal_drawing canvasTileRect:&canvasRect];
    
    while (num_rendered > 0) {
        convertedRect.origin.x = canvasRect.x;
        convertedRect.origin.y = canvasRect.y;
        convertedRect.size.width = canvasRect.width;
        convertedRect.size.height = canvasRect.height;
        
        for (id windowController in self.windowControllers) {
            
            [windowController rendererDidRenderTilesOnCanvasRect:convertedRect];
        }
        
        num_rendered = [[[ICMApplication getInstance] renderScheduler] collectRequestForDrawing:self->internal_drawing canvasTileRect:&canvasRect];
    }
}

- (void)makeWindowControllers {
    ICAKDrawingController* dc = [[ICAKDrawingController alloc] initWithDocument:self];
    [self addWindowController:dc];

    ICAKDockableView* dCP = [self->_tpal_ctrl createDockableColorPanel];

    [dc.dock attachDockableView:[self->_tpal_ctrl createToolPaletteView] toEdge:ICAKDockEdgeTop];
    [dc.dock attachDockableView:dCP toEdge:ICAKDockEdgeLeft];
    
    [self->_dock_ctrl addDrawingController:dc];
}

- (ICMDrawing*)drawing {
    return self->internal_drawing;
}

- (ICMTileCache*)tileCache {
    return self->tile_cache;
}

- (void)setDockingController:(ICAKDockingController*)dock_ctrl {
    self->_dock_ctrl = dock_ctrl;
}

- (void)setToolPaletteController:(ICAKToolPaletteController*)tpal_ctrl {
    self->_tpal_ctrl = tpal_ctrl;
}

@end
