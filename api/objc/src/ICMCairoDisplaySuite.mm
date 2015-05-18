#import <icCanvasManagerObjC.h>
#include <icCanvasManager.hpp>

@implementation ICMCairoDisplaySuite {
    icCanvasManager::RefPtr<icCanvasManager::Cairo::DisplaySuite> _wrapped;
}

- (id)init {
    self = [super init];

    if (self != nil) {
        self->_wrapped = new icCanvasManager::Cairo::DisplaySuite();
    }

    return self;
};

- (id)initFromWrappedObject:(void*)optr {
    self = [super init];

    if (self != nil) {
        self->_wrapped = (icCanvasManager::Cairo::DisplaySuite*)optr;
    }

    return self;
};

- (void*)getWrappedObject {
    return (void*)self->_wrapped;
};

@end
