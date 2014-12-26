#import <icCanvasManagerObjC.h>
#import <icCanvasAppKit.h>

#include <cairo.h>
#include <cairo-quartz.h>

@interface ICAKCanvasView (Private)

- (void)scrollPointDidChange:(NSNotification*)notification;
- (void)updateCurrentToolWithVisibleRect:(NSRect)rect andMagnification:(CGFloat)zoom;

@end

@implementation ICAKCanvasView {
    ICMCanvasView* internal;
    ICMDrawing* drawing;
    ICMCanvasTool* current_tool;
    
    BOOL _is_scrolling_view;
}

- (id)initWithDrawing:(ICMDrawing*) theDrawing {
    self = [super init];
    
    if (self != nil) {
        self->internal = [[ICMCanvasView alloc] init];
        self->drawing = theDrawing;
        self->current_tool = nil;
        
        [self->internal attachDrawing:self->drawing];
        
        self->_is_scrolling_view = FALSE;
    }
    
    return self;
};

- (id)initWithFrame:(NSRect)frameRect andDrawing:(ICMDrawing*) theDrawing {
    self = [super initWithFrame:frameRect];
    
    if (self != nil) {
        self->internal = [[ICMCanvasView alloc] init];
        self->drawing = theDrawing;
        
        [self->internal attachDrawing:self->drawing];
        
        self->_is_scrolling_view = FALSE;
    }
    
    return self;
};

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
};

- (BOOL)isFlipped {
    return YES;
};

- (void)viewWillMoveToSuperview:(NSView*)new_superview {
    if (self->_is_scrolling_view) {
        [NSNotificationCenter.defaultCenter removeObserver:self name:NSViewBoundsDidChangeNotification object:self.superview];
        
        if ([self.superview.superview isKindOfClass:NSScrollView.class]) {
            [NSNotificationCenter.defaultCenter removeObserver:self name:NSScrollViewDidEndLiveMagnifyNotification
 object:self.superview.superview];
        }
    }
    
    if (new_superview == nil) {
        self->_is_scrolling_view = FALSE;
        return;
    }
    
    self->_is_scrolling_view = [new_superview isKindOfClass:NSClipView.class];
    if (self->_is_scrolling_view) {
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(scrollPointDidChange:) name:NSViewBoundsDidChangeNotification object:new_superview];
        
        if ([self.superview.superview isKindOfClass:NSScrollView.class]) {
            [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(magnificationDidChange:) name:NSScrollViewDidEndLiveMagnifyNotification object:new_superview.superview];
        }
    }
}

- (void)scrollPointDidChange:(NSNotification*)notification {
    NSClipView* clip_view = notification.object;
    
    NSRect windowRect = clip_view.documentVisibleRect;
    CGFloat magnification = 1.0f;
    
    if ([clip_view.superview isKindOfClass:NSScrollView.class]) {
        magnification = ((NSScrollView*)clip_view.superview).magnification;
    }
    
    [self updateCurrentToolWithVisibleRect:windowRect andMagnification:magnification];
};

- (void)magnificationDidChange:(NSNotification*)notification {
    NSScrollView* scroll_view = notification.object;
    NSClipView* clip_view = scroll_view.contentView;
    
    NSRect windowRect = clip_view.documentVisibleRect;
    CGFloat magnification = scroll_view.magnification;
    
    [self updateCurrentToolWithVisibleRect:windowRect andMagnification:magnification];
}

- (void)setFrame:(NSRect)rekt {
    super.frame = rekt;
    
    NSSize testSize = {1.0, 1.0};
    NSSize scaleSize = [self convertSizeToBacking:testSize];
    
    [self->internal setSizeWidth:rekt.size.width andHeight:rekt.size.height andUiScale:scaleSize.width];
    
    if (self->current_tool != nil) {
        //Determine if the CanvasView is scrolling or not
        if ([self.superview isKindOfClass:NSClipView.class]) {
            NSClipView* clip_view = (NSClipView*)self.superview;
            
            NSRect windowRect = clip_view.documentVisibleRect;
            CGFloat magnification = 1.0f;
            
            if ([clip_view.superview isKindOfClass:NSScrollView.class]) {
                magnification = ((NSScrollView*)clip_view.superview).magnification;
            }
            
            [self updateCurrentToolWithVisibleRect:windowRect andMagnification:magnification];
        } else {
            //Some other kind of superview. Let's use frame parameters.
            [self->current_tool setSizeWidth:rekt.size.width andHeight:rekt.size.height andUiScale:scaleSize.width andZoom:self->internal.zoom];
        }
    }
};

- (void)updateCurrentToolWithVisibleRect:(NSRect)rect andMagnification:(CGFloat)zoom {
    //HINTS: The visible rect takes into account the zoom factor.
    //Multiply by zoom to get the rect the user sees.
    
    NSSize trueSize = rect.size;
    trueSize.width *= zoom;
    trueSize.height *= zoom;
    
    NSPoint centerPt = rect.origin;
    centerPt.x = (self.frame.size.width / -2.0 + centerPt.x + rect.size.width / 2.0f) * zoom;
    centerPt.y = (self.frame.size.height / -2.0 + centerPt.y + rect.size.height / 2.0f) * zoom;
    
    NSSize testSize = {1.0, 1.0};
    NSSize scaleSize = [self convertSizeToBacking:testSize];
    
    [self->current_tool setSizeWidth:trueSize.width andHeight:trueSize.height andUiScale:scaleSize.width andZoom:self->internal.zoom / zoom];
    [self->current_tool setScrollCenterX:centerPt.x andY:centerPt.y];
}

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
    
    [self->internal drawWithContext:ctxt intoRects:&theList];
    
    free(cairo_rects);
    
    CGContextRestoreGState(cgContext);
    
    cairo_destroy(ctxt);
    cairo_surface_destroy(xrsurf);
};

- (void)mouseDown:(NSEvent*)theEvent {
    NSPoint event_location = [theEvent locationInWindow];
    NSPoint local_point = [self convertPoint:event_location fromView:nil];
    
    if (self->current_tool != nil) {
        [self->current_tool mouseDownWithX:local_point.x andY:local_point.y andDeltaX:theEvent.deltaX andDeltaY:theEvent.deltaY];
    }
};

- (void)mouseDragged:(NSEvent*)theEvent {
    NSPoint event_location = [theEvent locationInWindow];
    NSPoint local_point = [self convertPoint:event_location fromView:nil];
    
    if (self->current_tool != nil) {
        [self->current_tool mouseDragWithX:local_point.x andY:local_point.y andDeltaX:theEvent.deltaX andDeltaY:theEvent.deltaY];
    }
};

- (void)mouseUp:(NSEvent*)theEvent {
    NSPoint event_location = [theEvent locationInWindow];
    NSPoint local_point = [self convertPoint:event_location fromView:nil];
    
    if (self->current_tool != nil) {
        [self->current_tool mouseUpWithX:local_point.x andY:local_point.y andDeltaX:theEvent.deltaX andDeltaY:theEvent.deltaY];
    }
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

- (void)setCanvasTool:(ICMCanvasTool*)ctool {
    self->current_tool = ctool;
    
    [self->current_tool prepareForReuse];
};

@end