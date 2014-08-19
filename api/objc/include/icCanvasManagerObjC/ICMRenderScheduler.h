#import <Cocoa/Cocoa.h>

@interface ICMRenderScheduler : NSObject

- (id)init;
- (id)initFromWrappedObject:(void*)optr;

- (void)requestTileOnDrawing:(ICMDrawing*)d atX:(int)x andY:(int)y atSize:(int)size atTime:(int)time;
- (void)backgroundTick;
- (int)collectRequestsForDrawing:(ICMDrawing*)d;

- (void*)getWrappedObject;

@end
