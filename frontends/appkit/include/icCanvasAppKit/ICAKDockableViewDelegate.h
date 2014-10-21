#include <Cocoa/Cocoa.h>

@class ICAKDock;

@protocol ICAKDockableViewDelegate

/* Fired when the dockable view wants to detach from it's parent.
 *
 * Depending on the situation, the delegate may arrange for the view to be
 * reparented to a temporary NSPanel immediately, or not. In either case, the
 * DockableView will proceed to move it's parent NSWindow in response to drag
 * events.
 */
- (void)dockableViewWillDetach:(ICAKDockableView*)view;

/* Fired when the dockable view has detached and recieved a drag event.
 *
 * The default behavior of a dockable view is to drag it's parent window, but
 * this may be used to add additional functionality.
 */
- (BOOL)dockableView:(ICAKDockableView*)view wasDraggedByEvent:(NSEvent*)evt;

/* Fired when a detached dockable view has been released by the user.
 *
 * The delegate may, at it's leisure, mutate the view hierarchy as needed to
 * support docking the released view back to another dock or panel.
 */
- (BOOL)dockableViewWasReleased:(ICAKDockableView*)view;

@end
