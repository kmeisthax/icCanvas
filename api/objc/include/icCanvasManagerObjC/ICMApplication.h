#import <Cocoa/Cocoa.h>

@interface ICMApplication : NSObject

- (id)init;
- (id)initFromWrappedObject:(void*)optr;

- (void)backgroundTick;

- (void*)getWrappedObject;

@end
