#import <icCanvasAppKit.h>

@interface ICAKColorPickerView : NSView

- (id)init;

- (ICAKColorPickerViewMode)mode;
- (void)setMode:(ICAKColorPickerViewMode)mode;

- (ICAKColorPickerViewChannel)linearChannel;
- (void)setLinearChannel:(ICAKColorPickerViewChannel)channel;
- (ICAKColorPickerViewChannel)radialChannel;
- (void)setRadialChannel:(ICAKColorPickerViewChannel)channel;

- (NSColor*)currentColor;
- (void)setCurrentColor:(NSColor*)color;

@end
