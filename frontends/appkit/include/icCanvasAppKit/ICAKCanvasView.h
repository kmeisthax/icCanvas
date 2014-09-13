#import <Cocoa/Cocoa.h>
#import <icCanvasManagerObjC.h>

@interface ICAKCanvasView : NSView

- (id)initWithDrawing:(ICMDrawing*) drawing;
- (id)initWithFrame:(NSRect)frameRect andDrawing:(ICMDrawing*) drawing;
- (BOOL)isFlipped;
- (void)drawRect:(NSRect)dirtyRect;
- (void)mouseDown:(NSEvent*)theEvent;
- (void)mouseDragged:(NSEvent*)theEvent;
- (void)mouseUp:(NSEvent*)theEvent;

- (void)setDrawing:(ICMDrawing*)drawing;
- (ICMDrawing*)drawing;

- (void)sizeToFitCanvas;

- (double)minimumMagnification;
- (double)maximumMagnification;

@end
