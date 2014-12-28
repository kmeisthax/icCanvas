#import <icCanvasManagerObjC.h>

#include <icCanvasManager.hpp>

@implementation ICMRenderScheduler {
    icCanvasManager::RefPtr<icCanvasManager::RenderScheduler> _wrapped;
}

- (id)init {
    self = [super init];
    
    if (self != nil) {
        self->_wrapped = new icCanvasManager::RenderScheduler();
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

- (void*)getWrappedObject {
    return (void*)self->_wrapped;
};

@end