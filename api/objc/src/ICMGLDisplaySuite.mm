#import <icCanvasManagerObjC.h>
#include <icCanvasManager.hpp>

#import <__icCanvasManagerObjCBridge.hpp>

@implementation ICMGLDisplaySuite {
    icCanvasManager::RefPtr<icCanvasManager::GL::DisplaySuite> _wrapped;
}

- (id)initWithContextManager:(id <ICMGLContextManager>)m andNullDrawable:(intptr_t)drawable {
    self = [super init];

    if (self != nil) {
        self->_wrapped = new icCanvasManager::GL::DisplaySuite(new icCanvasManager::GL::ContextManagerObjC(m), drawable);
    }

    return self;
};

- (id)initFromWrappedObject:(void*)optr {
    self = [super init];

    if (self != nil) {
        self->_wrapped = (icCanvasManager::GL::DisplaySuite*)optr;
    }

    return self;
};

- (void*)getWrappedObject {
    return (void*)self->_wrapped;
};

@end
