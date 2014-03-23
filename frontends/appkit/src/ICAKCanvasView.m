#import <icCanvasManagerObjC.h>
#import <icCanvasAppKit.h>

#include <cairo.h>

@implementation ICAKCanvasView {
    ICMRenderer* renderer;
}

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if (self != nil) {
        self->renderer = [[ICMRenderer alloc] init];
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
    
    [self.renderer enterSurfaceAtX:0 andY:0 withZoom:65535 andSurface:xrsurf withHeight:self.bounds.size.height andWidth:self.bounds.size.width];
    
    ICMBrushStroke* bsptr = [[ICMBrushStroke alloc] init];
    [bsptr penBeginWithX:32 andY:16];
    [self.renderer drawStroke:bsptr];
};

@end