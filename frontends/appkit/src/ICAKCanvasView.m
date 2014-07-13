#import <icCanvasManagerObjC.h>
#import <icCanvasAppKit.h>

#include <cairo.h>
#include <cairo-quartz.h>

@implementation ICAKCanvasView {
    ICMCanvasView* internal;
    ICMDrawing* drawing;
}

- (id)initWithDrawing:(ICMDrawing*) theDrawing {
    self = [super init];
    
    if (self != nil) {
        self->internal = [[ICMCanvasView alloc] init];
        self->drawing = theDrawing;
        
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
    
    [self->internal setSizeWidth:self.bounds.size.width andHeight:self.bounds.size.height];
    [self->internal drawWithContext:ctxt inDirtyRect:cr_dirty];
    
    CGContextRestoreGState(cgContext);
    
    cairo_destroy(ctxt);
    cairo_surface_destroy(xrsurf);
};

@end