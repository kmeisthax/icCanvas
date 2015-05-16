#import <icCanvasManagerObjC.h>
#include <icCanvasManager.hpp>

@implementation ICMDisplaySuite {
    icCanvasManager::RefPtr<icCanvasManager::DisplaySuite> _wrapped;
}

- (id)initFromWrappedObject:(void*)optr {
    self = [super init];

    if (self != nil) {
        self->_wrapped = (icCanvasManager::DisplaySuite*)optr;
    }

    return self;
};

- (void*)getWrappedObject {
    return (void*)self->_wrapped;
};

@end
