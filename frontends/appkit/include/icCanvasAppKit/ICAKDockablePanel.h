#import <icCanvasAppKit.h>

@interface ICAKDockablePanel : ICAKDockableView

- (id)init;
- (id)initWithFrame:(NSRect)frameRect;

- (NSView*)contentView;
- (void)setContentView:(NSView*)view;

- (void)setLabel:(NSString*)lbl;

@end
