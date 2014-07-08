#include <Cocoa/Cocoa.h>

@interface ICMDrawing : NSObject

- (id)init;
- (id)initFromWrappedObject:(void*)optr;

- (ICMBrushStroke*)strokeAtTime:(int) time;
- (int)strokesCount;

- (void*)getWrappedObject;

@end
