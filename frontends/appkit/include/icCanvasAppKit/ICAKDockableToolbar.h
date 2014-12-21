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

/* Add a button.
 *
 * The returned integer is the button's tag and should be used to refer to the
 * button through all other operations.
 */
- (int)addButton;
- (int)addButtonBeforeButton:(int)btnTag;
- (void)setButton:(int)btnTag image:(NSImage*)img;
- (void)setButton:(int)btnTag type:(NSButtonType)type;

/* Set the action and target of a particular button.
 *
 * The action may have up to two arguments. The first argument will be the
 * sending Dockable Toolbar. The second argument will be the tag of the button
 * that was clicked.
 */
- (void)setButton:(int)btnTag action:(SEL)action andTarget:(id)target;
@end
