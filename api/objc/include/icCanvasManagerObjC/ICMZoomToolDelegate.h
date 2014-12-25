#import <Cocoa/Cocoa.h>

@protocol ICMZoomToolDelegate

- (void)changedScrollX:(const double)x andY:(const double)y andZoom:(const double)zoom;

@end
