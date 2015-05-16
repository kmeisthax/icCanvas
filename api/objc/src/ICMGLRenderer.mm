#import <icCanvasManagerObjC.h>
#include <icCanvasManager.hpp>

#import <__icCanvasManagerObjCBridge.hpp>

@implementation ICMGLRenderer {
    icCanvasManager::RefPtr<icCanvasManager::GL::Renderer> _wrapped;
}

- (id)initWithContextManager:(id <ICMGLContextManager>)m andContext:(intptr_t)ctxt andDrawable:(intptr_t)drawable {
    self = [super init];

    if (self != nil) {
        self->_wrapped = new icCanvasManager::GL::Renderer(new icCanvasManager::GL::ContextManagerObjC(m), ctxt, drawable);
    }

    return self;
};

- (id)initFromWrappedObject:(void*)optr {
    self = [super init];

    if (self != nil) {
        self->_wrapped = (icCanvasManager::GL::Renderer*)optr;
    }

    return self;
};

- (void*)getWrappedObject {
    return (void*)self->_wrapped;
};

@end
