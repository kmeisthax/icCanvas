#import <icCanvasManagerObjC.h>

@implementation ICMSplineFitter {
    icCanvasManager::RefPtr<icCanvasManager::SplineFitter> _wrapped;
}

- (id)init {
    self = [super init];
    
    if (self != nil) {
        self->_wrapped = new icCanvasManager::SplineFitter();
    }
    
    return self;
};

- (id)initFromWrappedObject:(void*)optr {
    self = [super init];
    
    if (self != nil) {
        self->_wrapped = (icCanvasManager::SplineFitter*)optr;
    }
    
    return self;
};

- (void)beginFittingBrushStroke:(ICMBrushStroke*)stroke withErrorThreshold:(int)errorThreshold {
    icCanvasManager::RefPtr<icCanvasManager::BrushStroke> cppbr = (icCanvasManager::BrushStroke*)[br getWrappedObject];
    self->_wrapped->begin_fitting(cppbr, errorThreshold);
};

- (void)addFitPointWithX:(int)x andY:(int)y andPressure:(int)pressure andTilt:(int)tilt andAngle:(int)angle andDx:(int)dx andDy:(int)dy {
    self->_wrapped->add_fit_point(x, y, pressure, tilt, angle, dx, dy);
};

- (void)finishFitting {
    self->_wrapped->finish_fitting();
};

- (void*)getWrappedObject {
    return (void*)self->_wrapped;
};

@end