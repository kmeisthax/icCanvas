#include <icCanvasAppKit.h>

@implementation ICAKDrawingController {
    ICMDrawing *drawing;
    ICAKCanvasView *cv;
    NSScrollView *scv;
    ICAKDock *dk;
    
    ICAKDockablePanel *panel1;
    
    //Individual CanvasTool impls
    ICMBrushTool *btool;
    ICMZoomTool *ztool;

    //Various window-specific settings
    NSColor* currentColor;
}

- (id)initWithDocument:(ICAKDrawing *)document {
    //Create test window
    NSWindow *window;
    NSRect r = {{100,100}, {400, 400}};
    window = [[NSWindow alloc] initWithContentRect:r styleMask:(NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask|NSFullSizeContentViewWindowMask) backing:NSBackingStoreBuffered defer:TRUE];
    
    self = [super initWithWindow:window];
    
    if (self != nil) {
        [window makeKeyAndOrderFront:nil];
        [window setCollectionBehavior:(window.collectionBehavior|NSWindowCollectionBehaviorFullScreenPrimary)];
        window.titlebarAppearsTransparent = YES;
        
        self.document = document;
        
        self->cv = [[ICAKCanvasView alloc] initWithDrawing: self->drawing];
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
        
        self->btool = [[ICMBrushTool alloc] init];
        self->btool.delegate = self;
        
        self->ztool = [[ICMZoomTool alloc] init];
        self->ztool.delegate = self;
        
        [self selectBrushTool];

        self.currentColor = [NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    }
    
    return self;
}

- (void)setDocument:(NSDocument *)document {
    if ([document isKindOfClass:ICAKDrawing.class]) {
        self->drawing = [(ICAKDrawing*)document drawing];
        [self->cv setDrawing:[(ICAKDrawing*)document drawing]];
    }
};

- (void)rendererDidRenderTilesOnCanvasRect:(NSRect)rect {
    [self->cv setNeedsDisplayInCanvasRect:rect];
};

- (ICAKDock*)dock {
    return self->dk;
};

// Canvas tool selector methods
- (void)selectBrushTool {
    [self->btool prepareForReuse];
    self->cv.canvasTool = self->btool;
};
- (void)selectZoomTool {
    [self->ztool prepareForReuse];
    self->cv.canvasTool = self->ztool;
};

//Various CanvasTool delegate impls
- (void)brushToolCapturedStroke:(ICMBrushStroke*)stroke {
    CGFloat r, g, b, a;
    [self.currentColor getRed:&r green:&g blue:&b alpha:&a];
    [stroke setBrushTintRed:(int)(r * ICMBrushStrokeColorMax) green:(int)(g * ICMBrushStrokeColorMax) blue:(int)(b * ICMBrushStrokeColorMax)];
    stroke.brushOpacity = (int)(a * ICMBrushStrokeColorMax);

    cairo_rectangle_t bbox = stroke.boundingBox;
    
    [self->drawing appendStroke:stroke];
    [[[ICMApplication getInstance] renderScheduler] requestTilesOnDrawing:self->drawing inRect:bbox atSize:self->cv.internal.highestZoom atTime:self->drawing.strokesCount];
};

- (void)changedScrollX:(const double)x andY:(const double)y andZoom:(const double)zoom {
    double dscale = self->cv.internal.zoom;
    CGFloat mag_factor = dscale / zoom;
    
    self->scv.magnification = mag_factor;
    
    NSPoint newScrollPoint;
    NSRect dVisRect = self->scv.contentView.documentVisibleRect;
    
    newScrollPoint.x = (x / dscale) - (dVisRect.size.width / 2.0f);
    newScrollPoint.y = (y / dscale) - (dVisRect.size.height / 2.0f);
    
    [self->scv.contentView scrollToPoint:newScrollPoint];
};

//Brush settings
- (void)setCurrentColor:(NSColor*)color {
    self->currentColor = color;
};
- (NSColor*)currentColor {
    return self->currentColor;
};

@end
