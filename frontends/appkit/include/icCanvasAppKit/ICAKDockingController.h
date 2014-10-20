#include <Cocoa/Cocoa.h>

/* Manage free-floating panels that contain ICAKDockableViews of the Panel style.
 */

@interface ICAKDockingController : NSObject <ICAKDockableViewDelegate>

- (id)init;

- (void)dockableViewWillDetach:(ICAKDockableView*)view;
- (BOOL)dockableView:(ICAKDockableView*)view shouldAttachToPanel:(NSPanel*)panel;
- (BOOL)dockableView:(ICAKDockableView*)view shouldAttachToDock:(ICAKDock*)dock;
- (void)dockableView:(ICAKDockableView*)view willAttachToPanel:(NSPanel*)panel atOffset:(NSInteger)offset;
- (void)dockableView:(ICAKDockableView*)view willAttachToDock:(ICAKDock*)dock onEdge:(ICAKDockEdge)edge onRow:(NSInteger)rowsFromEdge atOffset:(NSInteger)offset;
- (void)dockableViewDidNotAttach:(ICAKDockableView*)view;

- (void)addPanel:(NSPanel*)panel;
- (void)addDock:(ICAKDock*)dock;
- (void)addDrawingController:(ICAKDrawingController*)dc;

- (void)didAddDockable:(ICAKDockableView*)view toDock:(ICAKDock*)dock onRow:(ICAKDockingRow*)row;
- (void)didAddDockable:(ICAKDockableView*)view toPanel:(NSPanel*)panel onRow:(ICAKDockingRow*)row;

@end
