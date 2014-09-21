#include <Cocoa/Cocoa.h>

/* Manage free-floating panels that contain ICAKDockableViews of the Panel style.
 */

@interface ICAKPanelController : NSObject <ICAKDockableViewDelegate>

- (id)init;

- (void)dockableViewWillDetach:(ICAKDockableView*)view;

- (void)addPanel:(NSPanel*)panel;
- (void)addDock:(ICAKDock*)dock;

@end
