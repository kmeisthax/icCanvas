#import <Cocoa/Cocoa.h>

@interface ICMCairoRenderer : ICMRenderer

- (id)init;
- (id)initFromWrappedObject:(void*)optr;

- (void*)getWrappedObject;

@end
