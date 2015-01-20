#import <Cocoa/Cocoa.h>

#include <cairo.h>

@interface ICMCanvasView : NSObject

- (id)init;
- (id)initFromWrappedObject:(void*)optr;

- (void)attachDrawing:(ICMDrawing*)drawing;

- (void)drawWithContext:(cairo_t*)context intoRects:(cairo_rectangle_list_t*)rectList;
- (void)setSizeWidth:(const double)width andHeight:(const double)height andUiScale:(const double)ui_scale;
- (void)setSizeUiScale:(const double)ui_scale;
- (void)setUiScale:(const double)ui_scale;
- (void)getSizeWidth:(double*)out_width andHeight:(double*)out_height andUiScale:(double*)out_ui_scale;
- (void)getMaximumSizeWidth:(double*)out_width andHeight:(double*)out_height;
- (void)getScaleExtentsMinimum:(double*)out_minscale andMaximum:(double*)out_maxscale;
- (void)setScrollCenterX:(const double)x andY:(const double)y;
- (const double)zoom;
- (void)setZoom:(const double)vpixel_size;
- (void)windowToCoordSpaceX:(const int32_t)x andY:(const int32_t)y outTx:(int32_t*)out_x outTy:(int32_t*)out_y;
- (void)coordToWindowSpaceX:(const int32_t)x andY:(const int32_t)y outTx:(int32_t*)out_x outTy:(int32_t*)out_y;
- (int)highestZoom;

- (void*)getWrappedObject;

@end
