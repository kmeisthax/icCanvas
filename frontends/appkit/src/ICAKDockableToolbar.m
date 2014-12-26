#import <icCanvasAppKit.h>

typedef struct {
    SEL button_selector;
    __unsafe_unretained id button_target;
} ICAKDockableToolbarButtonState;

typedef struct {
    NSInteger tag;
} ICAKDockableToolbarTag;

@interface ICAKDockableToolbar (Private)
- (void)recalculateIntrinsicSize;
- (void)didPressButton:(id)sender;
@end

@implementation ICAKDockableToolbar {
    ICAKDockableToolbarBehavior _behavior;
    NSLayoutConstraint *_intrinsic_height, *_intrinsic_width;
    NSMutableDictionary *_button_actions;
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
        
        self->_button_actions = [[NSMutableDictionary alloc] init];
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
    btn.tag = self.buttonCount;
    btn.action = @selector(didPressButton:);
    btn.target = self;
    
    [self addSubview:btn];
    [self setNeedsLayout:YES];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:ICAKDockableViewToolbarControlLength]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:ICAKDockableViewToolbarControlLength]];
    [self recalculateIntrinsicSize];
    
    return self.buttonCount - 1; //-1 since we already added the button
};
- (int)addButtonBeforeButton:(int)button {
    NSButton* btn = [[NSButton alloc] init];
    
    btn.buttonType = NSMomentaryPushInButton;
    btn.bezelStyle = NSTexturedSquareBezelStyle;
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    btn.tag = self.buttonCount;
    btn.action = @selector(didPressButton:);
    btn.target = self;
    
    [self addSubview:btn positioned:NSWindowBelow relativeTo:[self.subviews objectAtIndex:button]];
    [self setNeedsLayout:YES];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:ICAKDockableViewToolbarControlLength]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:btn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:ICAKDockableViewToolbarControlLength]];
    [self recalculateIntrinsicSize];
    
    return self.buttonCount - 1;
};
- (void)setButton:(int)btnTag action:(SEL)action andTarget:(id)target {
    NSButton* btn = [self.subviews objectAtIndex:btnTag];
    ICAKDockableToolbarButtonState dat;
    ICAKDockableToolbarTag tag = {btnTag};
    
    NSValue* maybeDat = [self->_button_actions objectForKey:[NSValue value:&tag withObjCType:@encode(ICAKDockableToolbarTag)]];
    if (maybeDat != nil) {
        [maybeDat getValue:&dat];
    }
    
    dat.button_selector = action;
    dat.button_target = target;
    
    [self->_button_actions setObject:[NSValue valueWithBytes:&dat objCType:@encode(ICAKDockableToolbarButtonState)] forKey:[NSValue value:&tag withObjCType:@encode(ICAKDockableToolbarTag)]];
};
- (void)setButton:(int)btnTag image:(NSImage*)img {
    NSButton* btn = [self.subviews objectAtIndex:btnTag];
    
    btn.image = img;
};
- (void)setButton:(int)btnTag type:(NSButtonType)type {
    NSButton* btn = [self.subviews objectAtIndex:btnTag];
    
    btn.buttonType = type;
};

- (void)setVertical:(BOOL)isVertical {
    [super setVertical:isVertical];
    [self recalculateIntrinsicSize];
};

//Private methods

- (void)recalculateIntrinsicSize {
    CGFloat main_length = ICAKDockableViewToolbarTopMargin + ICAKDockableViewToolbarGripLength + ICAKDockableViewToolbarBottomMargin + (ICAKDockableViewToolbarControlLength * self.subviews.count) + (ICAKDockableViewToolbarControlMargin * self.subviews.count);
    CGFloat cross_length = ICAKDockableViewMinToolbarSize;
    
    if (self.vertical) {
        self->_intrinsic_height.constant = main_length;
        self->_intrinsic_width.constant = cross_length;
    } else {
        self->_intrinsic_height.constant = cross_length;
        self->_intrinsic_width.constant = main_length;
    }
}

- (void)didPressButton:(NSButton*)sender {
    ICAKDockableToolbarTag tag = {sender.tag};
    ICAKDockableToolbarButtonState dat;
    
    NSValue* maybeDat = [self->_button_actions objectForKey:[NSValue value:&tag withObjCType:@encode(ICAKDockableToolbarTag)]];
    if (maybeDat != nil) {
        [maybeDat getValue:&dat];
        
        NSInvocation* inv = [NSInvocation invocationWithMethodSignature:[dat.button_target methodSignatureForSelector:dat.button_selector]];
        inv.selector = dat.button_selector;
        
        NSInteger argCount = inv.methodSignature.numberOfArguments;
        
        if (argCount > 2) { //one argument, counting the hidden IMP arguments
            __unsafe_unretained id unsafe_self = self;
            [inv setArgument:&unsafe_self atIndex:2];
        }
        
        if (argCount > 3) { //two arguments, counting the hidden IMP arguments
            [inv setArgument:&tag atIndex:3];
        }
        
        [inv invokeWithTarget:dat.button_target];
    } else {
        NSLog(@"Got a button press for a button with no action set!");
    }
};

- (void)layout {
    NSInteger colCross, colMain, countCross = 0, countMain = 0;
    if (self.vertical) {
        colCross = floor(self.frame.size.width / ICAKDockableViewToolbarControlLength);
    } else {
        colCross = floor(self.frame.size.height / ICAKDockableViewToolbarControlLength);
    }
    
    if (colCross == 0) colCross = 1;
    colMain = ceil(self.subviews.count / colCross);
    
    [super layout];
    
    for (NSView* subview in self.subviews) {
        NSRect subframe = subview.frame;
        
        subframe.size.width = ICAKDockableViewToolbarControlLength;
        subframe.size.height = ICAKDockableViewToolbarControlLength;
        
        if (self.vertical) {
            subframe.origin.x = ICAKDockableViewToolbarSideMargin + ICAKDockableViewToolbarControlLength * countCross;
            subframe.origin.y = ICAKDockableViewToolbarBottomMargin + subframe.size.height * (colMain - countMain - 1) + ICAKDockableViewToolbarControlMargin * (colMain - countMain - 1);
        } else {
            subframe.origin.x = ICAKDockableViewToolbarTopMargin + ICAKDockableViewToolbarGripLength + subframe.size.width * countMain + ICAKDockableViewToolbarControlMargin * countMain;
            subframe.origin.y = ICAKDockableViewToolbarSideMargin + subframe.size.height * countCross;
        }
        
        subview.frame = subframe;
        
        countCross++;
        if (countCross >= colCross) {
            countCross = 0;
            countMain++;
        }
    }
};

- (void)drawRect:(NSRect)rekt {
    NSRect handleRekt;
    
    if (self.vertical) {
        handleRekt.origin.x = ICAKDockableViewToolbarSideMargin;
        handleRekt.origin.y = self.frame.size.height - ICAKDockableViewToolbarGripLength;
        handleRekt.size.height = ICAKDockableViewToolbarGripLength;
        handleRekt.size.width = self.frame.size.width - ICAKDockableViewToolbarSideMargin * 2;
    } else {
        handleRekt.origin.x = 0.0f;
        handleRekt.origin.y = ICAKDockableViewToolbarSideMargin;
        handleRekt.size.height = self.frame.size.height - ICAKDockableViewToolbarSideMargin * 2;
        handleRekt.size.width = ICAKDockableViewToolbarGripLength;
    }
    
    [NSColor.highlightColor setFill];
    NSRectFill(handleRekt);
    
    [super drawRect:rekt];
};

@end