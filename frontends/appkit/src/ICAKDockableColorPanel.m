#import <icCanvasAppKit.h>

@interface ICAKDockableColorPanel (Private)

- (void)colorPicker:(ICAKColorPickerView*)picker didCaptureColor:(NSColor*)color;

@end

@implementation ICAKDockableColorPanel {
    NSColor* selectedColor;

    ICAKColorPickerView *radialPicker, *linearLightnessPicker,
        *linearRedPicker, *linearGreenPicker, *linearBluePicker, *linearAlphaPicker;
}

- (id)init {
    self = [super init];

    if (self != nil) {
        self.translatesAutoresizingMaskIntoConstraints = NO;

        //Create all our view objects...
        self->radialPicker = [[ICAKColorPickerView alloc] init];
        [self addSubview:self->radialPicker];
        self->radialPicker.mode = ICAKColorPickerViewModeCircular;
        self->radialPicker.linearChannel = ICAKColorPickerViewChannelHue;
        self->radialPicker.radialChannel = ICAKColorPickerViewChannelSaturation;
        [self->radialPicker setAction:@selector(colorPicker:didCaptureColor:) andTarget:self];

        self->linearLightnessPicker = [[ICAKColorPickerView alloc] init];
        [self addSubview:self->linearLightnessPicker];
        self->linearLightnessPicker.mode = ICAKColorPickerViewModeLinearVertical;
        self->linearLightnessPicker.linearChannel = ICAKColorPickerViewChannelLightness;
        self->linearLightnessPicker.radialChannel = ICAKColorPickerViewChannelSaturation;
        [self->linearLightnessPicker setAction:@selector(colorPicker:didCaptureColor:) andTarget:self];

        self->linearRedPicker = [[ICAKColorPickerView alloc] init];
        [self addSubview:self->linearRedPicker];
        self->linearRedPicker.mode = ICAKColorPickerViewModeLinearHorizontal;
        self->linearRedPicker.linearChannel = ICAKColorPickerViewChannelRed;
        [self->linearRedPicker setAction:@selector(colorPicker:didCaptureColor:) andTarget:self];

        self->linearGreenPicker = [[ICAKColorPickerView alloc] init];
        [self addSubview:self->linearGreenPicker];
        self->linearGreenPicker.mode = ICAKColorPickerViewModeLinearHorizontal;
        self->linearGreenPicker.linearChannel = ICAKColorPickerViewChannelGreen;
        [self->linearGreenPicker setAction:@selector(colorPicker:didCaptureColor:) andTarget:self];

        self->linearBluePicker = [[ICAKColorPickerView alloc] init];
        [self addSubview:self->linearBluePicker];
        self->linearBluePicker.mode = ICAKColorPickerViewModeLinearHorizontal;
        self->linearBluePicker.linearChannel = ICAKColorPickerViewChannelBlue;
        [self->linearBluePicker setAction:@selector(colorPicker:didCaptureColor:) andTarget:self];

        self->linearAlphaPicker = [[ICAKColorPickerView alloc] init];
        [self addSubview:self->linearAlphaPicker];
        self->linearAlphaPicker.mode = ICAKColorPickerViewModeLinearHorizontal;
        self->linearAlphaPicker.linearChannel = ICAKColorPickerViewChannelAlpha;
        [self->linearAlphaPicker setAction:@selector(colorPicker:didCaptureColor:) andTarget:self];

        //..then create a crapton of constraints. FIRST THE TOP EDGES!
        [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self->radialPicker attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f].active = YES;
        [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self->linearLightnessPicker attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f].active = YES;

        //NEXT THE LEFT EDGES!
        [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self->radialPicker attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f].active = YES;
        [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self->linearRedPicker attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f].active = YES;
        [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self->linearGreenPicker attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f].active = YES;
        [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self->linearBluePicker attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f].active = YES;
        [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self->linearAlphaPicker attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f].active = YES;

        //THEN THE RIGHT EDGES!
        [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self->linearLightnessPicker attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f].active = YES;
        [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self->linearRedPicker attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f].active = YES;
        [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self->linearGreenPicker attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f].active = YES;
        [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self->linearBluePicker attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f].active = YES;
        [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self->linearAlphaPicker attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f].active = YES;

        //AND THE BOTTOM EDGES!
        [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self->linearAlphaPicker attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f].active = YES;

        //LAST, THE INTERIOR MARGINS!
        [NSLayoutConstraint constraintWithItem:self->radialPicker attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self->linearLightnessPicker attribute:NSLayoutAttributeLeft multiplier:1.0f constant:ICAKDockableColorPanelInteriorMargin * -1.0f].active = YES;
        [NSLayoutConstraint constraintWithItem:self->radialPicker attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self->linearRedPicker attribute:NSLayoutAttributeTop multiplier:1.0f constant:ICAKDockableColorPanelInteriorMargin * -1.0f].active = YES;
        [NSLayoutConstraint constraintWithItem:self->linearLightnessPicker attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self->linearRedPicker attribute:NSLayoutAttributeTop multiplier:1.0f constant:ICAKDockableColorPanelInteriorMargin * -1.0f].active = YES;
        [NSLayoutConstraint constraintWithItem:self->linearRedPicker attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self->linearGreenPicker attribute:NSLayoutAttributeTop multiplier:1.0f constant:ICAKDockableColorPanelInteriorMargin * -1.0f].active = YES;
        [NSLayoutConstraint constraintWithItem:self->linearGreenPicker attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self->linearBluePicker attribute:NSLayoutAttributeTop multiplier:1.0f constant:ICAKDockableColorPanelInteriorMargin * -1.0f].active = YES;
        [NSLayoutConstraint constraintWithItem:self->linearBluePicker attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self->linearAlphaPicker attribute:NSLayoutAttributeTop multiplier:1.0f constant:ICAKDockableColorPanelInteriorMargin * -1.0f].active = YES;
    }
    
    return self;
}

- (NSColor*) selectedColor {
    return self->selectedColor;
};

- (void) setSelectedColor:(NSColor*)color {
    self->selectedColor = color;
};

@end
