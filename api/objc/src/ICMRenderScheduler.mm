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

- (void)backgroundTick {
    self->_wrapped->background_tick();
};

- (int)collectRequestsForDrawing:(ICMDrawing*)d {
    icCanvasManager::RefPtr<icCanvasManager::Drawing> inner_d = (icCanvasManager::Drawing*)[d getWrappedObject];
    return self->_wrapped->collect_requests(inner_d);
};

- (void*)getWrappedObject {
    return (void*)self->_wrapped;
};

@end