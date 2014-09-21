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
        if (self.superview.subviews.count > 1) {
            [self->_delegate dockableViewWillDetach:self];
        }
        
        self->_in_detach = YES;
        
        //Once detached, starting_pt is reused for a drag
        self->_starting_pt = NSEvent.mouseLocation;
    } else {
        //Drag containing window once detached
        NSRect winFrame = self.window.frame;
        winFrame.origin.x = winFrame.origin.x + dX;
        winFrame.origin.y = winFrame.origin.y + dY;
        self.window.frame = winFrame;
        
        self->_starting_pt = NSEvent.mouseLocation;
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