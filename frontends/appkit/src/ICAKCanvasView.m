#import <icCanvasManagerObjC.h>
#import <icCanvasAppKit.h>

#include <cairo.h>

@implementation ICAKCanvasView {
    ICMRenderer* renderer;
    ICMDrawing* drawing;
}

- (id)initWithDrawing:(ICMDrawing*) drawing {
    self = [super init];
    
    if (self != nil) {
        self->renderer = [[ICMRenderer alloc] init];
        self->drawing = drawing;
    }
    
    return self;
};

- (id)initWithFrame:(NSRect)frameRect andDrawing:(ICMDrawing*) drawing {
    self = [super initWithFrame:frameRect];
    
    if (self != nil) {
        self->renderer = [[ICMRenderer alloc] init];
        self->drawing = drawing;
    }
    
    return self;
};

- (void)drawRect:(NSRect)dirtyRect {
    //Not-so-toll-free bridging
    NSGraphicsContext* cocoaContext = [NSGraphicsContext currentContext];
    CGContextRef cgContext = (CGContextRef)[cocoaContext graphicsPort];
    
    CGContextTranslateCTM(cgContext, 0.0, self.bounds.size.height);
    CGContextScaleCTM(cgContext, 1.0, -1.0);
    cairo_surface_t* xrsurf = cairo_quartz_surface_create_for_cg_context(cgContext, self.bounds.size.width, self.bounds.size.height);
    
    [self->renderer enterSurfaceAtX:0 andY:0 withZoom:65535 andSurface:xrsurf withHeight:self.bounds.size.height andWidth:self.bounds.size.width];
    
    for (int i = 0; i < [self->drawing strokesCount]; i++) {
        [self->renderer drawStroke:[self->drawing strokeAtTime:i]];
    }
};

@end