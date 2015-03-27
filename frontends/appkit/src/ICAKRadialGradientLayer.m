#import <icCanvasAppKit/ICAKRadialGradientLayer.h>
#import <Cocoa/Cocoa.h>

@interface ICAKRadialGradientLayer (Private)

- (CGImageRef)newImageGradientInRect:(CGRect)rect;

@end

@implementation ICAKRadialGradientLayer

- (id)init {
	if (!(self = [super init]))
		return nil;

	self.needsDisplayOnBoundsChange = YES;

	return self;
}

- (void)drawInContext:(CGContextRef)ctx {
    size_t gradLocationsNum = self.colors.count;
    CGFloat *gradLocations = malloc(gradLocationsNum);
    CGFloat *gradColors = malloc(gradLocationsNum * 4);
    NSInteger colNum = 0;

    for (NSColor* col in self.colors) {
        //TODO: Actually copy colors into bare-memory array
        if (gradLocationsNum > 1) {
            gradLocations[colNum] = 1.0f / (gradLocationsNum - 1) * colNum;
        } else {
            gradLocations[colNum] = 0.0f;
        }

        [col getRed:&gradColors[colNum * 4 + 0]
              green:&gradColors[colNum * 4 + 1]
               blue:&gradColors[colNum * 4 + 2]
              alpha:&gradColors[colNum * 4 + 3]];

        colNum++;
    }

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
    CGColorSpaceRelease(colorSpace);

    CGPoint gradCenter= CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height);

    CGContextDrawRadialGradient(ctx, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsBeforeStartLocation);

    CGGradientRelease(gradient);
    free(gradColors);
    free(gradLocations);
}

@end
