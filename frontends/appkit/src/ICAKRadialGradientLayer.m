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
    CGFloat *gradLocations = malloc(sizeof(CGFloat) * gradLocationsNum);
    CGFloat *gradColors = malloc(sizeof(CGFloat) * gradLocationsNum * 4);
    NSInteger colNum = 0;

    for (id col in self.colors) {
        struct CGColor* cCol = (__bridge struct CGColor*)col;

        size_t n = CGColorGetNumberOfComponents(cCol);
        const CGFloat *comps = CGColorGetComponents(cCol);
        if (comps == NULL) {
            gradColors[colNum * 4 + 0] = 0.0f;
            gradColors[colNum * 4 + 1] = 0.0f;
            gradColors[colNum * 4 + 2] = 0.0f;
            gradColors[colNum * 4 + 3] = 0.0f;
            continue;
        }

        if (n >= 4) {
            gradColors[colNum * 4 + 0] = comps[0];
            gradColors[colNum * 4 + 1] = comps[1];
            gradColors[colNum * 4 + 2] = comps[2];
            gradColors[colNum * 4 + 3] = comps[3];
        } else { //Assuming grayscale colorspace.
            gradColors[colNum * 4 + 0] = comps[0];
            gradColors[colNum * 4 + 1] = comps[0];
            gradColors[colNum * 4 + 2] = comps[0];
            gradColors[colNum * 4 + 3] = comps[1];
        }

        if (self.locations == nil) {
            if (gradLocationsNum > 1) {
                gradLocations[colNum] = 1.0f / (gradLocationsNum - 1) * colNum;
            } else {
                gradLocations[colNum] = 0.0f;
            }
        }

        colNum++;
    }

    if (self.locations != nil) {
        colNum = 0;
        for (NSNumber* n in self.locations) {
            if (colNum == gradLocationsNum) break;

            gradLocations[colNum] = n.floatValue;
            colNum++;
        }
    }

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
    CGColorSpaceRelease(colorSpace);

    CGPoint gradCenter= CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    float gradRadius = MIN(self.bounds.size.width, self.bounds.size.height) / 2;

    CGContextDrawRadialGradient(ctx, gradient, gradCenter, 0, gradCenter, gradRadius, 0);

    CGGradientRelease(gradient);
    free(gradColors);
    free(gradLocations);
}

@end
