#import <Cocoa/Cocoa.h>

/* Provides the ability for users to dock toolbars and panels to the sides of
 * a widget.
 */
@interface ICAKDock : NSView <NSSplitViewDelegate>
- (id)init;

- (NSView*)documentView;
- (void)setDocumentView:(NSView*)view;

- (void)attachDockableView:(ICAKDockableView*)view toEdge:(ICAKDockEdge)edge;
- (void)attachDockableView:(ICAKDockableView*)view toEdge:(ICAKDockEdge)edge onRow:(NSInteger)rowsFromEdge atOffset:(NSInteger)offset;
- (void)createNewRowOnEdge:(ICAKDockEdge)edge beforeRow:(NSInteger)rowsFromEdge;

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(NSInteger)dividerIndex;
- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(NSInteger)dividerIndex;
@end
