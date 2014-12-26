#include <icCanvasAppKit.h>

typedef struct {
    __unsafe_unretained ICAKDockableView* dockable;
    __unsafe_unretained ICAKDock* dock;
    __unsafe_unretained NSPanel* panel;
    __unsafe_unretained ICAKDockingRow* row;
    __unsafe_unretained NSWindowController* controller;
    
    BOOL has_selected_target;
    
    //Target type 1: Selecting a dock
    __unsafe_unretained ICAKDock* selected_dock;
    ICAKDockEdge selected_edge;
    NSInteger selected_offset;
    
    //Target type 2: Selecting an NSPanel
    __unsafe_unretained NSPanel* selected_panel;
    
    //Common to all panels
    NSInteger selected_pos;
} ICAKDockingControllerDockData;

typedef struct {
    __unsafe_unretained NSWindowController* controller;
} ICAKDockingControllerControllerData;

@implementation ICAKDockingController {
    NSMutableArray* _panels;
    NSMutableArray* _docks;
    NSMutableArray* _controllers;
    
    NSMutableDictionary* _docknfo;
    NSMutableDictionary* _ctrlnfo;
}

- (id)init {
    self = [super init];
    
    if (self != nil) {
        self->_panels = [NSMutableArray arrayWithCapacity:10];
        self->_docks = [NSMutableArray arrayWithCapacity:10];
        self->_controllers = [NSMutableArray arrayWithCapacity:10];
        
        self->_docknfo = [[NSMutableDictionary alloc] init];
        self->_ctrlnfo = [[NSMutableDictionary alloc] init];
    }
    
    return self;
};

- (void)dockableViewWillDetach:(ICAKDockableView*)view {
    ICAKDockingControllerDockData dat;
    
    NSValue* maybeDat = [self->_docknfo objectForKey:[NSValue valueWithNonretainedObject:view]];
    if (maybeDat == nil) {
        return; //WTF
    }
    
    [maybeDat getValue:&dat];
    
    if (dat.dock == nil && dat.row.subviews.count <= 1) {
        return;
    }
    
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
    row.vertical = dat.row.vertical;
    
    package.contentView = row;
    [row addSubview:view positioned:NSWindowAbove relativeTo:nil];
    
    [package makeKeyAndOrderFront:nil];
    
    [self addPanel:package];
    [self didAddDockable:view toPanel:package onRow:row];
    
    if (dat.row.subviews.count == 0) {
        if (dat.dock != nil) {
            ICAKDockEdge edge;
            NSInteger rowsFromEdge;
            if (![dat.dock getEdge:&edge andOffset:&rowsFromEdge forRow:dat.row]) return;//WTF
            [dat.dock removeRowOnEdge:edge atOffset:rowsFromEdge];
        }
    }
};

- (void)dockableView:(ICAKDockableView*)view wasDraggedByEvent:(NSEvent*)evt {
    NSPoint screen_loc = NSEvent.mouseLocation;
    NSRect viewFrame = [ICAKDockingRow viewFramePlusMargins:view];
    
    __block ICAKDockingControllerDockData dat; //why do I gotta DO this
    
    NSValue* maybeDat = [self->_docknfo objectForKey:[NSValue valueWithNonretainedObject:view]];
    if (maybeDat == nil) {
        return; //WTF
    }
    [maybeDat getValue:&dat];
    
    dat.has_selected_target = NO;
    dat.selected_dock = nil;
    dat.selected_panel = nil;
    
    for (ICAKDock* dock in self->_docks) {
        //Consider the edges of the frame
        NSRect dockWinFrame = [dock convertRect:dock.frame toView: nil];
        NSRect dockAbsFrame = [dock.window convertRectToScreen:dockWinFrame];
        NSRect insetDockFrame = NSInsetRect(dockAbsFrame, fmin(25.0f, dockAbsFrame.size.width / 2.0f), fmin(25.0f, dockAbsFrame.size.height / 2.0f));
        
        if (screen_loc.x >= dockAbsFrame.origin.x && screen_loc.x <= insetDockFrame.origin.x) {
            dat.has_selected_target = YES;
            dat.selected_dock = dock;
            dat.selected_edge = ICAKDockEdgeLeft;
            dat.selected_offset = -1;
            dat.selected_pos = 0;
        }
        
        if (screen_loc.x >= dockAbsFrame.origin.y && screen_loc.y <= insetDockFrame.origin.y) {
            dat.has_selected_target = YES;
            dat.selected_dock = dock;
            dat.selected_edge = ICAKDockEdgeBottom;
            dat.selected_offset = -1;
            dat.selected_pos = 0;
        }
        
        if (screen_loc.x >= insetDockFrame.origin.x + insetDockFrame.size.width && screen_loc.x <= dockAbsFrame.origin.x + dockAbsFrame.size.width) {
            dat.has_selected_target = YES;
            dat.selected_dock = dock;
            dat.selected_edge = ICAKDockEdgeRight;
            dat.selected_offset = -1;
            dat.selected_pos = 0;
        }
        
        if (screen_loc.y >= insetDockFrame.origin.y + insetDockFrame.size.height && screen_loc.y <= dockAbsFrame.origin.y + dockAbsFrame.size.height) {
            dat.has_selected_target = YES;
            dat.selected_dock = dock;
            dat.selected_edge = ICAKDockEdgeTop;
            dat.selected_offset = -1;
            dat.selected_pos = 0;
        }
        
        if (dat.has_selected_target) break;
        
        [dock traverseDockablesWithBlock:^(ICAKDockEdge edge, NSInteger row_cnt, ICAKDockingRow* row) {
            NSRect winRelFrame = [row convertRect:row.frame toView:nil];
            NSRect absFrame = [row.window convertRectToScreen:winRelFrame];
            
            if (NSPointInRect(screen_loc, absFrame) && [row canAcceptDockableView:view]) {
                NSInteger current_pos = 0;
                for (; current_pos < row.subviews.count; current_pos++) {
                    if (![row isScreenPoint:screen_loc beforePosition:current_pos]) {
                        break;
                    }
                }
                
                dat.has_selected_target = YES;
                dat.selected_dock = dock;
                dat.selected_edge = edge;
                dat.selected_offset = row_cnt;
                dat.selected_pos = current_pos;
                
                [row reserveSpace:viewFrame atPosition:dat.selected_pos];
                
                return YES;
            }
            
            return NO;
        }];
        
        if (dat.has_selected_target) break;
    }
    
    if (dat.has_selected_target) {
        view.window.alphaValue = 0.6;
    } else {
        view.window.alphaValue = 1.0;
    }
    
    [self->_docknfo setObject:[NSValue valueWithBytes:&dat objCType:@encode(ICAKDockingControllerDockData)] forKey:[NSValue valueWithNonretainedObject:view]];
};

- (void)dockableViewWasReleased:(ICAKDockableView*)view {
    ICAKDockingControllerDockData dat;
    
    NSValue* maybeDat = [self->_docknfo objectForKey:[NSValue valueWithNonretainedObject:view]];
    if (maybeDat == nil) {
        return;
    }
    
    [maybeDat getValue:&dat];
    
    if (dat.has_selected_target) {
        if (dat.selected_dock) {
            [dat.selected_dock attachDockableView:view toEdge:dat.selected_edge onRow:dat.selected_offset atOffset:dat.selected_pos];
        }
        
        //TODO: Release to Panel
        
        if (dat.panel != nil) {
            [dat.panel close];
        }
    }
};

- (void)addPanel:(NSPanel*)panel {
    [self->_panels addObject:panel];
};

- (void)addDock:(ICAKDock*)dock fromWindowController:(NSWindowController*)controller {
    [self->_docks addObject:dock];
    [self->_controllers addObject:controller];
    dock.dockingController = self;
    
    ICAKDockingControllerControllerData dat;
    NSValue* maybeDat = [self->_ctrlnfo objectForKey:[NSValue valueWithNonretainedObject:dock]];
    if (maybeDat != nil) {
        [maybeDat getValue:&dat];
    }
    
    dat.controller = controller;
    
    [self->_ctrlnfo setObject:[NSValue valueWithBytes:&dat objCType:@encode(ICAKDockingControllerControllerData)] forKey:[NSValue valueWithNonretainedObject:dock]];
};

- (void)addDrawingController:(ICAKDrawingController*)dc {
    [self addDock:dc.dock fromWindowController:dc];
};

- (void)didAddDockable:(ICAKDockableView*)view toDock:(ICAKDock*)dock onRow:(ICAKDockingRow*)row {
    ICAKDockingControllerDockData dat;
    
    NSValue* maybeDat = [self->_docknfo objectForKey:[NSValue valueWithNonretainedObject:view]];
    if (maybeDat != nil) {
        [maybeDat getValue:&dat];
    }
    
    ICAKDockingControllerControllerData ctrldat;
    NSValue* maybeCtrlDat = [self->_ctrlnfo objectForKey:[NSValue valueWithNonretainedObject:dock]];
    if (maybeCtrlDat != nil) {
        [maybeCtrlDat getValue:&ctrldat];
    }
    
    dat.dockable = view;
    dat.dock = dock;
    dat.panel = nil;
    dat.row = row;
    dat.controller = maybeCtrlDat != nil ? ctrldat.controller : nil;
    
    [self->_docknfo setObject:[NSValue valueWithBytes:&dat objCType:@encode(ICAKDockingControllerDockData)] forKey:[NSValue valueWithNonretainedObject:view]];
};

- (void)didAddDockable:(ICAKDockableView*)view toPanel:(NSPanel*)panel onRow:(ICAKDockingRow*)row {
    ICAKDockingControllerDockData dat;
    
    NSValue* maybeDat = [self->_docknfo objectForKey:[NSValue valueWithNonretainedObject:view]];
    if (maybeDat != nil) {
        [maybeDat getValue:&dat];
    }
    
    dat.dockable = view;
    dat.dock = nil;
    dat.panel = panel;
    dat.row = row;
    dat.controller = nil;
    
    [self->_docknfo setObject:[NSValue valueWithBytes:&dat objCType:@encode(ICAKDockingControllerDockData)] forKey:[NSValue valueWithNonretainedObject:view]];
};

- (NSWindowController*)findActionTargetForDockable:(ICAKDockableView*)dv {
    ICAKDockingControllerDockData dat;
    
    NSValue* maybeDat = [self->_docknfo objectForKey:[NSValue valueWithNonretainedObject:dv]];
    if (maybeDat != nil) {
        [maybeDat getValue:&dat];
        
        if (dat.controller != nil) {
            return dat.controller;
        }
    }
    
    for (NSWindowController* controller in self->_controllers) {
        if (controller.window.isMainWindow) {
            return controller;
        }
    }
    
    return nil;
};
@end