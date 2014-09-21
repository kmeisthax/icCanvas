#import <icCanvasAppKit.h>

@interface ICAKDockableView ()
- (void)setup;
@end

@implementation ICAKDockableView {
    BOOL _in_detach;
    NSPoint _starting_pt;
    CGFloat _detach_threshold;
    
    ICAKDockableViewStyle _style;
    id <ICAKDockableViewDelegate> _delegate;
}

- (void)setup {
    self->_in_detach = NO;
    self->_detach_threshold = 20.0;
    self->_delegate = NULL;
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

- (ICAKDockableViewStyle)style {
    return self->_style;
};
- (void)setStyle:(ICAKDockableViewStyle)style {
    self->_style = style;
};

- (void)mouseDown:(NSEvent*)event {
    self->_in_detach = NO;
    self->_starting_pt = NSEvent.mouseLocation;
};

- (void)mouseDragged:(NSEvent*)event {
    float dX = NSEvent.mouseLocation.x - self->_starting_pt.x,
          dY = NSEvent.mouseLocation.y - self->_starting_pt.y,
          dragDistance = sqrt(dX*dX + dY*dY);
    
    if (!self->_in_detach && dragDistance > self->_detach_threshold) {
        //Detach from window
        [self->_delegate dockableViewWillDetach:self];
        self->_in_detach = YES;
    }
};

- (void)mouseUp:(NSEvent*)event {
    self->_in_detach = NO;
};

- (id <ICAKDockableViewDelegate>)delegate {
    return self->_delegate;
};

- (void)setDelegate:(id <ICAKDockableViewDelegate>)delegate {
    self->_delegate = delegate;
};

@end