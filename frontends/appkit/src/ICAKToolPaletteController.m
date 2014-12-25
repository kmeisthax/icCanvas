#include <icCanvasAppKit.h>

@interface ICAKToolPaletteController (Private)

- (void)didSelectBrushTool;
- (void)didSelectZoomTool;

@end

@implementation ICAKToolPaletteController {
    ICAKDockingController* _dock;
}

- (id)init {
    self = [super init];
    
    if (self != nil) {
        self->_dock = nil;
    }
    
    return self;
};

- (ICAKDockableView*)createToolPaletteView {
    ICAKDockableToolbar* tbl = [[ICAKDockableToolbar alloc] init];
    
    int i = [tbl addButton];
    [tbl setButton:i action:@selector(didSelectBrushTool:) andTarget:self];
    [tbl setButton:i image:[NSImage imageNamed:NSImageNameActionTemplate]];
    [tbl setButton:i type:NSMomentaryPushInButton];
    
    i = [tbl addButton];
    [tbl setButton:i action:@selector(didSelectZoomTool:) andTarget:self];
    [tbl setButton:i image:[NSImage imageNamed:NSImageNameActionTemplate]];
    [tbl setButton:i type:NSMomentaryPushInButton];
    
    return tbl;
};

- (void)setDockingController:(ICAKDockingController*)dock {
    self->_dock = dock;
};

- (void)didSelectBrushTool:(ICAKDockableToolbar*)toolbar {
    NSWindowController* controller = [self->_dock findActionTargetForDockable:toolbar];
    
    if (controller != nil) {
        if ([controller isKindOfClass:ICAKDrawingController.class]) {
            [(ICAKDrawingController*)controller selectBrushTool];
        }
    }
};

- (void)didSelectZoomTool:(ICAKDockableToolbar*)toolbar {
    NSWindowController* controller = [self->_dock findActionTargetForDockable:toolbar];
    
    if (controller != nil) {
        if ([controller isKindOfClass:ICAKDrawingController.class]) {
            [(ICAKDrawingController*)controller selectZoomTool];
        }
    }
};

@end