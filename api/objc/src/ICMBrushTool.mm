#import <icCanvasManagerObjC.h>
#include <icCanvasManager.hpp>

namespace icCanvasManager {
    class BrushToolObjCDelegate : public icCanvasManager::BrushTool::Delegate, public icCanvasManager::RefCnt {
        id<ICMBrushToolDelegate> __strong _objc_delegate;
    public:
        BrushToolObjCDelegate(id<ICMBrushToolDelegate> objc_delegate) : _objc_delegate(objc_delegate) {
        };
        
        virtual void captured_stroke(RefPtr<BrushStroke> stroke) {
            ICMBrushStroke* bswrap = [[ICMBrushStroke alloc] initFromWrappedObject:(void*)stroke];
            [this->_objc_delegate brushToolCapturedStroke:bswrap];
        };
        
        id<ICMBrushToolDelegate> get_wrapped_object() {
            return this->_objc_delegate;
        }
    };
}

@implementation ICMBrushTool {
    icCanvasManager::RefPtr<icCanvasManager::BrushTool> _wrapped;
}

- (id)init {
    auto* btptr = new icCanvasManager::BrushTool();
    
    self = [super initFromWrappedObject:(void*)static_cast<icCanvasManager::CanvasTool*>(btptr)];
    
    if (self != nil) {
        self->_wrapped = btptr;
    }
    
    return self;
};

- (id)initFromWrappedObject:(void*)optr {
    self = [super initFromWrappedObject:optr];
    
    if (self != nil) {
        self->_wrapped = (icCanvasManager::BrushTool*)optr;
    }
    
    return self;
};

- (void)setDelegate:(id <ICMBrushToolDelegate>)del {
    auto* cppdel = new icCanvasManager::BrushToolObjCDelegate(del);
    self->_wrapped->set_delegate(cppdel);
};
- (id <ICMBrushToolDelegate>)delegate {
    auto* cppdel = self->_wrapped->get_delegate();
    
    auto* objcwrap = dynamic_cast<icCanvasManager::BrushToolObjCDelegate*>(cppdel);
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