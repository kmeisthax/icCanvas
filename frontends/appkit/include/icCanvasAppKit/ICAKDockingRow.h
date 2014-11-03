#import <Cocoa/Cocoa.h>

/* Provides an intermediary between a DockableView and a Dock.
 *
 * Intended to be shoved within the SplitViews of a Dock, perhaps in a
 * ScrollView.
 */
@interface ICAKDockingRow : NSView
+ (BOOL)requiresConstraintBasedLayout;

- (id)init;

- (BOOL)vertical;
- (void)setVertical:(BOOL)isVertical;

- (BOOL)canAcceptDockableView:(ICAKDockableView*)dview;
- (ICAKDockableViewStyle)prevailingStyle;

- (NSInteger)insertionPositionForPoint:(NSPoint)pt;
- (void)reserveSpace:(NSRect)rect atPosition:(NSInteger)pos;
- (void)removePreviousSpaceReservation;

- (void)didAddSubview:(NSView*)subview;
- (void)willRemoveSubview:(NSView*)subview;

+ (NSRect)viewFramePlusMargins:(NSView*)subview;
- (BOOL)isScreenPoint:(NSPoint)pt beforePosition:(NSInteger)pos;

- (void)regenerateSpacingConstraints;
- (void)regenerateSpacingConstraintsExcludingSubview:(NSView*)view;
@end
