#import <icCanvasManagerObjC.h>
#include <icCanvasManager.hpp>

namespace icCanvasManager {
    class ApplicationObjCDelegate : public icCanvasManager::Application::Delegate, public icCanvasManager::RefCnt {
        id<ICMApplicationDelegate> __strong _objc_delegate;
    public:
        ApplicationObjCDelegate(id<ICMApplicationDelegate> objc_delegate) : _objc_delegate(objc_delegate) {
        };
        
        virtual void enable_background_ticks() override {
            [this->_objc_delegate enableBackgroundTicks];
        };
        
        virtual void disable_background_ticks() override {
            [this->_objc_delegate disableBackgroundTicks];
        };
        
        id<ICMApplicationDelegate> get_wrapped_object() {
            return this->_objc_delegate;
        }
    };
}

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

- (void)setDelegate:(id <ICMApplicationDelegate>)del {
    auto* cppdel = new icCanvasManager::ApplicationObjCDelegate(del);
    self->_wrapped->set_delegate(cppdel);
};
- (id <ICMApplicationDelegate>)delegate {
    auto* cppdel = self->_wrapped->get_delegate();
    
    auto* objcwrap = dynamic_cast<icCanvasManager::ApplicationObjCDelegate*>(cppdel);
    if (objcwrap) {
        return objcwrap->get_wrapped_object();
    } else {
        //TODO: Wrap CPP-native delegates
        /* NOTE: Not all delegates will be wrappable as reference counting is
         * not mandatory for delegates */
        return nil;
    }
};

@end