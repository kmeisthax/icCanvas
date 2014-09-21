#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSInteger, ICAKDockableViewStyle) {
    ICAKDockableViewStyleToolbar,
    ICAKDockableViewStylePanel
};

/* Provides a widget type that allows users to move the view around an ICAKDock,
 * or even to it's own NSPanel.
 */
@interface ICAKDockableView : NSView
- (id)init;
- (id)initWithFrame:(NSRect)frameRect;

- (ICAKDockableViewStyle)style;
- (void)setStyle:(ICAKDockableViewStyle)style;

- (void)mouseDown:(NSEvent*)event;
- (void)mouseDragged:(NSEvent*)event;
- (void)mouseUp:(NSEvent*)event;

- (id <ICAKDockableViewDelegate>)delegate;
- (void)setDelegate:(id <ICAKDockableViewDelegate>)delegate;

@end
