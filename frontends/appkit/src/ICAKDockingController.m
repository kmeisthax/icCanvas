#include <icCanvasAppKit.h>

@implementation ICAKDockingController {
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
    NSRect frameRelativeToWindow = [view convertRect:view.bounds toView:nil];
    
    frameRelativeToWindow.origin.x -= ICAKDockableViewPanelMargins;
    frameRelativeToWindow.origin.y -= ICAKDockableViewPanelMargins;
    frameRelativeToWindow.size.width += ICAKDockableViewPanelMargins * 2;
    frameRelativeToWindow.size.height += ICAKDockableViewPanelMargins * 2;
    
    NSRect frameRelativeToScreen = [view.window convertRectToScreen:frameRelativeToWindow];
    NSPanel* package = [[NSPanel alloc] initWithContentRect:frameRelativeToScreen styleMask:(NSTitledWindowMask|NSClosableWindowMask|NSResizableWindowMask|NSUtilityWindowMask) backing:NSBackingStoreBuffered defer:TRUE];
    [package standardWindowButton:NSWindowZoomButton].enabled = NO;
    
    frameRelativeToWindow.origin.x = 0;
    frameRelativeToWindow.origin.y = 0;
    
    ICAKDockingRow* row = [[ICAKDockingRow alloc] initWithFrame:frameRelativeToWindow];
    row.vertical = YES;
    
    package.contentView = row;
    [row addSubview:view positioned:NSWindowAbove relativeTo:nil];
    
    [package makeKeyAndOrderFront:nil];
    
    [self addPanel:package];
};

- (BOOL)dockableView:(ICAKDockableView*)view shouldAttachToPanel:(NSPanel*)panel {
    id contentView = panel.contentView;
    if (![contentView respondsToSelector:@selector(canAcceptDockableView:)]) {
        return NO; //I don't know what the heck this panel is
    }
    
    return [contentView canAcceptDockableView:view];
};
- (BOOL)dockableView:(ICAKDockableView*)view shouldAttachToDock:(ICAKDock*)dock {
    return YES; //Docks currently can always accept dockable views
};

- (void)dockableView:(ICAKDockableView*)view willAttachToPanel:(NSPanel*)panel atOffset:(NSInteger)offset {
    id contentView = panel.contentView;
    if (![contentView respondsToSelector:@selector(insertDockableView:atPosition:)]) {
        return; //Do nothing, what the eff is this thing
    }
    
    [contentView addSubview:view positioned:NSWindowBelow relativeTo:[[contentView subviews] objectAtIndex:offset]];
};
- (void)dockableView:(ICAKDockableView*)view willAttachToDock:(ICAKDock*)dock onEdge:(ICAKDockEdge)edge onRow:(NSInteger)rowsFromEdge atOffset:(NSInteger)offset {
    [dock attachDockableView:view toEdge:edge onRow:rowsFromEdge atOffset:offset];
};

- (void)dockableViewDidNotAttach:(ICAKDockableView*)view {
    /* Do nothing for now.
     * In the future, when we use DockingRow's reservation feature, we should
     * cancel whatever reservation was in place.
     */
};

- (void)addPanel:(NSPanel*)panel {
    [self->_panels addObject:panel];
};

- (void)addDock:(ICAKDock*)dock {
    [self->_docks addObject:dock];
    dock.dockingController = self;
};

- (void)addDrawingController:(ICAKDrawingController*)dc {
    [self addDock:dc.dock];
};

@end