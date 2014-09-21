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

/* Fired when the dockable view is considering attaching to a panel or dock.
 * Returning NO causes the dockable to cancel attaching to the panel or dock.
 *
 * If YES, the delegate should arrange for the Panel or Dock to indicate that
 * the DockableView can be docked to the desired point, and expect a willAttach
 * message to be sent shortly thereafter.
 *
 * If NO, the DockableView is not permitted to send a willAttach message and
 * the delegate will perform no auxiliary UI actions.
 *
 */
- (BOOL)dockableView:(ICAKDockableView*)view shouldAttachToPanel:(NSPanel*)panel;
- (BOOL)dockableView:(ICAKDockableView*)view shouldAttachToDock:(ICAKDock*)dock;

/* Fired when a dockable view wants to be attached to a panel or dock.
 *
 * The delegate recieving this message should arrange to have the dockable view
 * placed in the indicated area.
 */
- (void)dockableView:(ICAKDockableView*)view willAttachToPanel:(NSPanel*)panel atOffset:(NSInteger)offset;
- (void)dockableView:(ICAKDockableView*)view willAttachToDock:(ICAKDock*)dock onEdge:(ICAKDockEdge)edge onRow:(NSInteger)rowsFromEdge atOffset:(NSInteger)offset;

/* Fired when the dockable view cancels the attachment operation. The delegate
 * should remove any animations or placeholders added by a shouldAttach message
 * and, if the dockable view was placed inside a new NSPanel, make said NSPanel
 * permenant.
 */
- (void)dockableViewDidNotAttach:(ICAKDockableView*)view;

@end
