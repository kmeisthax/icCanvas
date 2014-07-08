#import <icCanvasManagerObjC.h>
#import <icCanvasAppKit.h>

#include <cairo.h>
#include <cairo-quartz.h>

@implementation ICAKCanvasView {
    ICMRenderer* renderer;
    ICMDrawing* drawing;
}

- (id)initWithDrawing:(ICMDrawing*) theDrawing {
    self = [super init];
    
    if (self != nil) {
        self->renderer = [[ICMRenderer alloc] init];
        self->drawing = theDrawing;
    }
    
    return self;
};

- (id)initWithFrame:(NSRect)frameRect andDrawing:(ICMDrawing*) theDrawing {
    self = [super initWithFrame:frameRect];
    
    if (self != nil) {
        self->renderer = [[ICMRenderer alloc] init];
        self->drawing = theDrawing;
    }
    
    return self;
};

- (void)drawRect:(NSRect)dirtyRect {
    //Not-so-toll-free bridging
    NSGraphicsContext* cocoaContext = [NSGraphicsContext currentContext];
    CGContextRef cgContext = (CGContextRef)[cocoaContext graphicsPort];
    
    CGContextTranslateCTM(cgContext, 0.0, self.bounds.size.height);
    CGContextScaleCTM(cgContext, 1.0, -1.0);
    cairo_surface_t* xrsurf = cairo_quartz_surface_create_for_cg_context(cgContext, (unsigned int)self.bounds.size.width, (unsigned int)self.bounds.size.height);
    
    [self->renderer enterSurfaceAtX:0 andY:0 withZoom:14 andSurface:xrsurf withHeight:self.bounds.size.height andWidth:self.bounds.size.width];
    
    for (int i = 0; i < [self->drawing strokesCount]; i++) {
        [self->renderer drawStroke:[self->drawing strokeAtTime:i]];
    }
};

@end