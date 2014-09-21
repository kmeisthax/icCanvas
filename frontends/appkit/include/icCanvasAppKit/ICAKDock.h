#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSInteger, ICAKDockEdge) {
    ICAKDockEdgeTop,
    ICAKDockEdgeBottom,
    ICAKDockEdgeLeft,
    ICAKDockEdgeRight
}

/* Provides the ability for users to dock toolbars and panels to the sides of
 * a widget.
 */
@interface ICAKDock : NSView <NSSplitViewDelegate>
- (id)init;
- (id)initWithFrame:(NSRect)frameRect;

- (NSView*)documentView;
- (void)setDocumentView:(NSView*)view;

- attachDockableView:(ICAKDockableView*)view toEdge:(ICAKDockEdge)edge;
@end
