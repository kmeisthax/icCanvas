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
        
        self->_intrinsic_height = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
        self->_intrinsic_width = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
        
        [self addConstraint:self->_intrinsic_height];
        [self addConstraint:self->_intrinsic_width];
    }
    
    return self;
}

- (ICAKDockableToolbarBehavior)behavior {
    return self->_behavior;
};
- (void)setBehavior:(ICAKDockableToolbarBehavior)behavior {
    self->_behavior = behavior;
};

- (int)buttonCount {
    return self.subviews.count;
};
- (int)addButton {
    NSButton* btn = [[NSButton alloc] init];
    
    btn.buttonType = NSMomentaryPushInButton;
    btn.bezelStyle = NSTexturedSquareBezelStyle;
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:btn];
    [self setNeedsLayout:YES];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:ICAKDockableViewToolbarControlLength]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:ICAKDockableViewToolbarControlLength]];
    [self recalculateIntrinsicSize];
    
    return self.buttonCount - 1;
};
- (int)addButtonBeforeButton:(int)button {
    NSButton* btn = [[NSButton alloc] init];
    
    btn.buttonType = NSMomentaryPushInButton;
    btn.bezelStyle = NSTexturedSquareBezelStyle;
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:btn positioned:NSWindowBelow relativeTo:[self.subviews objectAtIndex:button]];
    [self setNeedsLayout:YES];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:ICAKDockableViewToolbarControlLength]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:ICAKDockableViewToolbarControlLength]];
    [self recalculateIntrinsicSize];
    
    return self.buttonCount - 1;
};
- (void)setButton:(int)btnCount action:(SEL)action andTarget:(id)target {
    NSButton* btn = [self.subviews objectAtIndex:btnCount];
    
    btn.action = action;
    btn.target = target;
};
- (void)setButton:(int)btnCount image:(NSImage*)img {
    NSButton* btn = [self.subviews objectAtIndex:btnCount];
    
    btn.image = img;
};
- (void)setButton:(int)btnCount type:(NSButtonType)type {
    NSButton* btn = [self.subviews objectAtIndex:btnCount];
    
    btn.buttonType = type;
};

- (void)recalculateIntrinsicSize {
    CGFloat main_length = ICAKDockableViewToolbarTopMargin + ICAKDockableViewToolbarBottomMargin + (ICAKDockableViewToolbarControlLength * self.subviews.count) + (ICAKDockableViewToolbarControlMargin * self.subviews.count);
    CGFloat cross_length = ICAKDockableViewMinToolbarSize;
    
    if (!self.vertical) {
        self->_intrinsic_height.constant = main_length;
        self->_intrinsic_width.constant = cross_length;
    } else {
        self->_intrinsic_width.constant = main_length;
        self->_intrinsic_height.constant = cross_length;
    }
    
    NSLog(@"New minimum size %fx%f", self->_intrinsic_height.constant, self->_intrinsic_width.constant);
}

- (void)layout {
    NSInteger colCross, colMain, countCross = 0, countMain = 0;
    if (self.vertical) {
        colCross = floor(self.frame.size.width / ICAKDockableViewToolbarControlLength);
        colMain = floor(self.frame.size.height / ICAKDockableViewToolbarControlLength);
    } else {
        colMain = floor(self.frame.size.width / ICAKDockableViewToolbarControlLength);
        colCross = floor(self.frame.size.height / ICAKDockableViewToolbarControlLength);
    }
    
    for (NSView* subview in self.subviews) {
        NSRect subframe = subview.frame;
        
        if (self.vertical) {
            subframe.origin.x = ICAKDockableViewToolbarSideMargin + ICAKDockableViewToolbarControlLength * countCross;
            subframe.origin.y = self.frame.size.height - (ICAKDockableViewToolbarTopMargin + ICAKDockableViewToolbarControlLength * countMain + ICAKDockableViewToolbarControlMargin * countMain);
        } else {
            subframe.origin.x = ICAKDockableViewToolbarTopMargin + ICAKDockableViewToolbarControlLength * countMain + ICAKDockableViewToolbarControlMargin * countMain;
            subframe.origin.y = self.frame.size.height - ICAKDockableViewToolbarSideMargin - ICAKDockableViewToolbarControlLength * (countCross + 1);
        }
        
        subframe.size.width = ICAKDockableViewToolbarControlLength;
        subframe.size.height = ICAKDockableViewToolbarControlLength;
        
        NSLog(@"New frame %fx%f size %fx%f", subframe.origin.x, subframe.origin.y, subframe.size.width, subframe.size.height);
        
        subview.frame = subframe;
        
        countCross++;
        if (countCross >= colCross) {
            countCross = 0;
            countMain++;
        }
    }
    
    [super layout];
};

@end