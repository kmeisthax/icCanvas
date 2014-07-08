#import <icCanvasManagerObjC.h>
#include <icCanvasManager.hpp>

@implementation ICMBrushStroke {
    icCanvasManager::RefPtr<icCanvasManager::BrushStroke> _wrapped;
}

- (id)init {
    self = [super init];
    
    if (self != nil) {
        self->_wrapped = new icCanvasManager::BrushStroke();
    }
    
    return self;
};

- (id)initFromWrappedObject:(void*)optr {
    self = [super init];
    
    if (self != nil) {
        self->_wrapped = (icCanvasManager::BrushStroke*)optr;
    }
    
    return self;
};

- (void)dealloc {
    delete self->_wrapped;
};

- (void)penBeginWithX:(int32_t)x andY:(int32_t)y {
    self->_wrapped->pen_begin(x, y);
};

- (void)penBeginWithPressure:(int32_t) pressure {
    self->_wrapped->pen_begin_pressure(pressure);
};

- (void)penBeginWithTilt:(int32_t)tilt andAngle:(int32_t) angle  {
    self->_wrapped->pen_begin_tilt(tilt, angle);
};

- (void)penBeginWithDeltaX:(int32_t)delta_x andDeltaY:(int32_t)delta_y {
    self->_wrapped->pen_begin_velocity(delta_x, delta_y);
};

- (void)penToFromControlPointX:(int32_t)fromcp_x andY:(int32_t)fromcp_y toControlPointX:(int32_t)tocp_x andY:(int32_t)tocp_y toX:(int32_t)to_x andY:(int32_t)to_y {
    self->_wrapped->pen_to(fromcp_x, fromcp_y, tocp_x, tocp_y, to_x, to_y);
};

- (void)penToFromControlPointPressure:(int32_t)fromcp_pressure toControlPointPressure:(int32_t)tocp_pressure toPressure:(int32_t)to_pressure {
    self->_wrapped->pen_to_pressure(fromcp_pressure, tocp_pressure, to_pressure);
};

- (void)penToFromControlPointTilt:(int32_t)fromcp_tilt andAngle:(int32_t)fromcp_angle toControlPointTilt:(int32_t)tocp_tilt andAngle:(int32_t)tocp_angle toTilt:(int32_t)to_tilt andAngle:(int32_t)to_angle {
    self->_wrapped->pen_to_tilt(fromcp_tilt, fromcp_angle, tocp_tilt, tocp_angle, to_tilt, to_angle);
};

- (void)penToFromControlPointDeltaX:(int32_t)fromcp_delta_x andDeltaY:(int32_t)fromcp_delta_y toControlPointDeltaX:(int32_t)tocp_delta_x andDeltaY:(int32_t)tocp_delta_y toDeltaX:(int32_t)to_delta_x andDeltaY:(int32_t)to_delta_y {
    self->_wrapped->pen_to_velocity(fromcp_delta_x, fromcp_delta_y, tocp_delta_x, tocp_delta_y, to_delta_x, to_delta_y);
};

- (void)penExtendWithContinuityLevel:(int) lvl {
    self->_wrapped->pen_extend(lvl);
};

- (void)penBack {
    self->_wrapped->pen_back();
};

- (void*)getWrappedObject {
    return (void*)self->_wrapped;
};

@end