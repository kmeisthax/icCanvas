#include <icCanvasAppKit.h>

@interface ICAKDock()
- (void)setupSubviews;
- (NSInteger)findValidLocationForDockableView:(ICAKDockableView*)view atEdge:(ICAKDockEdge)edge;
- (void)applyDockingController:(ICAKDockingController*)dc toAllRowsInArray:(NSArray*)arr;
- (BOOL)traverseEdge:(ICAKDockEdge)edge withArray:(NSArray*)arr withBlock:(BOOL(^)(ICAKDockEdge, NSInteger, ICAKDockingRow*))cbk;
@end

@implementation ICAKDock {
    NSSplitView* _horiz;
    NSSplitView* _vert;
    NSView* _center;
    NSInteger _horiz_center_idx;
    
    NSMutableArray *_left_rows, *_right_rows, *_top_rows, *_bottom_rows;
    
    ICAKDockingController* _dock_ctrl;
}

- (void)setupSubviews {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    self->_horiz = [[NSSplitView alloc] init];
    [self->_horiz setVertical:YES];
    self->_horiz.delegate = self;
    self->_horiz.dividerStyle = NSSplitViewDividerStyleThin;
    
    self->_vert = [[NSSplitView alloc] initWithFrame:self.bounds];
    [self->_vert setVertical:NO];
    self->_vert.dividerStyle = NSSplitViewDividerStyleThin;
    
    self->_horiz_center_idx = 0;
    
    [self addSubview:self->_vert];
    [self->_vert addSubview:self->_horiz];
    
    self->_left_rows = [NSMutableArray arrayWithCapacity:5];
    self->_right_rows = [NSMutableArray arrayWithCapacity:5];
    self->_top_rows = [NSMutableArray arrayWithCapacity:5];
    self->_bottom_rows = [NSMutableArray arrayWithCapacity:5];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
};

- (id)init {
    self = [super init];
    
    if (self != nil) {
        [self setupSubviews];
    }
    
    return self;
};

- (NSView*)documentView {
    return self->_center;
};

- (void)setFrame:(NSRect)rekt {
    [self->_vert setFrame:rekt];
    [super setFrame:rekt];
};

- (void)setDocumentView:(NSView*)view {
    if (self->_center != nil) {
        [self->_center removeFromSuperview];
    }
    
    if (view != nil) {
        NSView* relative_to = nil;
        NSWindowOrderingMode positioned = NSWindowAbove;
        
        if (self->_horiz_center_idx < self->_horiz.subviews.count) {
            relative_to = [self->_horiz.subviews objectAtIndex:self->_horiz_center_idx];
            positioned = NSWindowBelow;
        }
        
        [self->_horiz addSubview:view positioned:positioned relativeTo:relative_to];
    }
    
    self->_center = view;
};

- (NSInteger)findValidLocationForDockableView:(ICAKDockableView*)view atEdge:(ICAKDockEdge)edge {
    NSArray* search_array;
    
    switch (edge) {
        case ICAKDockEdgeTop:
            search_array = self->_top_rows;
            break;
        case ICAKDockEdgeBottom:
            search_array = self->_bottom_rows;
            break;
        case ICAKDockEdgeLeft:
            search_array = self->_left_rows;
            break;
        case ICAKDockEdgeRight:
            search_array = self->_right_rows;
            break;
    }
    
    NSInteger answer = 0;
    
    for (ICAKDockingRow* row in search_array) {
        if ([row canAcceptDockableView:view]) {
            return answer;
        }
    }
    
    return -1;
};

- (void)createNewRowOnEdge:(ICAKDockEdge)edge beforeRow:(NSInteger)rowsFromEdge {
    ICAKDockingRow* row = [[ICAKDockingRow alloc] init];
    NSSplitView* target_view = nil;
    
    switch (edge) {
        case ICAKDockEdgeTop:
        case ICAKDockEdgeBottom:
            target_view = self->_vert;
            break;
        case ICAKDockEdgeLeft:
        case ICAKDockEdgeRight:
            row.vertical = YES;
            target_view = self->_horiz;
            break;
        default:
            assert(FALSE);
            return; //just in case? lol
    }
    
    row.vertical = target_view.isVertical;
    
    NSView* before_view = nil;
    NSWindowOrderingMode relative_dir = NSWindowBelow; //e.g. before
    
    switch (edge) {
        case ICAKDockEdgeTop:
            if (self->_top_rows.count == 0) {
                before_view = self->_horiz;
                [self->_top_rows addObject:row];
                break;
            } else if (rowsFromEdge >= self->_top_rows.count) {
                before_view = [self->_top_rows objectAtIndex:self->_top_rows.count - 1];
                relative_dir = NSWindowAbove; //e.g. after
                [self->_top_rows addObject:row];
                break;
            } else {
                before_view = [self->_top_rows objectAtIndex:rowsFromEdge];
            }
            break;
        case ICAKDockEdgeLeft:
            self->_horiz_center_idx++;
            if (self->_left_rows.count == 0) {
                before_view = nil;
                [self->_left_rows addObject:row];
                break;
            } else if (rowsFromEdge >= self->_left_rows.count) {
                before_view = [self->_left_rows objectAtIndex:self->_left_rows.count - 1];
                relative_dir = NSWindowAbove; //e.g. after
                [self->_left_rows addObject:row];
                break;
            } else {
                before_view = [self->_left_rows objectAtIndex:rowsFromEdge];
            }
            break;
        case ICAKDockEdgeBottom:
            if (self->_bottom_rows.count == 0) {
                relative_dir = NSWindowAbove; //e.g. after
                before_view = self->_horiz;
                [self->_bottom_rows addObject:row];
                break;
            } else if (rowsFromEdge >= self->_bottom_rows.count) {
                before_view = [self->_bottom_rows objectAtIndex:self->_bottom_rows.count - 1];
                [self->_bottom_rows addObject:row];
                break;
            } else {
                relative_dir = NSWindowAbove; //e.g. after
                before_view = [self->_bottom_rows objectAtIndex:rowsFromEdge];
            }
            break;
        case ICAKDockEdgeRight:
            if (self->_right_rows.count == 0) {
                relative_dir = NSWindowAbove; //e.g. after
                before_view = nil;
                [self->_right_rows addObject:row];
                break;
            } else if (rowsFromEdge >= self->_right_rows.count) {
                before_view = [self->_right_rows objectAtIndex:self->_right_rows.count - 1];
                [self->_right_rows addObject:row];
                break;
            } else {
                relative_dir = NSWindowAbove; //e.g. after
                before_view = [self->_right_rows objectAtIndex:rowsFromEdge];
            }
            break;
    }
    
    [target_view addSubview:row positioned:relative_dir relativeTo:before_view];
};

- (void)removeRowOnEdge:(ICAKDockEdge)edge atOffset:(NSInteger)rowsFromEdge {
    ICAKDockingRow* rowView = nil;
    
    switch (edge) {
        case ICAKDockEdgeLeft:
            rowView = [self->_left_rows objectAtIndex:rowsFromEdge];
            [self->_left_rows removeObjectAtIndex:rowsFromEdge];
            break;
        case ICAKDockEdgeRight:
            rowView = [self->_right_rows objectAtIndex:rowsFromEdge];
            [self->_right_rows removeObjectAtIndex:rowsFromEdge];
            break;
        case ICAKDockEdgeTop:
            rowView = [self->_top_rows objectAtIndex:rowsFromEdge];
            [self->_top_rows removeObjectAtIndex:rowsFromEdge];
            break;
        case ICAKDockEdgeBottom:
            rowView = [self->_bottom_rows objectAtIndex:rowsFromEdge];
            [self->_bottom_rows removeObjectAtIndex:rowsFromEdge];
            break;
    }
    
    [rowView removeFromSuperview];
};

- (BOOL)getEdge:(ICAKDockEdge*)outEdge andOffset:(NSInteger*)outRowsFromEdge forRow:(ICAKDockingRow*)row {
    if ([self->_left_rows containsObject:row]) {
        if (outEdge) *outEdge = ICAKDockEdgeLeft;
        if (outRowsFromEdge) *outRowsFromEdge = [self->_left_rows indexOfObject:row];
        
        return true;
    }
    
    if ([self->_right_rows containsObject:row]) {
        if (outEdge) *outEdge = ICAKDockEdgeRight;
        if (outRowsFromEdge) *outRowsFromEdge = [self->_right_rows indexOfObject:row];
        
        return true;
    }
    
    if ([self->_top_rows containsObject:row]) {
        if (outEdge) *outEdge = ICAKDockEdgeTop;
        if (outRowsFromEdge) *outRowsFromEdge = [self->_top_rows indexOfObject:row];
        
        return true;
    }
    
    if ([self->_bottom_rows containsObject:row]) {
        if (outEdge) *outEdge = ICAKDockEdgeBottom;
        if (outRowsFromEdge) *outRowsFromEdge = [self->_bottom_rows indexOfObject:row];
        
        return true;
    }
    
    return false;
};

- (void)attachDockableView:(ICAKDockableView*)view toEdge:(ICAKDockEdge)edge {
    NSInteger row = [self findValidLocationForDockableView:view atEdge:edge];
    [self attachDockableView:view toEdge:edge onRow:row atOffset:0];
};

- (void)attachDockableView:(ICAKDockableView*)view toEdge:(ICAKDockEdge)edge onRow:(NSInteger)rowsFromEdge atOffset:(NSInteger)offset {
    if (rowsFromEdge == -1) { //Special case: no accepting rows
        [self createNewRowOnEdge:edge beforeRow:0];
        rowsFromEdge = 0;
    }
    
    ICAKDockingRow* dock = nil;
    
    switch (edge) {
        case ICAKDockEdgeTop:
            dock = [self->_top_rows objectAtIndex:rowsFromEdge];
            break;
        case ICAKDockEdgeBottom:
            dock = [self->_bottom_rows objectAtIndex:rowsFromEdge];
            break;
        case ICAKDockEdgeLeft:
            dock = [self->_left_rows objectAtIndex:rowsFromEdge];
            break;
        case ICAKDockEdgeRight:
            dock = [self->_right_rows objectAtIndex:rowsFromEdge];
            break;
    }
    
    if (offset >= dock.subviews.count) {
        [dock addSubview:view positioned:NSWindowAbove relativeTo:nil];
    } else {
        [dock addSubview:view positioned:NSWindowBelow relativeTo:[dock.subviews objectAtIndex:offset]];
    }
    
    [self->_vert adjustSubviews];
    [self->_horiz adjustSubviews];
    
    view.delegate = self->_dock_ctrl;
    [self->_dock_ctrl didAddDockable:view toDock:self onRow:dock];
};

- (CGFloat)calculateSplitViewMainAxisLength:(NSSplitView*)splitView atDivider:(NSInteger)dividerIndex atRightSide:(BOOL)isRightSide {
    CGFloat answer = 0;
    NSArray *subviews = [splitView subviews];
    
    int direction = isRightSide ? -1 : 1;
    NSUInteger i = isRightSide ? subviews.count - 1 : 0;
    for (; isRightSide ? i > dividerIndex + 1 : i < dividerIndex; i += direction) {
        NSView *pane = [subviews objectAtIndex:i];
        CGFloat paneLength;
        if (splitView.isVertical) {
            paneLength = [pane frame].size.height;
        } else {
            paneLength = [pane frame].size.width;
        }
        answer += paneLength;
    }
    
    return answer;
}

/* Code cribbed from https://github.com/incbee/BESplitViewConstraintEnforcer and modified */
- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(NSInteger)dividerIndex {
    CGFloat widthUpToSubview = [self calculateSplitViewMainAxisLength:splitView atDivider:dividerIndex atRightSide:NO];
    NSView *theView = [splitView.subviews objectAtIndex:dividerIndex];
    
    if ([theView isKindOfClass:ICAKDockingRow.class]) {
        ICAKDockingRow *theDockingRow = (ICAKDockingRow*)theView;
        CGFloat minWidth = 0;
        
        if (theDockingRow.subviews.count == 0) {
            minWidth = 0;
        } else if (theDockingRow.prevailingStyle == ICAKDockableViewStylePanel) {
            minWidth = ICAKDockableViewMinPanelSize;
        } else if (theDockingRow.prevailingStyle == ICAKDockableViewStyleToolbar) {
            minWidth = ICAKDockableViewMinToolbarSize;
        }
        
        CGFloat minAllowedWidth = widthUpToSubview + minWidth;
        return proposedMin < minAllowedWidth ? minAllowedWidth : proposedMin;
    }
    
    return proposedMin;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(NSInteger)dividerIndex {
    CGFloat widthDownToSubview = [self calculateSplitViewMainAxisLength:splitView atDivider:dividerIndex atRightSide:YES];
    
    NSView *theView = [splitView.subviews objectAtIndex:dividerIndex + 1];
    
    if ([theView isKindOfClass:ICAKDockingRow.class]) {
        ICAKDockingRow *theDockingRow = (ICAKDockingRow*)theView;
        CGFloat minWidth = 0;
        
        if (theDockingRow.subviews.count == 0) {
            minWidth = 0;
        } else if (theDockingRow.prevailingStyle == ICAKDockableViewStylePanel) {
            minWidth = ICAKDockableViewMinPanelSize;
        } else if (theDockingRow.prevailingStyle == ICAKDockableViewStyleToolbar) {
            minWidth = ICAKDockableViewMinToolbarSize;
        }
        
        // Now when we add the pane's minimum width on top of the consumed width
        // after it, we get the maximum width allowed for the constraints to be met.
        // But we need a position from the left of the split view, so we translate
        // that by deducting it from the split view's total width.
        CGFloat splitViewWidth = [splitView frame].size.width;
        CGFloat maxAllowedWidth = splitViewWidth - (widthDownToSubview + minWidth);

        // This is the converse of the minimum constraint method: accept the proposed
        // maximum only if it doesn't exced the maximum allowed width
        return proposedMax > maxAllowedWidth ? maxAllowedWidth : proposedMax;
    }
    
    return proposedMax;
}

- (void)splitView:(NSSplitView *)splitView resizeSubviewsWithOldSize:(NSSize)oldSize {
    //Main/cross terms are defined as per CSS3 Flexbox spec
    CGFloat old_main_length, old_cross_length, new_main_length, new_cross_length;  
    if (splitView.isVertical) {
        new_main_length = splitView.bounds.size.width;
        new_cross_length = splitView.bounds.size.height;
        old_main_length = oldSize.width;
        old_cross_length = oldSize.height;
    } else {
        new_main_length = splitView.bounds.size.height;
        new_cross_length = splitView.bounds.size.width;
        old_main_length = oldSize.height;
        old_cross_length = oldSize.width;
    }
    
    CGFloat main_length = 0.0f, available_main_length = 0.0f;
    
    if (splitView.isVertical) {
        available_main_length = splitView.bounds.size.width;
    } else {
        available_main_length = splitView.bounds.size.height;
    }
    
    available_main_length -= splitView.dividerThickness * (splitView.subviews.count - 1);
    
    for (NSView* view in splitView.subviews) {
        NSRect frame = view.frame, bounds = view.bounds;
        
        if (splitView.isVertical) {
            frame.origin.y = 0.0f;
            frame.origin.x = main_length;
            frame.size.height = new_cross_length;
            bounds.size.height = new_cross_length;
        } else {
            frame.origin.y = splitView.bounds.size.height - main_length;
            frame.origin.x = 0.0f;
            frame.size.width = new_cross_length;
            bounds.size.width = new_cross_length;
        }
        
        if (view == self->_horiz || view == self->_center) {
        } else {
            CGFloat minLength = 0;
            if ([view isKindOfClass:ICAKDockingRow.class]) {
                ICAKDockingRow *theDockingRow = (ICAKDockingRow*)view;
                
                if (theDockingRow.prevailingStyle == ICAKDockableViewStylePanel) {
                    minLength = ICAKDockableViewMinPanelSize;
                } else {
                    minLength = ICAKDockableViewMinToolbarSize;
                }
            }
            
            if (splitView.isVertical) {
                frame.size.width = fmax(minLength, frame.size.width);
                bounds.size.width = fmax(minLength, bounds.size.width);
                main_length += frame.size.width;
            } else {
                frame.size.height = fmax(minLength, frame.size.height);
                bounds.size.height = fmax(minLength, bounds.size.height);
                main_length += frame.size.height;
            }
        }
        
        view.frame = frame;
        view.bounds = bounds;
    }
    
    NSView* center = nil;
    
    for (NSView* view in splitView.subviews) {
        NSRect frame = view.frame, bounds = view.bounds;
        
        if (view == self->_horiz || view == self->_center) {
            CGFloat divider = 0.0f;
            center = view;
            
            if (splitView.isVertical) {
                frame.size.width = available_main_length - main_length;
                bounds.size.width = available_main_length - main_length;
            } else {
                frame.size.height = available_main_length - main_length;
                bounds.size.height = available_main_length - main_length;
            }
        } else if (center != nil) {
            if (splitView.isVertical) {
                frame.origin.x += center.frame.size.width;
            } else {
                frame.origin.y -= center.frame.size.height;
            }
        }
        
        view.frame = frame;
        view.bounds = bounds;
    }
    
    CGFloat dividerAccrual = 0.0f;
    
    for (NSView* view in splitView.subviews) {
        NSRect frame = view.frame, bounds = view.bounds;
        
        if (splitView.isVertical) {
            frame.origin.x += dividerAccrual;
        } else {
            frame.origin.y += dividerAccrual;
        }
        
        dividerAccrual += splitView.dividerThickness;
        
        view.frame = frame;
        view.bounds = bounds;
    }
}

- (void)applyDockingController:(ICAKDockingController*)dc toAllRowsInArray:(NSArray*)arr {
    for (ICAKDockingRow* dr in arr) {
        for (NSView* view in dr.subviews) {
            if ([view isKindOfClass:ICAKDockableView.class]) {
                ICAKDockableView* dv = (ICAKDockableView*)view;
                dv.delegate = dc;
                [self->_dock_ctrl didAddDockable:dv toDock:self onRow:dr];
            }
        }
    }
};

- (void)setDockingController:(ICAKDockingController*)dc {
    self->_dock_ctrl = dc;
    
    [self applyDockingController:dc toAllRowsInArray:self->_left_rows];
    [self applyDockingController:dc toAllRowsInArray:self->_right_rows];
    [self applyDockingController:dc toAllRowsInArray:self->_top_rows];
    [self applyDockingController:dc toAllRowsInArray:self->_bottom_rows];
};

- (void)traverseDockablesWithBlock:(BOOL(^)(ICAKDockEdge, NSInteger, ICAKDockingRow*))cbk {
    BOOL should_stop = FALSE;
    
    should_stop = [self traverseEdge:ICAKDockEdgeLeft withArray:self->_left_rows withBlock:cbk];
    if (should_stop) return;
    
    should_stop = [self traverseEdge:ICAKDockEdgeRight withArray:self->_right_rows withBlock:cbk];
    if (should_stop) return;
    
    should_stop = [self traverseEdge:ICAKDockEdgeTop withArray:self->_top_rows withBlock:cbk];
    if (should_stop) return;
    
    should_stop = [self traverseEdge:ICAKDockEdgeBottom withArray:self->_bottom_rows withBlock:cbk];
    if (should_stop) return;
};

- (BOOL)traverseEdge:(ICAKDockEdge)edge withArray:(NSArray*)arr withBlock:(BOOL(^)(ICAKDockEdge, NSInteger, ICAKDockingRow*))cbk {
    BOOL should_stop = FALSE;
    NSInteger rowIndex = 0;
    
    for (NSView* view in arr) {
        ICAKDockingRow* dk = (ICAKDockingRow*)view;
        should_stop = cbk(edge, rowIndex, dk);
        if (should_stop) break;
        
        rowIndex++;
    }
    
    return should_stop;
};
@end