#import <Cocoa/Cocoa.h>

#include <cairo.h>

@interface ICMRenderer : NSObject

- (id)init;
- (id)initFromWrappedObject:(void*)optr;

- (void)enterSurfaceAtX:(const int32_t)x andY:(const int32_t)y withZoom:(const int32_t)zoom andSurface:(cairo_surface_t*)xrsurf withHeight:(const int)height andWidth:(const int)width;
- (void)enterImageSurfaceAtX:(const int32_t)x andY:(const int32_t)y withZoom:(const int32_t)zoom andSurface:(cairo_surface_t*)xrsurf;
- (void)drawStroke:(ICMBrushStroke*)br;

- (void*)getWrappedObject;

@end
