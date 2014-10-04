#import <icCanvasAppKit.h>

static const NSInteger _MARGINS_LABEL_BOTTOM = 15;

@interface ICAKDockablePanel ()

- (void)dockablePanelSetupSubviews;

@end

@implementation ICAKDockablePanel {
    NSTextView* _label;
    NSView* _content;
}

- (void)dockablePanelSetupSubviews {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:240]];
    
    self->_label = [[NSTextView alloc] init];
    [self addSubview:self->_label];
    
    self->_label.editable = NO;
    self->_label.selectable = NO;
    self->_label.drawsBackground = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self->_label attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self->_label attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self->_label attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
    
    self->_content = nil;
};

- (id)init {
    self = [super init];
    
    if (self != nil) {
        [self dockablePanelSetupSubviews];
    }
    
    return self;
}

- (id)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    
    if (self != nil) {
        [self dockablePanelSetupSubviews];
    }
    
    return self;
};

- (NSView*)contentView {
    return self->_content;
};

- (void)setContentView:(NSView*)view {
    if (self->_content != nil) {
        [self->_content removeFromSuperview];
    }
    
    self->_content = view;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self->_content attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self->_content attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self->_label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self->_content attribute:NSLayoutAttributeTop multiplier:1.0 constant:_MARGINS_LABEL_BOTTOM * -1]];
};

- (void)setLabel:(NSString*)lbl {
    self->_label.textStorage.mutableString.string = lbl;
};

@end