#include <Cocoa/Cocoa.h>

@interface ICAKCanvasView : NSView

- (id)initWithFrame:(NSRect)frameRect;
- (void)drawRect:(NSRect)dirtyRect;

@end
