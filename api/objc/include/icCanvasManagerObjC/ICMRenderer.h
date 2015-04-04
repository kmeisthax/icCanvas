#import <Cocoa/Cocoa.h>

#include <cairo.h>

@interface ICMRenderer : NSObject

- (id)initFromWrappedObject:(void*)optr;

//TODO: Wrap new Renderer methods.
- (void)drawStroke:(ICMBrushStroke*)br;

- (void*)getWrappedObject;

@end
