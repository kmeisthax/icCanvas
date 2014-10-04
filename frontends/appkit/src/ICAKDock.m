#include <icCanvasAppKit.h>

@interface ICAKDock()
- (void)setupSubviews;
- (NSInteger)findValidLocationForDockableView:(ICAKDockableView*)view atEdge:(ICAKDockEdge)edge;
@end

@implementation ICAKDock {
    NSSplitView* _horiz;
    NSSplitView* _vert;
    NSView* _center;
    NSInteger _horiz_center_idx;
    
    NSMutableArray *_left_rows, *_right_rows, *_top_rows, *_bottom_rows;
}

- (void)setupSubviews {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    self->_horiz = [[NSSplitView alloc] init];
    [self->_horiz setVertical:YES];
    self->_horiz.delegate = self;
    
    self->_vert = [[NSSplitView alloc] initWithFrame:self.bounds];
    [self->_vert setVertical:NO];
    self->_vert.delegate = self;
    
    self->_horiz_center_idx = 0;
    
    [self addSubview:self->_vert];
    [self->_vert addSubview:self->_horiz];
    
    self->_left_rows = [NSMutableArray arrayWithCapacity:5];
    self->_right_rows = [NSMutableArray arrayWithCapacity:5];
    self->_top_rows = [NSMutableArray arrayWithCapacity:5];
    self->_bottom_rows = [NSMutableArray arrayWithCapacity:5];
    
    [self createNewRowOnEdge:ICAKDockEdgeLeft beforeRow:0];
    [self createNewRowOnEdge:ICAKDockEdgeRight beforeRow:0];
    [self createNewRowOnEdge:ICAKDockEdgeTop beforeRow:0];
    [self createNewRowOnEdge:ICAKDockEdgeBottom beforeRow:0];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
};

- (id)init {
    self = [super init];
    
    if (self != nil) {
        [self setupSubviews];
    }
    
    return self;
};

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
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
    NSView* target_view = nil;
    
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

- (void)attachDockableView:(ICAKDockableView*)view toEdge:(ICAKDockEdge)edge {
    NSInteger row = [self findValidLocationForDockableView:view atEdge:edge];
    if (row == -1) { //Special case: no accepting rows
        [self createNewRowOnEdge:edge beforeRow:0];
        row = 0;
    }
    [self attachDockableView:view toEdge:edge onRow:row atOffset:0];
};

- (void)attachDockableView:(ICAKDockableView*)view toEdge:(ICAKDockEdge)edge onRow:(NSInteger)rowsFromEdge atOffset:(NSInteger)offset {
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
    
    if (dock.subviews.count == 0) {
        [dock addSubview:view positioned:NSWindowAbove relativeTo:nil];
    } else if (offset >= dock.subviews.count) {
        [dock addSubview:view positioned:NSWindowAbove relativeTo:[dock.subviews objectAtIndex:dock.subviews.count - 1]];
    } else {
        [dock addSubview:view positioned:NSWindowBelow relativeTo:[dock.subviews objectAtIndex:offset]];
    }
};
@end