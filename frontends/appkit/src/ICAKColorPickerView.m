#import <icCanvasAppKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AngleGradientLayer.h>

@interface ICAKColorPickerView (Private)

- (NSArray*)gradientColorsForChannel:(ICAKColorPickerViewChannel)chan withCurrentColor:(NSColor*)color isRadialChannel:(BOOL)radialChannel;

@end

@implementation ICAKColorPickerView {
    ICAKColorPickerViewMode mode;
    
    ICAKColorPickerViewChannel linearChannel;
    ICAKColorPickerViewChannel radialChannel;
    
    CAGradientLayer *linearLayer;
    AngleGradientLayer *angleRadialLayer;
    
    NSColor *currentColor;
}

- (id)init {
    self = [super init];
    if (self) {
        self.layer = [[CALayer alloc] init];
        self.layer.layoutManager = [CAConstraintLayoutManager layoutManager];
        
        self->linearLayer = [[CAGradientLayer alloc] init];
        self->linearLayer.type = kCAGradientLayerAxial;
        self->linearLayer.delegate = self;
        
        [self->linearLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintWidth relativeTo:@"superlayer" attribute:kCAConstraintWidth]];
        [self->linearLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintHeight relativeTo:@"superlayer" attribute:kCAConstraintHeight]];
        [self->linearLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintMidX]];
        [self->linearLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY relativeTo:@"superlayer" attribute:kCAConstraintMidY]];
        
        self->angleRadialLayer = [[AngleGradientLayer alloc] init];
        self->angleRadialLayer.delegate = self;
        
        [self->angleRadialLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintWidth relativeTo:@"superlayer" attribute:kCAConstraintWidth]];
        [self->angleRadialLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintHeight relativeTo:@"superlayer" attribute:kCAConstraintHeight]];
        [self->angleRadialLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintMidX]];
        [self->angleRadialLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY relativeTo:@"superlayer" attribute:kCAConstraintMidY]];
        
        self.currentColor = NSColor.blackColor;
        self.mode = ICAKColorPickerViewModeLinear;
        self.linearChannel = ICAKColorPickerViewChannelRed;
        self.radialChannel = ICAKColorPickerViewChannelLightness;
        
        self.wantsLayer = YES;
    }
    
    return self;
};

- (NSArray*)gradientColorsForChannel:(ICAKColorPickerViewChannel)chan withCurrentColor:(NSColor*)color isRadialChannel:(BOOL)isRadialChannel {
    /* TODO: Modify channel colors based on current color */
    NSMutableArray* colorsArray = [[NSMutableArray alloc] init];
    
    switch (chan) {
        case ICAKColorPickerViewChannelHue:
            [colorsArray addObject:(id)NSColor.redColor.CGColor];
            [colorsArray addObject:(id)NSColor.yellowColor.CGColor];
            [colorsArray addObject:(id)NSColor.greenColor.CGColor];
            [colorsArray addObject:(id)NSColor.cyanColor.CGColor];
            [colorsArray addObject:(id)NSColor.blueColor.CGColor];
            [colorsArray addObject:(id)NSColor.purpleColor.CGColor];
            [colorsArray addObject:(id)NSColor.redColor.CGColor];
            break;
        case ICAKColorPickerViewChannelSaturation:
            if (isRadialChannel) {
                [colorsArray addObject:(id)NSColor.clearColor.CGColor];
            } else {
                [colorsArray addObject:(id)color.CGColor];
            }
            
            [colorsArray addObject:(id)NSColor.whiteColor.CGColor];
            break;
        case ICAKColorPickerViewChannelLightness:
            [colorsArray addObject:(id)NSColor.blackColor.CGColor];
            if (isRadialChannel) {
                [colorsArray addObject:(id)NSColor.clearColor.CGColor];
            } else {
                [colorsArray addObject:(id)color.CGColor]; //TODO: Replace with hue
            }
            [colorsArray addObject:(id)NSColor.whiteColor.CGColor];
            break;
            /* TODO: Replace all of these with ones actually based on the color */
        case ICAKColorPickerViewChannelRed:
            [colorsArray addObject:(id)NSColor.blackColor.CGColor];
            [colorsArray addObject:(id)NSColor.redColor.CGColor];
            break;
        case ICAKColorPickerViewChannelGreen:
            [colorsArray addObject:(id)NSColor.blackColor.CGColor];
            [colorsArray addObject:(id)NSColor.greenColor.CGColor];
            break;
        case ICAKColorPickerViewChannelBlue:
            [colorsArray addObject:(id)NSColor.blackColor.CGColor];
            [colorsArray addObject:(id)NSColor.blueColor.CGColor];
            break;
        case ICAKColorPickerViewChannelAlpha:
            [colorsArray addObject:(id)color.CGColor];
            [colorsArray addObject:(id)NSColor.clearColor.CGColor];
            break;
        default:
            break;
    }
    
    return colorsArray;
};

- (ICAKColorPickerViewMode)mode {
    return self->mode;
};

- (void)setMode:(ICAKColorPickerViewMode)newmode {
    if (newmode == ICAKColorPickerViewModeLinear) {
        [self.layer addSublayer:self->angleRadialLayer];
        [self->linearLayer removeFromSuperlayer];
    } else if (newmode == ICAKColorPickerViewModeLinear) {
        [self.layer addSublayer:self->linearLayer];
        [self->angleRadialLayer removeFromSuperlayer];
    }
    
    self->mode = newmode;
};

- (ICAKColorPickerViewChannel)linearChannel {
    return self->linearChannel;
};
- (void)setLinearChannel:(ICAKColorPickerViewChannel)channel {
    NSArray* colors = [self gradientColorsForChannel:channel withCurrentColor:self->currentColor isRadialChannel:NO];
    
    self->linearLayer.colors = colors;
    self->angleRadialLayer.colors = colors;
    
    self->linearChannel = channel;
};

- (ICAKColorPickerViewChannel)radialChannel {
    return self->radialChannel;
};
- (void)setRadialChannel:(ICAKColorPickerViewChannel)channel {
    //TODO: Add radial layer & channel
    self->radialChannel = channel;
};

- (NSColor*)currentColor {
    return self->currentColor;
};
- (void)setCurrentColor:(NSColor*)color {
    self->currentColor = color;
};

- (BOOL)layer:(CALayer *)layer shouldInheritContentsScale:(CGFloat)newScale fromWindow:(NSWindow *)window {
    return YES;
};

@end