#import <Cocoa/Cocoa.h>

@interface ICMCairoDisplaySuite : ICMDisplaySuite

- (id)init;
- (id)initFromWrappedObject:(void*)optr;

- (void*)getWrappedObject;

@end
