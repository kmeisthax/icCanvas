#import <icCanvasManagerObjC.h>
#include <icCanvasManager.hpp>

@implementation ICMCairoRenderer {
    icCanvasManager::RefPtr<icCanvasManager::Cairo::Renderer> _wrapped;
}

- (id)init {
    self = [super init];

    if (self != nil) {
        self->_wrapped = new icCanvasManager::Cairo::Renderer();
    }

    return self;
};

- (id)initFromWrappedObject:(void*)optr {
    self = [super init];

    if (self != nil) {
        self->_wrapped = (icCanvasManager::Cairo::Renderer*)optr;
    }

    return self;
};

- (void*)getWrappedObject {
    return (void*)self->_wrapped;
};

@end
