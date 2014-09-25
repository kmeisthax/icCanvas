#include <Cocoa/Cocoa.h>

/* Manage free-floating panels that contain ICAKDockableViews of the Panel style.
 */

@interface ICAKPanelController : NSObject <ICAKDockableViewDelegate>

- (id)init;

- (void)dockableViewWillDetach:(ICAKDockableView*)view;
- (BOOL)dockableView:(ICAKDockableView*)view shouldAttachToPanel:(NSPanel*)panel;
- (BOOL)dockableView:(ICAKDockableView*)view shouldAttachToDock:(ICAKDock*)dock;
- (void)dockableView:(ICAKDockableView*)view willAttachToPanel:(NSPanel*)panel atOffset:(NSInteger)offset;
- (void)dockableView:(ICAKDockableView*)view willAttachToDock:(ICAKDock*)dock onEdge:(ICAKDockEdge)edge onRow:(NSInteger)rowsFromEdge atOffset:(NSInteger)offset;
- (void)dockableViewDidNotAttach:(ICAKDockableView*)view;

- (void)addPanel:(NSPanel*)panel;
- (void)addDock:(ICAKDock*)dock;

@end
