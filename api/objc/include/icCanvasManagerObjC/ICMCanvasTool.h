#import <Cocoa/Cocoa.h>

@interface ICMCanvasTool : NSObject

- (id)initFromWrappedObject:(void*)optr;

- (void)prepareForReuse;

- (void)setSizeWidth:(const double)width andHeight:(const double)height andUiScale:(const double)ui_scale andZoom:(const double)zoom;
- (void)setScrollCenterX:(const double)x andY:(const double)y;

- (void)mouseDownWithX:(const double)x andY:(const double)y andDeltaX:(const double)deltaX andDeltaY:(const double)deltaY;
- (void)mouseDragWithX:(const double)x andY:(const double)y andDeltaX:(const double)deltaX andDeltaY:(const double)deltaY;
- (void)mouseUpWithX:(const double)x andY:(const double)y andDeltaX:(const double)deltaX andDeltaY:(const double)deltaY;

- (void*)getWrappedObject;

@end
