#import <icCanvasManagerObjC.h>
#include <icCanvasManager.hpp>

@implementation ICMCanvasTool {
    icCanvasManager::RefPtr<icCanvasManager::CanvasTool> _wrapped;
}

- (id)initFromWrappedObject:(void*)optr {
    self = [super init];
    
    if (self != nil) {
        self->_wrapped = (icCanvasManager::CanvasTool*)optr;
    }
    
    return self;
};


- (void)setSizeWidth:(const double)width andHeight:(const double)height andUiScale:(const double)ui_scale andZoom:(const double)zoom {
    self->_wrapped->set_size(width, height, ui_scale, zoom);
};

- (void)setScrollCenterX:(const double)x andY:(const double)y {
    self->_wrapped->set_scroll_center(x, y);
};

- (void)mouseDownWithX:(const double)x andY:(const double)y andDeltaX:(const double)deltaX andDeltaY:(const double)deltaY {
    self->_wrapped->mouse_down(x, y, deltaX, deltaY);
};

- (void)mouseDragWithX:(const double)x andY:(const double)y andDeltaX:(const double)deltaX andDeltaY:(const double)deltaY {
    self->_wrapped->mouse_drag(x, y, deltaX, deltaY);
};

- (void)mouseUpWithX:(const double)x andY:(const double)y andDeltaX:(const double)deltaX andDeltaY:(const double)deltaY {
    self->_wrapped->mouse_up(x, y, deltaX, deltaY);
};

- (void*)getWrappedObject {
    return (void*)self->_wrapped;
};

@end