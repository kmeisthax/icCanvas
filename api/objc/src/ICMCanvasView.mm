#import <icCanvasManagerObjC.h>
#include <icCanvasManager.hpp>

@implementation ICMCanvasView {
    icCanvasManager::RefPtr<icCanvasManager::CanvasView> _wrapped;
}

- (id)init {
    self = [super init];
    
    if (self != nil) {
        self->_wrapped = new icCanvasManager::CanvasView();
    }
    
    return self;
};

- (id)initFromWrappedObject:(void*)optr {
    self = [super init];
    
    if (self != nil) {
        self->_wrapped = (icCanvasManager::CanvasView*)optr;
    }
    
    return self;
};

- (void)attachDrawing:(ICMDrawing*)drawing {
    icCanvasManager::RefPtr<icCanvasManager::Drawing> cppdr = (icCanvasManager::Drawing*)[drawing getWrappedObject];
    
    self->_wrapped->attach_drawing(cppdr);
};

- (void)drawWithContext:(cairo_t*)context intoRects:(cairo_rectangle_list_t*)rectList {
    self->_wrapped->draw(context, rectList);
};

- (void)setSizeWidth:(const double)width andHeight:(const double)height andUiScale:(const double)ui_scale {
    self->_wrapped->set_size(width, height, ui_scale);
};

- (void)setSizeUiScale:(const double)ui_scale {
    self->_wrapped->set_size(ui_scale);
};

- (void)getSizeWidth:(double*)out_width andHeight:(double*)out_height andUiScale:(double*)out_ui_scale {
    self->_wrapped->get_size(out_width, out_height, out_ui_scale);
};

- (void)getMaximumSizeWidth:(double*)out_width andHeight:(double*)out_height {
    self->_wrapped->get_maximum_size(out_width, out_height);
};

- (void)getScaleExtentsMinimum:(double*)out_minscale andMaximum:(double*)out_maxscale {
    self->_wrapped->get_scale_extents(out_minscale, out_maxscale);
};

- (void)setScrollCenterX:(const double)x andY:(const double)y {
    self->_wrapped->set_scroll_center(x, y);
};

- (void)setZoom:(const double)vpixel_size {
    self->_wrapped->set_zoom(vpixel_size);
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