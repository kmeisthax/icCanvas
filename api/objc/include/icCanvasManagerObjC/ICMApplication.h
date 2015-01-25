#import <Cocoa/Cocoa.h>

@interface ICMApplication : NSObject

+ (ICMApplication*)getInstance;
- (id)initFromWrappedObject:(void*)optr;

- (void)backgroundTick;
- (ICMRenderScheduler*)renderScheduler;

- (void)setDelegate:(id <ICMApplicationDelegate>)del;
- (id <ICMApplicationDelegate>)delegate;

- (void*)getWrappedObject;

@end
