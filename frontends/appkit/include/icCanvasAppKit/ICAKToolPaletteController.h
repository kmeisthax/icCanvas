#import <Cocoa/Cocoa.h>

@interface ICAKToolPaletteController : NSObject

- (id)init;

- (void)setDockingController:(ICAKDockingController*)dock;

- (ICAKDockableView*)createToolPaletteView;

@end
