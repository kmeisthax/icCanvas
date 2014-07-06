#import <icCanvasManagerObjC.h>
#include <icCanvasManager.hpp>

@implementation ICMDrawing {
    icCanvasManager::Drawing* _wrapped;
}

- (id)init {
    self = [super init];
    
    if (self != nil) {
        self->_wrapped = new icCanvasManager::Drawing();
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

- (void)dealloc {
    delete self->_wrapped;
};

- (ICMBrushStroke*)strokeAtTime:(int) time {
    icCanvasManager::BrushStroke* bsptr = self->_wrapped->stroke_at_time(time);
    
    return [[ICMBrushStroke alloc] initFromWrappedObject:(void*)bsptr];
};

- (int)strokesCount {
    return self->_wrapped->strokes_count();
};

- (void*)getWrappedObject {
    return (void*)self->_wrapped;
};