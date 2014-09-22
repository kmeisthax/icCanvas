#include <icCanvasAppKit.h>

@interface ICAKDock()
- (void)setupSubviews;
- (NSInteger)findValidLocationForDockableView:(ICAKDockableView*)view atEdge:(ICAKDockEdge)edge;
@end

@implementation ICAKDock {
    NSSplitView* _horiz;
    NSSplitView* _vert;
    NSView* _center;
    NSInteger _vert_center_idx;
    
    NSMutableArray *_left_rows, *_right_rows, *_top_rows, *_bottom_rows;
}

- (void)setupSubviews {
    self->_horiz = [[NSSplitView alloc] initWithFrame:self.bounds];
    [self->_horiz setVertical:NO];
    self->_horiz.delegate = self;
    
    self->_vert = [[NSSplitView alloc] init];
    [self->_vert setVertical:YES];
    self->_vert.delegate = self;
    
    self->_vert_center_idx = 0;
    
    [self addSubview:self->_horiz];
    [self->_horiz addSubview:self->_vert];
    
    self->_left_rows = [NSMutableArray arrayWithCapacity:5];
    self->_right_rows = [NSMutableArray arrayWithCapacity:5];
    self->_top_rows = [NSMutableArray arrayWithCapacity:5];
    self->_bottom_rows = [NSMutableArray arrayWithCapacity:5];
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

- (void)setDocumentView:(NSView*)view {
    if (self->_center != nil) {
        [self->_center removeFromSuperview];
    }
    
    if (view != nil) {
        NSArray* oldOrder = self->_vert.subviews;
        NSRange cull;

        cull.location = 0;
        cull.length = self->_vert_center_idx;

        NSArray* newOrder = [oldOrder subarrayWithRange:cull];
        newOrder = [newOrder arrayByAddingObject:view];

        cull.location = self->_vert_center_idx;
        cull.length = oldOrder.count - self->_vert_center_idx;
        newOrder = [newOrder arrayByAddingObjectsFromArray:[oldOrder subarrayWithRange:cull]];

        self->_vert.subviews = newOrder;
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
        case ICAKDockEdgeLeft:
        case ICAKDockEdgeRight:
            target_view = self->_vert;
        case ICAKDockEdgeTop:
        case ICAKDockEdgeBottom:
            row.vertical = YES;
            target_view = self->_horiz;
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
                break;
            } else if (rowsFromEdge >= self->_top_rows.count) {
                rowsFromEdge = self->_top_rows.count - 1;
                relative_dir = NSWindowAbove; //e.g. after
            }
            before_view = [self->_top_rows objectAtIndex:rowsFromEdge];
            break;
        case ICAKDockEdgeLeft:
            if (self->_left_rows.count == 0) {
                before_view = self->_center;
                break;
            } else if (rowsFromEdge >= self->_left_rows.count) {
                rowsFromEdge = self->_left_rows.count - 1;
                relative_dir = NSWindowAbove; //e.g. after
            }
            before_view = [self->_left_rows objectAtIndex:rowsFromEdge];
            break;
        case ICAKDockEdgeBottom:
            relative_dir = NSWindowAbove; //e.g. after
            if (self->_bottom_rows.count == 0) {
                before_view = self->_horiz;
                break;
            } else if (rowsFromEdge >= self->_bottom_rows.count) {
                rowsFromEdge = self->_bottom_rows.count - 1;
            }
            before_view = [self->_bottom_rows objectAtIndex:rowsFromEdge];
            break;
        case ICAKDockEdgeRight:
            relative_dir = NSWindowAbove; //e.g. after
            if (self->_right_rows.count == 0) {
                before_view = self->_center;
                break;
            } else if (rowsFromEdge >= self->_right_rows.count) {
                rowsFromEdge = self->_right_rows.count - 1;
            }
            before_view = [self->_left_rows objectAtIndex:rowsFromEdge];
            break;
    }
    
    [target_view addSubview:row positioned:relative_dir relativeTo:before_view];
};

- (void)attachDockableView:(ICAKDockableView*)view toEdge:(ICAKDockEdge)edge {
    NSInteger row = [self findValidLocationForDockableView:view atEdge:edge];
    if (row == -1) {
        //Special case: no rows
    }
    [self attachDockableView:view toEdge:edge onRow:row atOffset:0];
};

- (void)attachDockableView:(ICAKDockableView*)view toEdge:(ICAKDockEdge)edge onRow:(NSInteger)rowsFromEdge atOffset:(NSInteger)offset {
    //TODO: Actually attach dockable view
};
@end