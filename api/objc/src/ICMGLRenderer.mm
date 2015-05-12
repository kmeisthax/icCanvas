#import <icCanvasManagerObjC.h>
#include <icCanvasManager.hpp>

namespace icCanvasManager {
    namespace GL {
        class ContextManagerObjC : public icCanvasManager::GL::ContextManager, public icCanvasManager::RefCnt {
            id<ICMGLContextManager> __strong _objc_delegate;
        public:
            ContextManagerObjC(id<ICMGLContextManager> objc_delegate) : _objc_delegate(objc_delegate) {
            };

            virtual icCanvasManager::GL::ContextManager::CONTEXT create_main_context(int major, int minor) override {
                return [this->_objc_delegate createMainContextWithVersionMajor:major andMinor:minor];
            };

            virtual icCanvasManager::GL::ContextManager::CONTEXT create_sub_context() override {
                return [this->_objc_delegate createSubContext];
            };

            virtual void shutdown_sub_context(icCanvasManager::GL::ContextManager::CONTEXT ctxt) override {
                [this->_objc_delegate shutdownSubContext:ctxt];
            };

            virtual icCanvasManager::GL::ContextManager::CONTEXT get_current() override {
                return [this->_objc_delegate getCurrent];
            };

            virtual icCanvasManager::GL::ContextManager::CONTEXT make_current(icCanvasManager::GL::ContextManager::CONTEXT ctxt, DRAWABLE drawable) override {
                return [this->_objc_delegate makeCurrent:ctxt withDrawable:drawable];
            };

            virtual void(*get_proc_address(char* procName)) () override {
                return [this->_objc_delegate getProcAddress:procName];
            };

            virtual DRAWABLE create_null_drawable() override {
                return [this->_objc_delegate createNullDrawable];
            };
        };
    }
}

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
