#import <Cocoa/Cocoa.h>

@interface ICMDisplaySuite : NSObject

- (id)initFromWrappedObject:(void*)optr;

- (void*)getWrappedObject;

@end
