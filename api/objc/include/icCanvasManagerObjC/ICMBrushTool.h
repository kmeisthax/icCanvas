#import <Cocoa/Cocoa.h>

@interface ICMBrushTool : ICMCanvasTool

- (id)init;
- (id)initFromWrappedObject:(void*)optr;

- (void)setDelegate:(id <ICMBrushToolDelegate>)del;
- (id <ICMBrushToolDelegate>)delegate;

- (void*)getWrappedObject;

@end
