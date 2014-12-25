#import <icCanvasManagerObjC.h>
#include <icCanvasManager.hpp>

namespace icCanvasManager {
    class ZoomToolObjCDelegate : public icCanvasManager::ZoomTool::Delegate, public icCanvasManager::RefCnt {
        id<ICMZoomToolDelegate> __strong _objc_delegate;
    public:
        ZoomToolObjCDelegate(id<ICMZoomToolDelegate> objc_delegate) : _objc_delegate(objc_delegate) {
        };
        
        virtual void changed_scroll_and_zoom(const double x, const double y, const double zoom) override {
            [this->_objc_delegate changedScrollX:x andY:y andZoom:zoom];
        };
        
        id<ICMZoomToolDelegate> get_wrapped_object() {
            return this->_objc_delegate;
        }
    };
}

@implementation ICMZoomTool {
    icCanvasManager::RefPtr<icCanvasManager::ZoomTool> _wrapped;
}

- (id)init {
    auto* btptr = new icCanvasManager::ZoomTool();
    
    self = [super initFromWrappedObject:(void*)static_cast<icCanvasManager::CanvasTool*>(btptr)];
    
    if (self != nil) {
        self->_wrapped = btptr;
    }
    
    return self;
};

- (id)initFromWrappedObject:(void*)optr {
    self = [super initFromWrappedObject:optr];
    
    if (self != nil) {
        self->_wrapped = (icCanvasManager::ZoomTool*)optr;
    }
    
    return self;
};

- (void)setDelegate:(id <ICMZoomToolDelegate>)del {
    auto* cppdel = new icCanvasManager::ZoomToolObjCDelegate(del);
    self->_wrapped->set_delegate(cppdel);
};
- (id <ICMZoomToolDelegate>)delegate {
    auto* cppdel = self->_wrapped->get_delegate();
    
    auto* objcwrap = dynamic_cast<icCanvasManager::ZoomToolObjCDelegate*>(cppdel);
    if (objcwrap) {
        return objcwrap->get_wrapped_object();
    } else {
        //TODO: Wrap CPP-native delegates
        /* NOTE: Not all delegates will be wrappable as reference counting is
         * not mandatory for delegates */
        return nil;
    }
};

- (void*)getWrappedObject {
    return (void*)self->_wrapped;
};

@end