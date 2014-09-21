#include <icCanvasAppKit.h>

@interface ICAKPanelController (PrivateAPIs) {
    - (BOOL)isView
}

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
    
    [contentView insertDockableView:view atPosition:offset];
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
};

@end

/*
NSRect frameRelativeToWindow = [myView convertRect:myView.bounds toView:nil];
NSRect frameRelativeToScreen = [myView.window convertRectToScreen:frameInWindow];
 */