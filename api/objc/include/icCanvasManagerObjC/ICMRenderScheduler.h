#import <Cocoa/Cocoa.h>
#include <cairo.h>

@class ICMApplication;

@interface ICMRenderScheduler : NSObject

- (id)initWithApplication:(ICMApplication*)appWrap;
- (id)initFromWrappedObject:(void*)optr;

- (void)requestTileOnDrawing:(ICMDrawing*)d atX:(int)x andY:(int)y atSize:(int)size atTime:(int)time;
- (void)requestTilesOnDrawing:(ICMDrawing*)d inRect:(cairo_rectangle_t)rect atSize:(int)size atTime:(int)time;
- (void)backgroundTick;
- (int)collectRequestForDrawing:(ICMDrawing*)d canvasTileRect:(cairo_rectangle_t*)out_tile_rect;
- (void)revokeRequestForDrawing:(ICMDrawing*)d xMin:(int)x_min yMin:(int)y_min xMax:(int)x_max yMax:(int)y_max isInverse:(BOOL)is_inverse;
- (void)revokeRequestForDrawing:(ICMDrawing*)d zoomMin:(int)z_min zoomMax:(int)z_max isInverse:(BOOL)is_inverse;

- (void*)getWrappedObject;

@end
