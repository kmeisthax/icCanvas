#import <icCanvasManagerObjC.h>
#include <icCanvasManager.hpp>

@implementation ICMApplication {
    icCanvasManager::Application* _wrapped;
}

+ (ICMApplication*)getInstance {
    return [[ICMApplication alloc] initFromWrappedObject:(void*)&icCanvasManager::Application::get_instance()];
};

- (id)initFromWrappedObject:(void*)optr {
    self = [super init];
    
    if (self != nil) {
        self->_wrapped = (icCanvasManager::Application*)optr;
    }
    
    return self;
};

- (void)backgroundTick {
    self->_wrapped->background_tick();
};

- (void*)getWrappedObject {
    return (void*)self->_wrapped;
};

- (ICMRenderScheduler*)renderScheduler {
    return [[ICMRenderScheduler alloc] initFromWrappedObject:(void*)self->_wrapped->get_render_scheduler()];
};

@end