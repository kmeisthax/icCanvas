#import <icCanvasAppKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AngleGradientLayer.h>
#import <icCanvasAppKit/ICAKRadialGradientLayer.h>

@interface ICAKColorPickerView (Private)

- (NSArray*)gradientColorsForChannel:(ICAKColorPickerViewChannel)chan withCurrentColor:(NSColor*)color isRadialChannel:(BOOL)radialChannel;

- (NSColor*)evaluateGradient:(NSArray*)colors atPoint:(CGFloat)pt;
- (NSColor*)blendColor:(NSColor*)col1 withColor:(NSColor*)col2;

- (void)updateInternalHSLFromColor;
- (void)updateInternalColorFromHSL;

- (void)selectColorAtPoint:(NSPoint)pt;

- (void)fireAction;

@end

@implementation ICAKColorPickerView {
    ICAKColorPickerViewMode mode;
    
    ICAKColorPickerViewChannel linearChannel;
    ICAKColorPickerViewChannel radialChannel;
    
    CAGradientLayer *linearLayer;
    AngleGradientLayer *angleRadialLayer;
    ICAKRadialGradientLayer *radialLayer;
    
    NSColor *currentColor;
    CGFloat colorAlpha, colorHue, colorSaturation, colorLightness, colorRed, colorBlue, colorGreen;

    SEL action;
    id target;
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
        [self.layer addSublayer:self->linearLayer];
        
        self->angleRadialLayer = [[AngleGradientLayer alloc] init];
        self->angleRadialLayer.delegate = self;
        
        [self->angleRadialLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintWidth relativeTo:@"superlayer" attribute:kCAConstraintWidth]];
        [self->angleRadialLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintHeight relativeTo:@"superlayer" attribute:kCAConstraintHeight]];
        [self->angleRadialLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintMidX]];
        [self->angleRadialLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY relativeTo:@"superlayer" attribute:kCAConstraintMidY]];
        [self.layer addSublayer:self->angleRadialLayer];

        self->radialLayer = [[ICAKRadialGradientLayer alloc] init];
        self->radialLayer.delegate = self;

        [self->radialLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintWidth relativeTo:@"superlayer" attribute:kCAConstraintWidth]];
        [self->radialLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintHeight relativeTo:@"superlayer" attribute:kCAConstraintHeight]];
        [self->radialLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX relativeTo:@"superlayer" attribute:kCAConstraintMidX]];
        [self->radialLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY relativeTo:@"superlayer" attribute:kCAConstraintMidY]];
        [self.layer addSublayer:self->radialLayer];
        
        self.currentColor = NSColor.blackColor;
        self.mode = ICAKColorPickerViewModeLinearVertical;
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
    if (newmode == ICAKColorPickerViewModeCircular) {
        self->linearLayer.opacity = 0.0f;
        self->angleRadialLayer.opacity = 1.0f;
        self->radialLayer.opacity = 1.0f;
    } else if (newmode == ICAKColorPickerViewModeLinearHorizontal) {
        self->linearLayer.opacity = 1.0f;
        self->angleRadialLayer.opacity = 0.0f;
        self->radialLayer.opacity = 0.0f;

        NSPoint start = {0.0, 0.5}, end = {1.0, 0.5};

        self->linearLayer.startPoint = start;
        self->linearLayer.endPoint = end;
    } else if (newmode == ICAKColorPickerViewModeLinearVertical) {
        self->linearLayer.opacity = 1.0f;
        self->angleRadialLayer.opacity = 0.0f;
        self->radialLayer.opacity = 0.0f;

        NSPoint start = {0.5, 0.0}, end = {0.5, 1.0};

        self->linearLayer.startPoint = start;
        self->linearLayer.endPoint = end;
    }
    
    self->mode = newmode;
};

- (ICAKColorPickerViewChannel)linearChannel {
    return self->linearChannel;
};
- (void)setLinearChannel:(ICAKColorPickerViewChannel)channel {
    NSArray* colors = [self gradientColorsForChannel:channel withCurrentColor:self->currentColor isRadialChannel:NO];
    
    self->linearLayer.colors = colors;
    self->radialLayer.colors = colors;
    self->linearChannel = channel;
};

- (ICAKColorPickerViewChannel)radialChannel {
    return self->radialChannel;
};
- (void)setRadialChannel:(ICAKColorPickerViewChannel)channel {
    NSArray* colors = [self gradientColorsForChannel:channel withCurrentColor:self->currentColor isRadialChannel:YES];

    self->angleRadialLayer.colors = colors;
    self->radialChannel = channel;
};

- (void)updateInternalHSLFromColor {
    CGFloat minComponent, maxComponent, chroma;
    [self->currentColor getRed:&self->colorRed green:&self->colorGreen blue:&self->colorBlue alpha:&self->colorAlpha];

    minComponent = fmin(self->colorRed, fmin(self->colorGreen, self->colorBlue));
    maxComponent = fmax(self->colorRed, fmax(self->colorGreen, self->colorBlue));
    chroma = maxComponent - minComponent;

    if (self->colorRed > self->colorGreen && self->colorRed > self->colorBlue) {
        self->colorHue = (self->colorGreen - self->colorBlue) / chroma;
    } else if (self->colorGreen > self->colorRed && self->colorGreen > self->colorBlue) {
        self->colorHue = (self->colorBlue - self->colorRed) / chroma + 2;
    } else if (self->colorBlue > self->colorRed && self->colorBlue > self->colorGreen) {
        self->colorHue = (self->colorRed - self->colorGreen) / chroma + 4;
    } else {
        self->colorHue = 0;
    }

    //Conform hue to a [0.0, 1.0) range representing an angle
    self->colorHue = self->colorHue / 6.0f;
    self->colorHue = fmod(self->colorHue, 1.0f);

    self->colorLightness = (minComponent + maxComponent) / 2;

    if (self->colorLightness == 0 || self->colorLightness == 1.0f) {
        self->colorSaturation = 0;
    } else {
        self->colorSaturation = chroma / (1 - fabs(2.0f * self->colorLightness - 1));
    }
};

//TODO: Do we even need this?
- (void)updateInternalColorFromHSL {
    if (self->colorSaturation == 0.0f) {
        self->colorRed = self->colorLightness;
        self->colorGreen = self->colorLightness;
        self->colorBlue = self->colorLightness;
    } else {
        CGFloat t1, t2, tR, tG, tB;

        if (self->colorLightness >= 0.5f) {
            t1 = self->colorLightness + self->colorSaturation - self->colorLightness * self->colorSaturation;
        } else {
            t1 = self->colorLightness * (1.0f + self->colorSaturation);
        }

        t2 = 2.0 * self->colorLightness - t1;

        tR = fmod(self->colorHue + (1.0f/3.0f), 1.0f);
        tG = fmod(self->colorHue, 1.0f);
        tB = fmod(self->colorHue - (1.0f/3.0f), 1.0f);

        if (tR * 6.0f < 1.0f) {
            self->colorRed = t2 + (t1 - t2) * 6 * tR;
        } else if (tR * 2.0f < 1.0f) {
            self->colorRed = t1;
        } else if (tR * 3.0f < 2.0f) {
            self->colorRed = t2 + (t1 - t2) * 6 * (2.0f/3.0f - tR);
        } else {
            self->colorRed = t2;
        }

        if (tG * 6.0f < 1.0f) {
            self->colorGreen = t2 + (t1 - t2) * 6 * tG;
        } else if (tG * 2.0f < 1.0f) {
            self->colorGreen = t1;
        } else if (tG * 3.0f < 2.0f) {
            self->colorGreen = t2 + (t1 - t2) * 6 * (2.0f/3.0f - tG);
        } else {
            self->colorGreen = t2;
        }

        if (tB * 6.0f < 1.0f) {
            self->colorBlue = t2 + (t1 - t2) * 6 * tB;
        } else if (tB * 2.0f < 1.0f) {
            self->colorBlue = t1;
        } else if (tB * 3.0f < 2.0f) {
            self->colorBlue = t2 + (t1 - t2) * 6 * (2.0f/3.0f - tB);
        } else {
            self->colorBlue = t2;
        }
    }

    self.currentColor = [NSColor colorWithCalibratedRed:self->colorRed green:self->colorGreen blue:self->colorBlue alpha:self->colorAlpha];
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

- (NSColor*)evaluateGradient:(NSArray*)colors atPoint:(CGFloat)pt {
    NSInteger ptfloor = floor(pt * (colors.count - 1)),
              ptceil = ceil(pt * (colors.count - 1));
    CGFloat ptfrac = ptfloor - (pt * (colors.count - 1));
    NSColor* minColor = [colors objectAtIndex:ptfloor],
           * maxColor = [colors objectAtIndex:ptceil];

    //Get the new color by evaluating the channel's own color gradient.
    CGFloat minred, mingreen, minblue, minalpha,
            maxred, maxgreen, maxblue, maxalpha;
    [minColor getRed:&minred green:&mingreen blue:&minblue alpha:&minalpha];
    [maxColor getRed:&maxred green:&maxgreen blue:&maxblue alpha:&maxalpha];

    CGFloat sumRed = (maxred - minred) * ptfrac + minred,
            sumGreen = (maxgreen - mingreen) * ptfrac + mingreen,
            sumBlue = (maxblue - minblue) * ptfrac + minblue,
            sumAlpha = (maxalpha - minalpha) * ptfrac + minalpha;

    return [NSColor colorWithRed:sumRed green:sumGreen blue:sumBlue alpha:sumAlpha];
};

- (NSColor*)blendColor:(NSColor*)color1 withColor:(NSColor*)color2 {
    CGFloat c1r, c1g, c1b, c1a, c2r, c2g, c2b, c2a;

    [color1 getRed:&c1r green:&c1g blue:&c1b alpha:&c1a];
    [color2 getRed:&c2r green:&c2g blue:&c2b alpha:&c2a];

    //TODO: Premul alpha?
    CGFloat mixr, mixg, mixb, mixa;

    mixr = c1r * c1a + c2r * c2a * (1 - c1a);
    mixg = c1g * c1a + c2g * c2a * (1 - c1a);
    mixb = c1b * c1a + c2b * c2a * (1 - c1a);
    mixa = c1a + c2a * (1 - c1a);

    return [NSColor colorWithRed:mixr green:mixg blue:mixb alpha:mixa];
};

- (void)selectColorAtPoint:(NSPoint)pt {
    CGFloat linearPosition, radialPosition = -1.0f;

    if (self->mode == ICAKColorPickerViewModeLinearHorizontal) {
        linearPosition = pt.x / self.bounds.size.width;
    } else if (self->mode == ICAKColorPickerViewModeLinearVertical) {
        linearPosition = (self.bounds.size.height - pt.y) / self.bounds.size.height;
    } else if (self->mode == ICAKColorPickerViewModeCircular) {
        NSPoint centerPos = {self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f};
        linearPosition = sqrt((pt.x - centerPos.x) * 2.0f + (pt.y - centerPos.y) * 2.0f) / centerPos.x;
        radialPosition = (atan2((pt.y - centerPos.y), (pt.x - centerPos.x)) + M_PI) / M_TAU;
    }

    //Get the new color by evaluating the channel's own color gradient.
    if (self->mode == ICAKColorPickerViewModeCircular) {
        //Mix in the radial channel color.
        NSColor* linearColor = [self evaluateGradient:self->radialLayer.colors atPoint:linearPosition];
        NSColor* radialColor = [self evaluateGradient:self->angleRadialLayer.colors atPoint:radialPosition];

        NSColor* blentColor = [self blendColor:radialColor withColor:linearColor];
        self->currentColor = blentColor;
    } else {
        NSColor* linearColor = [self evaluateGradient:self->linearLayer.colors atPoint:linearPosition];
        self->currentColor = linearColor;
    }

    [self updateInternalHSLFromColor];          //Update our HSL
    self.linearChannel = self.linearChannel;    //Force-update the channel gradients
    self.radialChannel = self.radialChannel;
    [self wasAssignedColor];                    //Trigger the color selection action
};

- (void)mouseDown:(NSEvent*)theEvent {
    NSPoint event_location = [theEvent locationInWindow];
    NSPoint local_point = [self convertPoint:event_location fromView:nil];

    [self selectColorAtPoint:local_point];
};

- (void)mouseDragged:(NSEvent*)theEvent {
    NSPoint event_location = [theEvent locationInWindow];
    NSPoint local_point = [self convertPoint:event_location fromView:nil];

    [self selectColorAtPoint:local_point];
};

- (void)mouseUp:(NSEvent*)theEvent {
    NSPoint event_location = [theEvent locationInWindow];
    NSPoint local_point = [self convertPoint:event_location fromView:nil];

    [self selectColorAtPoint:local_point];
};

- (void)setAction:(SEL)newaction andTarget:(id)newtarget {
    self->action = newaction;
    self->target = newtarget;
};

- (void)wasAssignedColor {
    if (self->action != nil && self->target != nil) {
        NSInvocation* inv = [NSInvocation invocationWithMethodSignature:[self->target methodSignatureForSelector:self->action]];
        inv.selector = self->action;

        NSInteger argCount = inv.methodSignature.numberOfArguments;

        //Effective method signature:
        // -(void)colorPickerView:(ICAKColorPickerView*)view wasAssignedColor:(NSColor*)col;
        if (argCount > 2) { //one argument, counting the hidden IMP arguments
            __unsafe_unretained id unsafe_self = self;
            [inv setArgument:&unsafe_self atIndex:2];
        }

        if (argCount > 3) { //two arguments, counting the hidden IMP arguments
            [inv setArgument:&self->currentColor atIndex:3];
        }

        [inv invokeWithTarget:self->target];
    } else {
        NSLog(@"Color Picker with no action target was assigned a color by the user!");
    }
};

@end
