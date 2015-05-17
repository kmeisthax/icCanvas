#include <Cocoa/Cocoa.h>

@interface ICMDrawing : NSObject

- (id)initWithTileCache:(ICMTileCache*)c;
- (id)initFromWrappedObject:(void*)optr;

- (ICMBrushStroke*)strokeAtTime:(int) time;
- (int)strokesCount;
- (void)appendStroke:(ICMBrushStroke*)stroke;

- (void*)getWrappedObject;

@end
