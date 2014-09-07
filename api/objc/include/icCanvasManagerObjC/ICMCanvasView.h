#import <Cocoa/Cocoa.h>

#include <cairo.h>

@interface ICMCanvasView : NSObject

- (id)init;
- (id)initFromWrappedObject:(void*)optr;

- (void)attachDrawing:(ICMDrawing*)drawing;

- (void)drawWithContext:(cairo_t*)context intoRects:(cairo_rectangle_list_t*)rectList;
- (void)setSizeWidth:(const double)width andHeight:(const double)height andUiScale:(const double)ui_scale;
- (void)setSizeUiScale:(const double)ui_scale;
- (void)getSizeWidth:(double*)out_width andHeight:(double*)out_height andUiScale:(double*)out_ui_scale;
- (void)getMaximumSizeWidth:(double*)out_width andHeight:(double*)out_height;
- (void)getScaleExtentsMinimum:(double*)out_minscale andMaximum:(double*)out_maxscale;
- (void)setScrollCenterX:(const double)x andY:(const double)y;
- (void)setZoom:(const double)vpixel_size;

- (void)mouseDownWithX:(const double)x andY:(const double)y andDeltaX:(const double)deltaX andDeltaY:(const double)deltaY;
- (void)mouseDragWithX:(const double)x andY:(const double)y andDeltaX:(const double)deltaX andDeltaY:(const double)deltaY;
- (void)mouseUpWithX:(const double)x andY:(const double)y andDeltaX:(const double)deltaX andDeltaY:(const double)deltaY;

- (void*)getWrappedObject;

@end
