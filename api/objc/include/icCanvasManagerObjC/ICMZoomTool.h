#import <Cocoa/Cocoa.h>

@interface ICMZoomTool : ICMCanvasTool

- (id)init;
- (id)initFromWrappedObject:(void*)optr;

- (void)setDelegate:(id <ICMZoomToolDelegate>)del;
- (id <ICMZoomToolDelegate>)delegate;

- (void*)getWrappedObject;

@end
