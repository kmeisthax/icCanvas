#import <icCanvasAppKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AngleGradientLayer.h>
#import <icCanvasAppKit/ICAKRadialGradientLayer.h>

@interface ICAKColorPickerView (Private)

- (NSArray*)gradientColorsForChannel:(ICAKColorPickerViewChannel)chan withCurrentColor:(NSColor*)color isRadialChannel:(BOOL)radialChannel writeLocations:(NSArray**)outLocations;

- (NSColor*)evaluateGradient:(NSArray*)colors atPoint:(CGFloat)pt;
- (NSColor*)blendColor:(NSColor*)col1 withColor:(NSColor*)col2;

- (void)updateInternalHSLFromColor;
- (void)updateInternalColorFromHSL;

- (void)selectColorAtPoint:(NSPoint)pt;

- (void)fireAction;

- (void)layoutSublayersOfLayer:(CALayer *)layer;

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

    NSLayoutConstraint* shapeConstraint;

    SEL action;
    id target;
}

- (id)init {
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *pressureConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:1.0];
        
        pressureConstraint.active = YES;

        pressureConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:1.0];

        pressureConstraint.active = YES;
        
        self.layer = [CALayer layer];
        self.layer.borderColor = NSColor.blackColor.CGColor;
        self.layer.borderWidth = 1.0f; //TODO: Adjust border width based on screen pixel density
        self.layer.delegate = self;
        
        self->angleRadialLayer = [AngleGradientLayer layer];
        self->angleRadialLayer.name = @"angleRadialLayer";
        self->angleRadialLayer.contentsGravity = kCAGravityResize;
        [self.layer addSublayer:self->angleRadialLayer];

        self->radialLayer = [ICAKRadialGradientLayer layer];
        self->radialLayer.name = @"radialLayer";
        self->radialLayer.contentsGravity = kCAGravityResize;
        [self.layer addSublayer:self->radialLayer];
        
        self->linearLayer = [CAGradientLayer layer];
        self->linearLayer.name = @"linearLayer";
        //self->linearLayer.type = kCAGradientLayerAxial;
        self->linearLayer.contentsGravity = kCAGravityResize;
        [self.layer addSublayer:self->linearLayer];

        self.currentColor = [NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.0 alpha:1.0];
        self.mode = ICAKColorPickerViewModeLinearVertical;
        self.linearChannel = ICAKColorPickerViewChannelRed;
        self.radialChannel = ICAKColorPickerViewChannelLightness;
        
        self.wantsLayer = YES;
    }
    
    return self;
};

- (void)layoutSublayersOfLayer:(CALayer *)layer {
    self->linearLayer.frame = layer.bounds;
    self->angleRadialLayer.frame = layer.bounds;
    self->radialLayer.frame = layer.bounds;
};

- (void)setFrame:(NSRect)rect {
    [super setFrame:rect];
    
    if (mode == ICAKColorPickerViewModeCircular) {
        self.layer.cornerRadius = self.layer.bounds.size.width / 2.0f;
        self->linearLayer.cornerRadius = self.layer.bounds.size.width / 2.0f;
        self->linearLayer.masksToBounds = YES;
        self->angleRadialLayer.cornerRadius = self.layer.bounds.size.width / 2.0f;
        self->angleRadialLayer.masksToBounds = YES;
        self->radialLayer.cornerRadius = self.layer.bounds.size.width / 2.0f;
        self->radialLayer.masksToBounds = YES;
    } else {
        self.layer.cornerRadius = 0.0f;
        self->linearLayer.cornerRadius = 0.0f;
        self->linearLayer.masksToBounds = NO;
        self->angleRadialLayer.cornerRadius = 0.0f;
        self->angleRadialLayer.masksToBounds = NO;
        self->radialLayer.cornerRadius = 0.0f;
        self->radialLayer.masksToBounds = NO;
    }

    self.layer.frame = self.frame;
    NSLog(@"Picker Frame: %fx%f@%fx%f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
};

- (NSArray*)gradientColorsForChannel:(ICAKColorPickerViewChannel)chan withCurrentColor:(NSColor*)color isRadialChannel:(BOOL)isRadialChannel writeLocations:(NSArray**)outLocations {
    /* TODO: Modify channel colors based on current color */
    NSMutableArray* colorsArray = [[NSMutableArray alloc] init];
    
    switch (chan) {
        case ICAKColorPickerViewChannelHue: {
            CGFloat lightScale = self->colorLightness > 0.5f ? 1.0f : self->colorLightness * 2;
            CGFloat overLightScale = self->colorLightness < 0.5f ? 0.0f : self->colorLightness * 2 - 1.0f;

            [colorsArray addObject:(id)[NSColor colorWithDeviceRed:lightScale green:overLightScale blue:overLightScale alpha:1.0].CGColor];
            [colorsArray addObject:(id)[NSColor colorWithDeviceRed:lightScale green:lightScale blue:overLightScale alpha:1.0].CGColor];
            [colorsArray addObject:(id)[NSColor colorWithDeviceRed:overLightScale green:lightScale blue:overLightScale alpha:1.0].CGColor];
            [colorsArray addObject:(id)[NSColor colorWithDeviceRed:overLightScale green:lightScale blue:lightScale alpha:1.0].CGColor];
            [colorsArray addObject:(id)[NSColor colorWithDeviceRed:overLightScale green:overLightScale blue:lightScale alpha:1.0].CGColor];
            [colorsArray addObject:(id)[NSColor colorWithDeviceRed:lightScale green:overLightScale blue:lightScale alpha:1.0].CGColor];
            [colorsArray addObject:(id)[NSColor colorWithDeviceRed:lightScale green:overLightScale blue:overLightScale alpha:1.0].CGColor];

            if (outLocations) {
                *outLocations = [NSArray arrayWithObjects:
                                    [NSNumber numberWithFloat:0.0f/6.0f],
                                    [NSNumber numberWithFloat:1.0f/6.0f],
                                    [NSNumber numberWithFloat:2.0f/6.0f],
                                    [NSNumber numberWithFloat:3.0f/6.0f],
                                    [NSNumber numberWithFloat:4.0f/6.0f],
                                    [NSNumber numberWithFloat:5.0f/6.0f],
                                    [NSNumber numberWithFloat:6.0f/6.0f], nil];
            }
        }
            break;
        case ICAKColorPickerViewChannelSaturation:
            [colorsArray addObject:(id)[NSColor colorWithDeviceRed:self->colorLightness green:self->colorLightness blue:self->colorLightness alpha:1.0].CGColor];
            if (isRadialChannel) {
                [colorsArray addObject:(id)[NSColor colorWithDeviceRed:self->colorLightness green:self->colorLightness blue:self->colorLightness alpha:0.0].CGColor];
            } else {
                [colorsArray addObject:(id)color.CGColor];
            }

            if (outLocations) {
                *outLocations = [NSArray arrayWithObjects:
                                    [NSNumber numberWithFloat:0.0f/1.0f],
                                    [NSNumber numberWithFloat:1.0f/1.0f], nil];
            }
            break;
        case ICAKColorPickerViewChannelLightness:
            [colorsArray addObject:(id)[NSColor colorWithDeviceRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor];
            if (isRadialChannel) {
                [colorsArray addObject:(id)[NSColor colorWithDeviceRed:0.5 green:0.5 blue:0.5 alpha:0.0].CGColor];
            } else {
                [colorsArray addObject:(id)color.CGColor]; //TODO: Replace with hue
            }
            [colorsArray addObject:(id)[NSColor colorWithDeviceRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor];

            if (outLocations) {
                *outLocations = [NSArray arrayWithObjects:
                                    [NSNumber numberWithFloat:0.0f/2.0f],
                                    [NSNumber numberWithFloat:1.0f/2.0f],
                                    [NSNumber numberWithFloat:2.0f/2.0f], nil];
            }
            break;
        case ICAKColorPickerViewChannelRed:
            [colorsArray addObject:(id)[NSColor colorWithDeviceRed:0.0 green:self->colorGreen blue:self->colorBlue alpha:1.0].CGColor];
            [colorsArray addObject:(id)[NSColor colorWithDeviceRed:1.0 green:self->colorGreen blue:self->colorBlue alpha:1.0].CGColor];

            if (outLocations) {
                *outLocations = [NSArray arrayWithObjects:
                                    [NSNumber numberWithFloat:0.0f/1.0f],
                                    [NSNumber numberWithFloat:1.0f/1.0f], nil];
            }
            break;
        case ICAKColorPickerViewChannelGreen:
            [colorsArray addObject:(id)[NSColor colorWithDeviceRed:self->colorRed green:0.0 blue:self->colorBlue alpha:1.0].CGColor];
            [colorsArray addObject:(id)[NSColor colorWithDeviceRed:self->colorRed green:1.0 blue:self->colorBlue alpha:1.0].CGColor];

            if (outLocations) {
                *outLocations = [NSArray arrayWithObjects:
                                    [NSNumber numberWithFloat:0.0f/1.0f],
                                    [NSNumber numberWithFloat:1.0f/1.0f], nil];
            }
            break;
        case ICAKColorPickerViewChannelBlue:
            [colorsArray addObject:(id)[NSColor colorWithDeviceRed:self->colorRed green:self->colorGreen blue:0.0 alpha:1.0].CGColor];
            [colorsArray addObject:(id)[NSColor colorWithDeviceRed:self->colorRed green:self->colorGreen blue:1.0 alpha:1.0].CGColor];

            if (outLocations) {
                *outLocations = [NSArray arrayWithObjects:
                                    [NSNumber numberWithFloat:0.0f/1.0f],
                                    [NSNumber numberWithFloat:1.0f/1.0f], nil];
            }
            break;
        case ICAKColorPickerViewChannelAlpha:
            [colorsArray addObject:(id)[NSColor colorWithDeviceRed:self->colorRed green:self->colorGreen blue:self->colorBlue alpha:0.0].CGColor];
            [colorsArray addObject:(id)color.CGColor];

            if (outLocations) {
                *outLocations = [NSArray arrayWithObjects:
                                    [NSNumber numberWithFloat:0.0f/1.0f],
                                    [NSNumber numberWithFloat:1.0f/1.0f], nil];
            }
            break;
        default:
            NSLog(@"john freeman looked at road sign and saw ravenholm with someons writing under it saying u sudnt come here");
            break;
    }
    
    return colorsArray;
};

- (ICAKColorPickerViewMode)mode {
    return self->mode;
};

- (void)setMode:(ICAKColorPickerViewMode)newmode {
    if (self->shapeConstraint != nil) {
        self->shapeConstraint.active = NO;
    }

    if (newmode == ICAKColorPickerViewModeCircular) {
        self->linearLayer.opacity = 0.0f;
        self->angleRadialLayer.opacity = 1.0f;
        self->radialLayer.opacity = 1.0f;

        self->shapeConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0];
        self->shapeConstraint.priority = NSLayoutPriorityDefaultHigh;
        self->shapeConstraint.active = YES;
    } else if (newmode == ICAKColorPickerViewModeLinearHorizontal) {
        self->linearLayer.opacity = 1.0f;
        self->angleRadialLayer.opacity = 0.0f;
        self->radialLayer.opacity = 0.0f;

        NSPoint start = {0.0, 0.5}, end = {1.0, 0.5};

        self->linearLayer.startPoint = start;
        self->linearLayer.endPoint = end;

        self->shapeConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:ICAKColorPickerViewLinearCrossLength];
        self->shapeConstraint.priority = NSLayoutPriorityDefaultHigh;
        self->shapeConstraint.active = YES;
    } else if (newmode == ICAKColorPickerViewModeLinearVertical) {
        self->linearLayer.opacity = 1.0f;
        self->angleRadialLayer.opacity = 0.0f;
        self->radialLayer.opacity = 0.0f;

        NSPoint start = {0.5, 1.0}, end = {0.5, 0.0};

        self->linearLayer.startPoint = start;
        self->linearLayer.endPoint = end;

        self->shapeConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:ICAKColorPickerViewLinearCrossLength];
        self->shapeConstraint.priority = NSLayoutPriorityDefaultHigh;
        self->shapeConstraint.active = YES;
    }
    
    self->mode = newmode;
};

- (ICAKColorPickerViewChannel)linearChannel {
    return self->linearChannel;
};
- (void)setLinearChannel:(ICAKColorPickerViewChannel)channel {
    NSArray* locations = nil;

    NSArray* colors = [self gradientColorsForChannel:channel withCurrentColor:self->currentColor isRadialChannel:NO writeLocations:&locations];
    
    self->linearLayer.colors = colors;
    self->linearLayer.locations = locations;

    locations = nil;
    NSArray* colors2 = [self gradientColorsForChannel:channel withCurrentColor:self->currentColor isRadialChannel:NO writeLocations:&locations];

    self->angleRadialLayer.colors = colors2;
    self->angleRadialLayer.locations = locations;

    self->linearChannel = channel;
};

- (ICAKColorPickerViewChannel)radialChannel {
    return self->radialChannel;
};
- (void)setRadialChannel:(ICAKColorPickerViewChannel)channel {
    NSArray* locations = nil;

    NSArray* colors = [self gradientColorsForChannel:channel withCurrentColor:self->currentColor isRadialChannel:YES writeLocations:&locations];

    self->radialLayer.colors = colors;
    self->radialLayer.locations = locations;
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

    [self updateInternalHSLFromColor];

    self.linearChannel = self.linearChannel;
    self.radialChannel = self.radialChannel;
};

- (BOOL)layer:(CALayer *)layer shouldInheritContentsScale:(CGFloat)newScale fromWindow:(NSWindow *)window {
    return YES;
};

- (NSColor*)evaluateGradient:(NSArray*)colors atPoint:(CGFloat)pt {
    if (colors.count == 0) return NSColor.blackColor;

    NSInteger ptfloor = fmax(0, floor(pt * (colors.count - 1))),
              ptceil = fmin(colors.count - 1, ceil(pt * (colors.count - 1)));
    CGFloat ptfrac = pt * (colors.count - 1) - ptfloor;
    CGColorRef minColor = (__bridge CGColorRef)[colors objectAtIndex:ptfloor],
               maxColor = (__bridge CGColorRef)[colors objectAtIndex:ptceil];

    NSLog(@"PT:%f frac:%f", pt, ptfrac);

    //Get the new color by evaluating the channel's own color gradient.
    CGFloat minred, mingreen, minblue, minalpha,
            maxred, maxgreen, maxblue, maxalpha;

    const CGFloat *minComponents = CGColorGetComponents(minColor),
                  *maxComponents = CGColorGetComponents(maxColor);

    size_t minCompCount = CGColorGetNumberOfComponents(minColor),
           maxCompCount = CGColorGetNumberOfComponents(maxColor);

    if (minCompCount < 4) {
        minalpha = minComponents[1];
        minred = minComponents[0];
        mingreen = minComponents[0];
        minblue = minComponents[0];
    } else {
        minalpha = minComponents[3];
        minred = minComponents[0];
        mingreen = minComponents[1];
        minblue = minComponents[2];
    }
    if (maxCompCount < 4) {
        maxalpha = maxComponents[1];
        maxred = maxComponents[0];
        maxgreen = maxComponents[0];
        maxblue = maxComponents[0];
    } else {
        maxalpha = maxComponents[3];
        maxred = maxComponents[0];
        maxgreen = maxComponents[1];
        maxblue = maxComponents[2];
    }

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
        linearPosition = sqrt(pow(fabs(pt.x - centerPos.x), 2.0f) + pow(fabs(pt.y - centerPos.y), 2.0f)) / centerPos.x;
        radialPosition = (atan2((pt.x - centerPos.x), (pt.y - centerPos.y)) + M_PI) / M_TAU;
        radialPosition = fmod((radialPosition + 0.25f), 1.0f);
    }

    if (isnan(linearPosition)) linearPosition = 0;

    NSLog(@"selectPt: %fx%f", linearPosition, radialPosition);

    //Get the new color by evaluating the channel's own color gradient.
    if (self->mode == ICAKColorPickerViewModeCircular) {
        //Mix in the radial channel color.
        NSColor* linearColor = [self evaluateGradient:self->radialLayer.colors atPoint:linearPosition];
        NSColor* radialColor = [self evaluateGradient:self->angleRadialLayer.colors atPoint:radialPosition];

        NSColor* blentColor = [self blendColor:linearColor withColor:radialColor];
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
