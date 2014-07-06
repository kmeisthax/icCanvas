#import <Cocoa/Cocoa.h>
#import <icCanvasManagerObjC.h>

@interface ICAKCanvasView : NSView

- (id)initWithDrawing:(ICMDrawing*) drawing;
- (id)initWithFrame:(NSRect)frameRect andDrawing:(ICMDrawing*) drawing;
- (void)drawRect:(NSRect)dirtyRect;

@end
