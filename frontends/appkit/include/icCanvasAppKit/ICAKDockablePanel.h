#import <icCanvasAppKit.h>

@interface ICAKDockablePanel : ICAKDockableView

- (id)init;

- (NSView*)contentView;
- (void)setContentView:(NSView*)view;

- (void)setLabel:(NSString*)lbl;

@end
