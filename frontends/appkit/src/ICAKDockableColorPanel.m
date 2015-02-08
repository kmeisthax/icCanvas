#import <icCanvasAppKit.h>

@implementation ICAKDockableColorPanel

- (id)init {
    self = [super init];
    if (self) {
        self.contentView = [[ICAKColorPickerView alloc] init];
    }
    
    return self;
};

@end