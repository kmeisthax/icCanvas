#import <Cocoa/Cocoa.h>

/* Provides the ability for users to dock toolbars and panels to the sides of
 * a widget.
 */
@interface ICAKDock : NSView <NSSplitViewDelegate>
- (id)init;
- (id)initWithFrame:(NSRect)frameRect;

- (NSView*)documentView;
- (void)setDocumentView:(NSView*)view;

- (void)attachDockableView:(ICAKDockableView*)view toEdge:(ICAKDockEdge)edge;
@end
