#import <icCanvasAppKit.h>
#import <Cocoa/Cocoa.h>

@interface ICAKDockableColorPanel : NSView

- (NSColor*) selectedColor;
- (void) setSelectedColor:(NSColor*)color;

- (void)setAction:(SEL)action andTarget:(id)target;

@end
