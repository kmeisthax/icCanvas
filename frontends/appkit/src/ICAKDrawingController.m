#include <icCanvasAppKit.h>

@implementation ICAKDrawingController {
    ICAKCanvasView *cv;
    NSScrollView *scv;
    ICAKDock *dk;
    
    ICAKDockablePanel *panel1;
}

- (id)init {
    //Create test window
    NSWindow *window;
    NSRect r = {{100,100}, {400, 400}};
    window = [[NSWindow alloc] initWithContentRect:r styleMask:(NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask|NSFullSizeContentViewWindowMask) backing:NSBackingStoreBuffered defer:TRUE];
    
    self = [super initWithWindow:window];
    
    if (self != nil) {
        [window makeKeyAndOrderFront:nil];
        [window setCollectionBehavior:(window.collectionBehavior|NSWindowCollectionBehaviorFullScreenPrimary)];
        window.titlebarAppearsTransparent = YES;
        
        ICMDrawing* drawing = [[ICMDrawing alloc] init];

        self->cv = [[ICAKCanvasView alloc] initWithDrawing: drawing];
        self->scv = [[NSScrollView alloc] initWithFrame: [[self.window contentView] frame]];
        self->dk = [[ICAKDock alloc] init];
        
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
        
        [self->dk setDocumentView:self->scv];
        
        const CGFloat midX = NSMidX([[self->scv documentView] bounds]);
        const CGFloat midY = NSMidY([[self->scv documentView] bounds]);

        const CGFloat halfWidth = NSWidth([[self->scv contentView] frame]) / 2.0;
        const CGFloat halfHeight = NSHeight([[self->scv contentView] frame]) / 2.0;

        NSPoint newOrigin;
        if([[self->scv documentView] isFlipped])
        {
            newOrigin = NSMakePoint(midX - halfWidth, midY + halfHeight);
        }
        else
        {
            newOrigin = NSMakePoint(midX - halfWidth, midY - halfHeight);
        }
        [[self->scv documentView] scrollPoint:newOrigin];
        
        self->scv.allowsMagnification = YES;
        self->scv.maxMagnification = self->cv.maximumMagnification;
        self->scv.minMagnification = self->cv.minimumMagnification;

        [window setContentView:self->dk];
        
        for (int i = 0; i < 5; i++) {
            ICAKDockablePanel* pnl = [[ICAKDockablePanel alloc] init];
            pnl.label = [NSString stringWithFormat:@"Panel test %d", i + 1];
            
            NSButton* btn = [[NSButton alloc] init];
            btn.title = [NSString stringWithFormat:@"Action %d", i + 1];
            btn.buttonType = NSMomentaryPushInButton;
            
            pnl.contentView = btn;

            [self->dk attachDockableView:pnl toEdge:ICAKDockEdgeLeft];
        }
        
        ICAKDockableToolbar* tbl = [[ICAKDockableToolbar alloc] init];
        [tbl addButton];
        [tbl setButton:0 image:[NSImage imageNamed:NSImageNameActionTemplate]];
        
        [self->dk attachDockableView:tbl toEdge:ICAKDockEdgeTop];
    }
    
    return self;
}

- (void)setDocument:(NSDocument *)document {
    [self->cv setDrawing:[(id)document drawing]];
};

- (void)rendererDidRenderTiles {
    [self->scv setNeedsDisplay:YES];
};

- (ICAKDock*)dock {
    return self->dk;
};

@end