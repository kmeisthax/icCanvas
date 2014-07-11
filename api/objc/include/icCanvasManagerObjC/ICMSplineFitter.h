#import <Cocoa/Cocoa.h>

@interface ICMSplineFitter : NSObject

- (id)init;
- (id)initFromWrappedObject:(void*)optr;

- (void)beginFittingBrushStroke:(ICMBrushStroke*)stroke withErrorThreshold:(int)errorThreshold;
- (void)addFitPointWithX:(int)x andY:(int)y andPressure:(int)pressure andTilt:(int)tilt andAngle:(int)angle andDx:(int)dx andDy:(int)dy;
- (void)finishFitting;

- (void*)getWrappedObject;

@end
