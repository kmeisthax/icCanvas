#import <icCanvasManagerObjC.h>
#include <icCanvasManager.hpp>

@implementation ICMRenderer {
    icCanvasManager::RefPtr<icCanvasManager::Renderer> _wrapped;
}

- (id)initFromWrappedObject:(void*)optr {
    self = [super init];
    
    if (self != nil) {
        self->_wrapped = (icCanvasManager::Renderer*)optr;
    }
    
    return self;
};

- (void)drawStroke:(ICMBrushStroke*)br {
    icCanvasManager::RefPtr<icCanvasManager::BrushStroke> cppbr = (icCanvasManager::BrushStroke*)[br getWrappedObject];
    self->_wrapped->draw_stroke(cppbr);
};

- (void*)getWrappedObject {
    return (void*)self->_wrapped;
};

@end
