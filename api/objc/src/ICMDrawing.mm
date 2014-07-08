#import <icCanvasManagerObjC.h>
#include <icCanvasManager.hpp>

@implementation ICMDrawing {
    icCanvasManager::RefPtr<icCanvasManager::Drawing> _wrapped;
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

- (ICMBrushStroke*)strokeAtTime:(int) time {
    return [[ICMBrushStroke alloc] initFromWrappedObject:self->_wrapped->stroke_at_time(time)];
};

- (int)strokesCount {
    return self->_wrapped->strokes_count();
};

- (void*)getWrappedObject {
    return (void*)self->_wrapped;
};

@end