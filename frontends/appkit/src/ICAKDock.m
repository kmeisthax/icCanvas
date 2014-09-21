#include <icCanvasAppKit.h>

@interface ICAKDock()
- (void)setupSubviews;
@end

@implementation ICAKDock {
    NSSplitView* _horiz;
    NSSplitView* _vert;
    NSView* _center;
    NSInteger _vert_center_idx;
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

- (void)attachDockableView:(ICAKDockableView*)view toEdge:(ICAKDockEdge)edge {
    //TODO: Actually attach dockable view
};

@end