#import <Cocoa/Cocoa.h>
#import <icCanvasManagerObjC.h>

@interface ICAKDrawingController : NSWindowController <ICMBrushToolDelegate, ICMZoomToolDelegate>

- (id)init;
- (void)setDocument:(NSDocument *)document;
- (ICAKDock*)dock;

- (void)rendererDidRenderTilesOnCanvasRect:(NSRect)rect;

- (void)selectBrushTool;
- (void)selectZoomTool;

//ICMxxxToolDelegate impls
- (void)brushToolCapturedStroke:(ICMBrushStroke*)stroke;
- (void)changedScrollX:(const double)x andY:(const double)y andZoom:(const double)zoom;

@end
