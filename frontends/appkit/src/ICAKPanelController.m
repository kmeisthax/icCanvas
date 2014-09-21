#include <icCanvasAppKit.h>

@implementation ICAKPanelController : NSObject {
    NSMutableArray* _panels;
    NSMutableArray* _docks;
}

- (id)init {
    self = [super init];
    
    if (self != nil) {
        self->_panels = [NSMutableArray arrayWithCapacity:10];
        self->_docks = [NSMutableArray arrayWithCapacity:10];
    }
    
    return self;
};

- (void)dockableViewWillDetach:(ICAKDockableView*)view {
    [view removeFromSuperview];
    
    NSPanel* package = [[NSPanel alloc] init];
    package.contentView = [[ICAKDockingRow alloc] init];
    [package.contentView addSubview:view];
    
    [self addPanel:package];
};

- (void)addPanel:(NSPanel*)panel {
    [self->_panels addObject:panel];
};

- (void)addDock:(ICAKDock*)dock {
    [self->_docks addObject:dock];
};

@end

/*
NSRect frameRelativeToWindow = [myView convertRect:myView.bounds toView:nil];
NSRect frameRelativeToScreen = [myView.window convertRectToScreen:frameInWindow];
 */