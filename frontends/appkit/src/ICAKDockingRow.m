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
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
};

- (void)drawRect:(NSRect)rekt {
    NSGraphicsContext* cocoaContext = [NSGraphicsContext currentContext];
    NSColor *color = [NSColor colorWithCatalogName:@"System" colorName:@"_sourceListBackgroundColor"];
    if (color == nil) {
        NSTableView *tableView = [[NSTableView alloc] initWithFrame:NSZeroRect];
        [tableView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList];
        color = [tableView backgroundColor];
    }
    
    [color setFill];
    NSRectFill(rekt);
}

- (id)init {
    self = [super init];
    
    if (self != nil) {
        [self setup];
    }
    
    return self;
}

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

- (ICAKDockableViewStyle)prevailingStyle {
    return self->_prevailing_style;
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
    
    NSInteger length = rect.size.width;
    if (self->_is_vertical) {
        length = rect.size.height;
    }
    
    if (pos < self.subviews.count) {
        if ((pos == 0 && self->_is_vertical) || !self->_is_vertical) {
            [[self->_spacing_constraints objectAtIndex:pos] setConstant:length * -1.0];
        } else {
            [[self->_spacing_constraints objectAtIndex:pos] setConstant:length];
        }
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
        
        if (self->_reserved_before < self->_spacing_constraints.count) {
            if (self->_reserved_before == 0 && self->_is_vertical) {
                [[self->_spacing_constraints objectAtIndex:self->_reserved_before] setConstant:_MARGINS * -1.0];
            } else {
                [[self->_spacing_constraints objectAtIndex:self->_reserved_before] setConstant:_MARGINS];
            }
        }
        
        self->_is_reservation_active = NO;
    }
};

- (void)addMarginConstraintsForView:(NSView*)subview {
    //Add margins
    NSLayoutAttribute attr1 = NSLayoutAttributeTop;
    NSLayoutAttribute attr2 = NSLayoutAttributeBottom;
    if (self->_is_vertical) {
        attr1 = NSLayoutAttributeLeft;
        attr2 = NSLayoutAttributeRight;
    }
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:attr1 relatedBy:NSLayoutRelationEqual toItem:self attribute:attr1 multiplier:1.0 constant:_MARGINS]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:subview attribute:attr2 relatedBy:NSLayoutRelationEqual toItem:self attribute:attr2 multiplier:1.0 constant:_MARGINS * -1.0]];
};

- (NSLayoutConstraint*)createConstraintStapleView:(NSView*)view1 toView:(NSView*)view2 {
    NSLayoutAttribute attr1 = NSLayoutAttributeTop;
    NSLayoutAttribute attr2 = NSLayoutAttributeBottom;
    NSView* attr1View = view1;
    NSView* attr2View = view2;
    
    if (!self->_is_vertical) {
        attr1 = NSLayoutAttributeRight;
        attr2 = NSLayoutAttributeLeft;
        attr1View = view2;
        attr2View = view1;
        return [NSLayoutConstraint constraintWithItem:attr1View attribute:attr1 relatedBy:NSLayoutRelationEqual toItem:attr2View attribute:attr2 multiplier:1.0 constant:_MARGINS * -1.0];
    }
    
    return [NSLayoutConstraint constraintWithItem:attr1View attribute:attr1 relatedBy:NSLayoutRelationEqual toItem:attr2View attribute:attr2 multiplier:1.0 constant:_MARGINS];
};

- (NSLayoutConstraint*)createConstraintTopMarginForView:(NSView*)view1 {
    if (!self->_is_vertical) {
        return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:_MARGINS * -1.0];
    } else {
        return [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeTop multiplier:1.0 constant:_MARGINS * -1.0];
    }
}

- (void)didAddSubview:(NSView*)subview {
    if ([subview isKindOfClass:ICAKDockableView.class]) {
        if (self->_prevailing_style != ((ICAKDockableView*)subview).style) {
            self->_prevailing_style = ((ICAKDockableView*)subview).style;
        }
    }
    
    [self removePreviousSpaceReservation];
    [self addMarginConstraintsForView:subview];
    [self regenerateSpacingConstraints];
};

- (void)willRemoveSubview:(NSView*)subview {
    [self removePreviousSpaceReservation];
    [self regenerateSpacingConstraintsExcludingSubview:subview];
};

- (void)regenerateSpacingConstraints {
    [self regenerateSpacingConstraintsExcludingSubview:nil];
}

- (void)regenerateSpacingConstraintsExcludingSubview:(NSView*)deadview {
    for (NSLayoutConstraint* constraint in self->_spacing_constraints) {
        [self removeConstraint:constraint];
    }
    
    [self->_spacing_constraints removeAllObjects];
    
    NSView* previousView = nil;
    
    for (NSView* view in self.subviews) {
        if (view == deadview) continue;
        
        NSLayoutConstraint* stapleConstraint;
        if (previousView == nil) {
            stapleConstraint = [self createConstraintTopMarginForView:view];
        } else {
            stapleConstraint = [self createConstraintStapleView:view toView:previousView];
        }
        
        [self addConstraint:stapleConstraint];
        [self->_spacing_constraints addObject:stapleConstraint];
        
        previousView = view;
    }
}

+ (NSRect)viewFramePlusMargins:(NSView*)subview {
    NSRect svFrame = subview.frame;
    return NSInsetRect(svFrame, ICAKDockableViewPanelMargins * -1.0, ICAKDockableViewPanelMargins * -1.0);
};

- (BOOL)isScreenPoint:(NSPoint)pt beforePosition:(NSInteger)pos {
    //TODO: Account for BIDI
    CGFloat main_pos, main_length = 0;
    NSView* theSubView = [self.subviews objectAtIndex:pos];
    NSRect winRelFrame = [self convertRect:self.frame toView:nil],
           svRelFrame = [self convertRect:theSubView.frame toView:nil];
    NSRect absFrame = [self.window convertRectToScreen:winRelFrame],
           svAbsFrame = [self.window convertRectToScreen:svRelFrame];
    
    if (self->_is_vertical) {
        main_pos = pt.y;
        main_length = svAbsFrame.origin.y + (svAbsFrame.size.height / 2.0);
        return main_length > main_pos;
    } else {
        main_pos = pt.x;
        main_length = svAbsFrame.origin.x + (svAbsFrame.size.width / 2.0);
        return main_pos > main_length;
    }
};
@end