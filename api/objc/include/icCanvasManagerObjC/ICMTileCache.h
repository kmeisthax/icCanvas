#include <Cocoa/Cocoa.h>

@interface ICMTileCache : NSObject

- (id)init;
- (id)initFromWrappedObject:(void*)optr;

- (ICMDisplaySuite*)displaySuite;
- (void)setDisplaySuite:(ICMDisplaySuite*)ds;

- (void*)getWrappedObject;

@end
