#import <icCanvasAppKit.h>

@interface ICAKDockableToolbar ()
- (void)recalculateIntrinsicSize;
@end

@implementation ICAKDockableToolbar {
    ICAKDockableToolbarBehavior _behavior;
    NSLayoutConstraint *_intrinsic_height, *_intrinsic_width;
}

- (id)init {
    self = [super init];
    
    if (self != nil) {
        self.style = ICAKDockableViewStyleToolbar;
        self.behavior = ICAKDockableToolbarBehaviorPalette;
        
        self._intrinsic_height = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
        self._intrinsic_width = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
        
        [self addConstraint:self._intrinsic_height];
        [self addConstraint:self._intrinsic_width];
    }
    
    return self;
}

- (ICAKDockableToolbarBehavior)behavior {
    return self._behavior;
};
- (void)setBehavior:(ICAKDockableToolbarBehavior)behavior {
    self._behavior = behavior;
};

- (int)buttonCount {
    return self->_btns.count;
};
- (int)addButton {
    NSButton* btn = [[NSButton alloc] init];
    
    btn.buttonType = NSTexturedSquareBezelStyle;
    
    [self addSubview:btn];
    return self.buttonCount;
};
- (int)addButtonBeforeButton:(int)button {
    NSButton* btn = [[NSButton alloc] init];
    
    btn.buttonType = NSTexturedSquareBezelStyle;
    
    [self addSubview:btn positioned:NSWindowBelow relativeTo:[self.subviews objectAtIndex:button]];
    return self.buttonCount;
};
- (void)setButton:(int)btnCount action:(SEL)action andTarget:(id)target {
    NSButton* btn = [self.subviews objectAtIndex:button];
    
    btn.action = action;
    btn.target = target;
};
- (void)setButton:(int)btnCount image:(NSImage*)img {
    NSButton* btn = [self.subviews objectAtIndex:button];
    
    btn.image = img;
};

- (void)recalculateIntrinsicSize {
    CGFloat main_length = ICAKDockableViewToolbarTopMargin + ICAKDockableViewToolbarBottomMargin + (ICAKDockableViewToolbarControlLength * self.subviews.count) + (ICAKDockableViewToolbarControlMargin * self.subviews.count);
    CGFloat cross_length = ICAKDockableViewMinToolbarSize;
    
    if (self.isVertical) {
        self._intrinsic_height.constant = main_length;
        self._intrinsic_width.constant = cross_length;
    } else {
        self._intrinsic_width.constant = main_length;
        self._intrinsic_height.constant = cross_length;
    }
}

- (void)layout {
    [super layout];
    
    NSInteger colCross, colMain, countCross = 0, countMain = 0;
    if (self.isVertical) {
        colCross = floor(self.frame.size.width / ICAKDockableViewToolbarControlLength);
        colMain = floor(self.frame.size.height / ICAKDockableViewToolbarControlLength);
    } else {
        colMain = floor(self.frame.size.width / ICAKDockableViewToolbarControlLength);
        colCross = floor(self.frame.size.height / ICAKDockableViewToolbarControlLength);
    }
    
    for (NSView* subview in self.subviews) {
        NSRect subframe = subview.frame;
        NSRect subbounds = subview.bounds;
        
        if (self.isVertical) {
            subframe.origin.x = self.bounds.size.height - ICAKDockableViewToolbarControlLength * countMain;
            subframe.origin.y = ICAKDockableViewToolbarSideMargin + ICAKDockableViewToolbarControlLength * countCross;
        } else {
            subframe.origin.y = self.bounds.size.width - ICAKDockableViewToolbarControlLength * countMain;
            subframe.origin.x = ICAKDockableViewToolbarSideMargin + ICAKDockableViewToolbarControlLength * countCross;
        }
        
        subview.frame = subframe;
        subview.bounds = subbounds;
        
        countCross++;
        if (countCross >= colCross) {
            countCross = 0;
            countMain++;
        }
    }
};

@end