#import <icCanvasAppKit.h>

@interface ICAKDockableView ()
- (void)setup;
@end

@implementation ICAKDockableView {
    BOOL _in_detach;
    NSPoint _starting_pt, _starting_loc;
    CGFloat _detach_threshold;
    
    ICAKDockableViewStyle _style;
    id <ICAKDockableViewDelegate> _delegate;
}

- (void)setup {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self->_in_detach = NO;
    self->_detach_threshold = 20.0;
    self->_delegate = NULL;
    self->_style = ICAKDockableViewStylePanel;
};

- (id)init {
    self = [super init];
    
    if (self != nil) {
        [self setup];
    }
    
    return self;
}

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
    float mouse_dX = NSEvent.mouseLocation.x - self->_starting_pt.x,
          mouse_dY = NSEvent.mouseLocation.y - self->_starting_pt.y,
          frame_dX = self->_starting_loc.x + mouse_dX,
          frame_dY = self->_starting_loc.y + mouse_dY,
          dragDistance = sqrt(mouse_dX*mouse_dX + mouse_dY*mouse_dY);
    
    if (!self->_in_detach && dragDistance > self->_detach_threshold) {
        [self->_delegate dockableViewWillDetach:self];
        self->_in_detach = YES;
        
        //Once detached, starting_pt is reused for a drag
        self->_starting_pt = NSEvent.mouseLocation;
        self->_starting_loc = self.window.frame.origin;
    } else if (self->_in_detach) {
        [self->_delegate dockableView:self wasDraggedByEvent:event];
        
        //Drag containing window once detached
        NSRect winFrame = self.window.frame;
        winFrame.origin.x = frame_dX;
        winFrame.origin.y = frame_dY;
        self.window.frameOrigin = winFrame.origin;
    }
};

- (void)mouseUp:(NSEvent*)event {
    [self->_delegate dockableViewWasReleased:self];
    self->_in_detach = NO;
};

- (id <ICAKDockableViewDelegate>)delegate {
    return self->_delegate;
};

- (void)setDelegate:(id <ICAKDockableViewDelegate>)delegate {
    self->_delegate = delegate;
};

@end