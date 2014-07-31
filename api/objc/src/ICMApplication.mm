#import <icCanvasManagerObjC.h>
#include <icCanvasManager.hpp>

@implementation ICMApplication {
    icCanvasManager::RefPtr<icCanvasManager::Application> _wrapped;
}

- (id)init {
    self = [super init];
    
    if (self != nil) {
        self->_wrapped = new icCanvasManager::Application();
    }
    
    return self;
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