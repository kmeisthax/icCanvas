#import <Cocoa/Cocoa.h>

@interface ICMApplication : NSObject

+ (ICMApplication*)getInstance;
- (id)initFromWrappedObject:(void*)optr;

- (void)backgroundTick;
- (ICMRenderScheduler*)renderScheduler;

- (void*)getWrappedObject;

@end
