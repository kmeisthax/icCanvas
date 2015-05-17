#import <icCanvasManagerObjC.h>
#include <icCanvasManager.hpp>

@implementation ICMDrawing {
    icCanvasManager::RefPtr<icCanvasManager::Drawing> _wrapped;
}

- (id)initWithTileCache:(ICMTileCache*)c {
    self = [super init];
    
    if (self != nil) {
        auto* cache = (icCanvasManager::TileCache*)[c getWrappedObject];
        self->_wrapped = new icCanvasManager::Drawing(cache);
    }
    
    return self;
};

- (id)initFromWrappedObject:(void*)optr {
    self = [super init];
    
    if (self != nil) {
        self->_wrapped = (icCanvasManager::Drawing*)optr;
    }
    
    return self;
};

- (ICMBrushStroke*)strokeAtTime:(int) time {
    return [[ICMBrushStroke alloc] initFromWrappedObject:self->_wrapped->stroke_at_time(time)];
};

- (int)strokesCount {
    return self->_wrapped->strokes_count();
};

- (void)appendStroke:(ICMBrushStroke*)stroke {
    icCanvasManager::RefPtr<icCanvasManager::BrushStroke> cppbr = (icCanvasManager::BrushStroke*)[stroke getWrappedObject];
    
    self->_wrapped->append_stroke(cppbr);
};

- (void*)getWrappedObject {
    return (void*)self->_wrapped;
};

@end
