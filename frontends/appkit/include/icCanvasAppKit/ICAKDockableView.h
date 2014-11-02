#import <Cocoa/Cocoa.h>

@protocol ICAKDockableViewDelegate;

/* Provides a widget type that allows users to move the view around an ICAKDock,
 * or even to it's own NSPanel.
 */
@interface ICAKDockableView : NSView
- (id)init;

- (ICAKDockableViewStyle)style;
- (void)setStyle:(ICAKDockableViewStyle)style;

- (void)mouseDown:(NSEvent*)event;
- (void)mouseDragged:(NSEvent*)event;
- (void)mouseUp:(NSEvent*)event;

- (id <ICAKDockableViewDelegate>)delegate;
- (void)setDelegate:(id <ICAKDockableViewDelegate>)delegate;

- (BOOL)vertical;
- (void)setVertical:(BOOL)isVertical;

@end
