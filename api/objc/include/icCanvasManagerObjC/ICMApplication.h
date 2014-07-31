#import <Cocoa/Cocoa.h>

@interface ICMApplication : NSObject

+ (id)getInstance;
- (id)initFromWrappedObject:(void*)optr;

- (void)backgroundTick;

- (void*)getWrappedObject;

@end
