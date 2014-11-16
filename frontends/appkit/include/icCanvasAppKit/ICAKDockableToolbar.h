#import <Cocoa/Cocoa.h>

/* Provides a DockableView that displays a row of selectable drawing tools or
 * action buttons.
 *
 * Not related to NSToolbar, which is separate from the view hierarchy and thus
 * unsuitable for use in docking.
 *
 * Seriously why does Apple have so many non-NSView forms of views?!
 */
@interface ICAKDockableToolbar : ICAKDockableView
- (id)init;

- (ICAKDockableToolbarBehavior)behavior;
- (void)setBehavior:(ICAKDockableToolbarBehavior)behavior;

- (int)buttonCount;
- (int)addButton;
- (int)addButtonBeforeButton:(int)button;
- (void)setButton:(int)btnCount action:(SEL)action andTarget:(id)target;
- (void)setButton:(int)btnCount image:(NSImage*)img;
@end
