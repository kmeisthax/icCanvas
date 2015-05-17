#include <Cocoa/Cocoa.h>

@class ICMDisplaySuite;

@interface ICMTileCache : NSObject

- (id)init;
- (id)initFromWrappedObject:(void*)optr;

- (ICMDisplaySuite*)displaySuite;
- (void)setDisplaySuite:(ICMDisplaySuite*)ds;

- (void*)getWrappedObject;

@end
