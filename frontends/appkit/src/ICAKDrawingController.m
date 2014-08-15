#include <icCanvasAppKit.h>

@implementation ICAKDrawingController {
    ICAKCanvasView *cv;
    NSScrollView *scv;
}

- (id)init {
    //Create test window
    NSWindow *window;
    NSRect r = {{100,100}, {250, 250}};
    window = [[NSWindow alloc] initWithContentRect:r styleMask:(NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask) backing:NSBackingStoreBuffered defer:TRUE];
    
    self = [super initWithWindow:window];
    
    if (self != nil) {
        [window makeKeyAndOrderFront:nil];
        [window setCollectionBehavior:(window.collectionBehavior|NSWindowCollectionBehaviorFullScreenPrimary)];

        ICMDrawing* drawing = [[ICMDrawing alloc] init];

        self->cv = [[ICAKCanvasView alloc] initWithDrawing: drawing];
        self->scv = [[NSScrollView alloc] initWithFrame: [[self.window contentView] frame]];

        NSPoint center = {0,0};
        [self->cv sizeToFitCanvas];

        [self->scv setHasVerticalScroller:YES];
        [self->scv setHasHorizontalScroller:YES];
        [self->scv setBorderType:NSNoBorder];
        [self->scv setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
        [self->scv setDocumentView:self->cv];
        [self->scv setHasHorizontalRuler:YES];
        [self->scv setHasVerticalRuler:YES];
        [self->scv setRulersVisible:YES];
        [self->scv setDrawsBackground:NO];
        [[self->scv documentView] scrollPoint:center];
        
        self->scv.allowsMagnification = YES;
        self->scv.maxMagnification = 8.0;
        self->scv.minMagnification = 0.125;

        [window setContentView:self->scv];
    }
    
    return self;
}

- (void)setDocument:(NSDocument *)document {
    [self->cv setDrawing:[(id)document drawing]];
};

- (void)rendererDidRenderTiles {
    [self->scv setNeedsDisplay:YES];
};

@end