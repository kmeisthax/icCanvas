#import <icCanvasAppKit.h>
#import <QuartzCore/QuartzCore.h>

static const NSInteger _MARGINS = 15;

@interface ICAKDockingRow ()
- (void)setup;

- (void)addMarginConstraintsForView:(NSView*)view;
- (NSLayoutConstraint*)createConstraintStapleView:(NSView*)view1 toView:(NSView*)view2;
- (NSLayoutConstraint*)createConstraintTopMarginForView:(NSView*)view1;
@end

@implementation ICAKDockingRow {
    BOOL _is_vertical;
    
    BOOL _is_reservation_active;
    NSInteger _reserved_before;
    NSSize _reserved_size;
    
    ICAKDockableViewStyle _prevailing_style;
    
    NSMutableArray* _spacing_constraints;
    
    //Only set when an empty docking row is asked to reserve space.
    NSLayoutConstraint* _empty_constraint;
    NSLayoutConstraint* _bottom_margin_constraint;
}

//I don't feel like learning autoresizing
+ (BOOL)requiresConstraintBasedLayout {
    return YES;
};

- (void)setup {
    self->_is_reservation_active = NO;
    self->_is_vertical = NO;
    self->_spacing_constraints = [NSMutableArray arrayWithCapacity:5];
    self->_empty_constraint = nil;
    self->_bottom_margin_constraint = nil;
    
    NSColor *color = [NSColor colorWithCatalogName:@"System" colorName:@"_sourceListBackgroundColor"];
    if (color == nil) {
        NSTableView *tableView = [[[NSTableView alloc] initWithFrame:NSZeroRect] autorelease];
        [tableView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList];
        color = [tableView backgroundColor];
    }
    
    self.wantsLayer = YES;
    self.layer.backgroundColor = color;
};

- (id)init {
    self = [super init];
    
    if (self != nil) {
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if (self != nil) {
        [self setup];
    }
    
    return self;
};

- (BOOL)vertical {
    return self->_is_vertical;
};
- (void)setVertical:(BOOL)isVertical {
    self->_is_vertical = isVertical;
};

- (BOOL)canAcceptDockableView:(ICAKDockableView*)dview {
    if (self.subviews.count == 0) {
        return YES;
    }
    
    if (self->_prevailing_style == dview.style) {
        return YES;
    }
    
    return NO;
};

- (NSInteger)insertionPositionForPoint:(NSPoint)pt {
    NSInteger currentPos = 0;
    
    for (NSView* view in self.subviews) {
        if (self->_is_vertical) {
            if (view.frame.origin.x >= pt.x) {
                return currentPos;
            }
        } else {
            if (view.frame.origin.y < pt.y) { //Quartz is stupid
                return currentPos;
            }
        }
        
        currentPos++;
    }
    
    return currentPos;
};

- (void)reserveSpace:(NSRect)rect atPosition:(NSInteger)pos {
    //double reservations will cause issues
    if (self->_is_reservation_active) {
        [self removePreviousSpaceReservation];
    }
    
    self->_is_reservation_active = YES;
    self->_reserved_before = pos;
    self->_reserved_size = rect.size;
    
    //Special-case for empty dockingrows.
    if (self.subviews.count == 0) {
        NSLayoutAttribute attr1 = NSLayoutAttributeHeight;
        NSInteger length = rect.size.height;
        if (self->_is_vertical) {
            attr1 = NSLayoutAttributeWidth;
            length = rect.size.width;
        }
        
        self->_empty_constraint = [NSLayoutConstraint constraintWithItem:self attribute:attr1 relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:length];
        
        [self addConstraint:self->_empty_constraint];
        return;
    }
    
    NSInteger length = rect.size.height;
    if (self->_is_vertical) {
        length = rect.size.width;
    }
    
    if (pos < self.subviews.count) {
        [[self->_spacing_constraints objectAtIndex:pos] setConstant:length];
    } else {
        self->_bottom_margin_constraint.constant = length;
    }
};

- (void)removePreviousSpaceReservation {
    if (self->_is_reservation_active) {
        if (self->_empty_constraint) {
            [self removeConstraint:self->_empty_constraint];
            self->_empty_constraint = nil;
        }
        
        if (self->_bottom_margin_constraint) {
            self->_bottom_margin_constraint.constant = _MARGINS;
        }
        
        if (self->_reserved_before < self.subviews.count) {
            [[self->_spacing_constraints objectAtIndex:self->_reserved_before] setConstant:_MARGINS];
        }
        
        self->_is_reservation_active = NO;
    }
};

- (void)addMarginConstraintsForView:(NSView*)subview {
    //Add margins
    NSLayoutAttribute attr1 = NSLayoutAttributeLeft;
    NSLayoutAttribute attr2 = NSLayoutAttributeRight;
    if (self->_is_vertical) {
        attr1 = NSLayoutAttributeBottom;
        attr2 = NSLayoutAttributeTop;
    }
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:attr1 relatedBy:NSLayoutRelationEqual toItem:self attribute:attr1 multiplier:1.0 constant:_MARGINS]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:attr2 relatedBy:NSLayoutRelationEqual toItem:self attribute:attr2 multiplier:1.0 constant:_MARGINS * -1]];
};

- (NSLayoutConstraint*)createConstraintStapleView:(NSView*)view1 toView:(NSView*)view2 {
    NSLayoutAttribute attr1 = NSLayoutAttributeBottom;
    NSLayoutAttribute attr2 = NSLayoutAttributeTop;
    NSView* attr1View = view1;
    NSView* attr2View = view2;
    
    if (self->_is_vertical) {
        attr1 = NSLayoutAttributeLeft;
        attr2 = NSLayoutAttributeRight;
        attr1View = view2;
        attr2View = view1;
    }
    
    return [NSLayoutConstraint constraintWithItem:attr1View attribute:attr1 relatedBy:NSLayoutRelationEqual toItem:attr2View attribute:attr2 multiplier:1.0 constant:_MARGINS];
};

- (NSLayoutConstraint*)createConstraintTopMarginForView:(NSView*)view1 {
    if (self->_is_vertical) {
        return [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:_MARGINS];
    } else {
        return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeTop multiplier:1.0 constant:_MARGINS];
    }
}

- (void)didAddSubview:(NSView*)subview {
    NSLayoutConstraint* newStapleConstraint;
    NSUInteger pos = [self.subviews indexOfObject:subview]; //why do I gotta DO THIS
    NSView* previousView = nil;
    if (pos != 0) { //oh that's why
        [self.subviews objectAtIndex:pos - 1];
    }
    
    [self removePreviousSpaceReservation];
    [self addMarginConstraintsForView:subview];
    
    if (pos < self.subviews.count - 1) { //Inserting a subview
        NSView* nextView = [self.subviews objectAtIndex:pos + 1];
        [self removeConstraint:[self->_spacing_constraints objectAtIndex:pos]];
        newStapleConstraint = [self createConstraintStapleView:nextView toView:subview];
        [self addConstraint:newStapleConstraint];
        [self->_spacing_constraints replaceObjectAtIndex:pos withObject:newStapleConstraint];
    }
    
    if (previousView == nil) {
        newStapleConstraint = [self createConstraintTopMarginForView:subview];
    } else {
        newStapleConstraint = [self createConstraintStapleView:subview toView:previousView];
    }
    
    [self addConstraint:newStapleConstraint];
    
    if (pos < self.subviews.count - 1) {
        [self->_spacing_constraints insertObject:newStapleConstraint atIndex:pos];
    } else {
        [self->_spacing_constraints addObject:newStapleConstraint];
    }
};

- (void)willRemoveSubview:(NSView*)subview {
    [self removePreviousSpaceReservation];
    
    //why do I gotta DO THIS
    NSUInteger pos = [self.subviews indexOfObject:subview];
    NSView* nextView = nil;
    NSView* previousView = nil;
    
    if (pos != 0) {
        previousView = [self.subviews objectAtIndex:pos - 1];
    }
    
    if (pos < self.subviews.count - 1) {
        nextView = [self.subviews objectAtIndex:pos + 1];
    }
    
    if (nextView != nil) {
        NSLayoutConstraint* stapleConstraint;
        
        if (previousView != nil) {
            stapleConstraint = [self createConstraintStapleView:nextView toView:previousView];
        } else {
            stapleConstraint = [self createConstraintTopMarginForView:nextView];
        }
        
        [self->_spacing_constraints replaceObjectAtIndex:pos + 1 withObject:stapleConstraint];
    }
    
    [self->_spacing_constraints removeObjectAtIndex:pos];
};
@end