#import <Cocoa/Cocoa.h>

#include <cairo.h>

@interface ICMCanvasView : NSObject

- (id)init;
- (id)initFromWrappedObject:(void*)optr;

- (void)attachDrawing:(ICMDrawing*)drawing;

- (void)drawWithContext:(cairo_t*)context inDirtyRect:(cairo_rectangle_t) dirtyArea;
- (void)setSizeWidth:(double)width andHeight:(double)height andUiScale:(double)ui_scale;
- (void)setSizeUiScale:(double)ui_scale;
- (void)getSizeWidth:(double*)out_width andHeight:(double*)out_height andUiScale:(double*)out_ui_scale;
- (void)setScrollCenterX:(int)x andY:(int)y;
- (void)setZoom:(int)vpixel_size;

- (void)mouseDownWithX:(int)x andY:(int)y andDeltaX:(int)deltaX andDeltaY:(int)deltaY;
- (void)mouseDragWithX:(int)x andY:(int)y andDeltaX:(int)deltaX andDeltaY:(int)deltaY;
- (void)mouseUpWithX:(int)x andY:(int)y andDeltaX:(int)deltaX andDeltaY:(int)deltaY;

- (void*)getWrappedObject;

@end
