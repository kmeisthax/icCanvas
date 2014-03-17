#import <icCanvasManagerObjC.h>
#include <icCanvasManager.hpp>

@implementation ICMRenderer {
    icCanvasManager::Renderer* _wrapped;
}

- (id)init {
    self = [super init];
    
    if (self != nil) {
        self->_wrapped = new icCanvasManager::Renderer();
    }
    
    return self;
};

- (void)dealloc {
    delete self->_wrapped;
    [super dealloc];
};

- (void)enterImageSurfaceAtX:(const int32_t)x andY:(const int32_t)y withZoom:(const int32_t)zoom andSurface:(cairo_surface_t*)xrsurf {
    self->_wrapped.enterImageSurface(x, y, zoom, xrsurf);
};

- (void)drawStroke:(ICMBrushStroke*)br {
    icCanvasManager::BrushStroke* cppbr = (icCanvasManager::BrushStroke*)[br getWrappedObject];
    self->drawStroke(&cppbr);
};

- (void*)getWrappedObject {
    return (void*)self->_wrapped;
};

@end