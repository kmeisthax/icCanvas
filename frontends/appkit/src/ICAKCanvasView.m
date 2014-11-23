#import <icCanvasManagerObjC.h>
#import <icCanvasAppKit.h>

#include <cairo.h>
#include <cairo-quartz.h>

@implementation ICAKCanvasView {
    ICMCanvasView* internal;
    ICMDrawing* drawing;
    ICMBrushTool* current_tool;
}

- (id)initWithDrawing:(ICMDrawing*) theDrawing {
    self = [super init];
    
    if (self != nil) {
        self->internal = [[ICMCanvasView alloc] init];
        self->drawing = theDrawing;
        self->current_tool = [[ICMBrushTool alloc] init];
        
        [self->internal attachDrawing:self->drawing];
    }
    
    return self;
};

- (id)initWithFrame:(NSRect)frameRect andDrawing:(ICMDrawing*) theDrawing {
    self = [super initWithFrame:frameRect];
    
    if (self != nil) {
        self->internal = [[ICMCanvasView alloc] init];
        self->drawing = theDrawing;
        
        [self->internal attachDrawing:self->drawing];
    }
    
    return self;
};

- (BOOL)isFlipped {
    return YES;
};

- (void)drawRect:(NSRect)dirtyRect {
    //Not-so-toll-free bridging
    NSGraphicsContext* cocoaContext = [NSGraphicsContext currentContext];
    CGContextRef cgContext = (CGContextRef)[cocoaContext graphicsPort];
    
    CGContextSaveGState(cgContext);
    
    cairo_surface_t* xrsurf = cairo_quartz_surface_create_for_cg_context(cgContext, (unsigned int)self.bounds.size.width, (unsigned int)self.bounds.size.height);
    cairo_t* ctxt = cairo_create(xrsurf);
    cairo_rectangle_t cr_dirty = {dirtyRect.origin.x, dirtyRect.origin.y, dirtyRect.size.width, dirtyRect.size.height};
    
    const NSRect* dirty_list;
    NSInteger dirty_list_count;
    [self getRectsBeingDrawn:&dirty_list count:&dirty_list_count];
    
    //Manually create our own cairo rectangle list since Cairo thinks
    //Apple's scale matrixes make the cliplist unrepresentable
    int rectlist_size = sizeof(cairo_rectangle_t) * dirty_list_count;
    assert(rectlist_size != 0); //WTF BOOOM
    
    cairo_rectangle_t* cairo_rects = (cairo_rectangle_t*)malloc(rectlist_size);
    assert(cairo_rects);
    
    for (NSInteger i = 0; i < dirty_list_count; i++) {
        cairo_rects[i].x = dirty_list[i].origin.x;
        cairo_rects[i].y = dirty_list[i].origin.y;
        cairo_rects[i].width = dirty_list[i].size.width;
        cairo_rects[i].height = dirty_list[i].size.height;
    }
    
    cairo_rectangle_list_t theList;
    theList.rectangles = cairo_rects;
    theList.num_rectangles = dirty_list_count;
    
    NSSize testSize = {1.0, 1.0};
    NSSize scaleSize = [self convertSizeToBacking:testSize];
    
    [self->internal setSizeWidth:self.bounds.size.width andHeight:self.bounds.size.height andUiScale:scaleSize.width];
    [self->internal drawWithContext:ctxt intoRects:&theList];
    
    free(cairo_rects);
    
    CGContextRestoreGState(cgContext);
    
    cairo_destroy(ctxt);
    cairo_surface_destroy(xrsurf);
};

- (void)mouseDown:(NSEvent*)theEvent {
    NSPoint event_location = [theEvent locationInWindow];
    NSPoint local_point = [self convertPoint:event_location fromView:nil];
    
    [self->current_tool mouseDownWithX:local_point.x andY:local_point.y andDeltaX:theEvent.deltaX andDeltaY:theEvent.deltaY];
};

- (void)mouseDragged:(NSEvent*)theEvent {
    NSPoint event_location = [theEvent locationInWindow];
    NSPoint local_point = [self convertPoint:event_location fromView:nil];
    
    [self->current_tool mouseDragWithX:local_point.x andY:local_point.y andDeltaX:theEvent.deltaX andDeltaY:theEvent.deltaY];
};

- (void)mouseUp:(NSEvent*)theEvent {
    NSPoint event_location = [theEvent locationInWindow];
    NSPoint local_point = [self convertPoint:event_location fromView:nil];
    
    [self->current_tool mouseUpWithX:local_point.x andY:local_point.y andDeltaX:theEvent.deltaX andDeltaY:theEvent.deltaY];
};

- (void)brushToolCapturedStroke:(ICMBrushStroke*)stroke {
    [self->drawing appendStroke:stroke];
};

- (void)sizeToFitCanvas {
    NSSize testSize = {1.0, 1.0};
    NSSize scaleSize = [self convertSizeToBacking:testSize];
    
    double pwidth, pheight;
    [self->internal setSizeUiScale:scaleSize.width];
    [self->internal getSizeWidth:&pwidth andHeight:&pheight andUiScale:NULL];
    
    NSRect bounds = {-pwidth/2.0, -pheight/2.0, pwidth/2.0, pheight/2.0};
    
    [self setFrame: bounds];
};

- (void)setDrawing:(ICMDrawing*)newdrawing {
    self->drawing = newdrawing;
    [self->internal attachDrawing:newdrawing];
};

- (ICMDrawing*)drawing {
    return self->drawing;
};

- (double)minimumMagnification {
    double minscale;
    [self->internal getScaleExtentsMinimum:&minscale andMaximum:NULL];
    return minscale;
};
- (double)maximumMagnification {
    double maxscale;
    [self->internal getScaleExtentsMinimum:NULL andMaximum:&maxscale];
    return maxscale;
};

@end