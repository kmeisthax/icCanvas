#import <icCanvasManagerObjC.h>

#include <icCanvasManager.hpp>

@implementation ICMRenderScheduler {
    icCanvasManager::RefPtr<icCanvasManager::RenderScheduler> _wrapped;
}

- (id)initWithApplication:(ICMApplication*)appWrap {
    self = [super init];
    
    if (self != nil) {
        icCanvasManager::Application* inner_app = (icCanvasManager::Application*)[appWrap getWrappedObject];
        self->_wrapped = new icCanvasManager::RenderScheduler(inner_app);
    }
    
    return self;
};

- (id)initFromWrappedObject:(void*)optr {
    self = [super init];
    
    if (self != nil) {
        self->_wrapped = (icCanvasManager::RenderScheduler*)optr;
    }
    
    return self;
};

- (ICMRenderer*)renderer {
    auto* r = self->_wrapped->renderer();
    return [[ICMRenderer alloc] initFromWrappedObject:(void+)r];
};

- (void)setRenderer:(ICMRenderer*)r {
    self->_wrapped->set_renderer((icCanvasManager::Renderer*)[r getWrappedObject]);
};

- (void)requestTileOnDrawing:(ICMDrawing*)d atX:(int)x andY:(int)y atSize:(int)size atTime:(int)time {
    icCanvasManager::RefPtr<icCanvasManager::Drawing> inner_d = (icCanvasManager::Drawing*)[d getWrappedObject];
    self->_wrapped->request_tile(inner_d, x, y, size, time);
};

- (void)requestTilesOnDrawing:(ICMDrawing*)d inRect:(cairo_rectangle_t)rect atSize:(int)size atTime:(int)time {
    icCanvasManager::RefPtr<icCanvasManager::Drawing> inner_d = (icCanvasManager::Drawing*)[d getWrappedObject];
    self->_wrapped->request_tiles(inner_d, rect, size, time);
};

- (void)backgroundTick {
    self->_wrapped->background_tick();
};

- (int)collectRequestForDrawing:(ICMDrawing*)d canvasTileRect:(cairo_rectangle_t*)out_tile_rect {
    icCanvasManager::RefPtr<icCanvasManager::Drawing> inner_d = (icCanvasManager::Drawing*)[d getWrappedObject];
    return self->_wrapped->collect_request(inner_d, out_tile_rect);
};

- (void)revokeRequestForDrawing:(ICMDrawing*)d xMin:(int)x_min yMin:(int)y_min xMax:(int)x_max yMax:(int)y_max isInverse:(BOOL)is_inverse {
    icCanvasManager::RefPtr<icCanvasManager::Drawing> inner_d = (icCanvasManager::Drawing*)[d getWrappedObject];
    return self->_wrapped->revoke_request(inner_d, x_min, y_min, x_max, y_max, is_inverse);
};

- (void)revokeRequestForDrawing:(ICMDrawing*)d zoomMin:(int)z_min zoomMax:(int)z_max isInverse:(BOOL)is_inverse {
    icCanvasManager::RefPtr<icCanvasManager::Drawing> inner_d = (icCanvasManager::Drawing*)[d getWrappedObject];
    return self->_wrapped->revoke_request(inner_d, z_min, z_max, is_inverse);
};

- (void*)getWrappedObject {
    return (void*)self->_wrapped;
};

@end
