#include <Cocoa/Cocoa.h>

/* Manage free-floating panels that contain ICAKDockableViews of the Panel style.
 */

@interface ICAKDockingController : NSObject <ICAKDockableViewDelegate>

- (id)init;

- (void)dockableViewWillDetach:(ICAKDockableView*)view;
- (void)dockableView:(ICAKDockableView*)view wasDraggedByEvent:(NSEvent*)evt;
- (void)dockableViewWasReleased:(ICAKDockableView*)view;

- (void)addPanel:(NSPanel*)panel;
- (void)addDock:(ICAKDock*)dock;
- (void)addDrawingController:(ICAKDrawingController*)dc;

- (void)didAddDockable:(ICAKDockableView*)view toDock:(ICAKDock*)dock onRow:(ICAKDockingRow*)row;
- (void)didAddDockable:(ICAKDockableView*)view toPanel:(NSPanel*)panel onRow:(ICAKDockingRow*)row;

@end
