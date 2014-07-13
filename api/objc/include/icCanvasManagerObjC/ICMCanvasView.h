#import <Cocoa/Cocoa.h>

#include <cairo.h>

@interface ICMCanvasView : NSObject

- (id)init;
- (id)initFromWrappedObject:(void*)optr;

- (void)attachDrawing:(ICMDrawing*)drawing;

- (void)drawWithContext:(cairo_t*)context inDirtyRect:(cairo_rectangle_t) dirtyArea;
- (void)setSizeWidth:(double)width andHeight:(double)height;

- (void*)getWrappedObject;

@end
