#import <icCanvasManagerObjC.h>
#include <icCanvasManager.hpp>

@implementation ICMApplication {
    icCanvasManager::Application* _wrapped;
}

+ (id)getInstance {
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

@end