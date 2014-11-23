#import <Cocoa/Cocoa.h>

@protocol ICMBrushToolDelegate

- (void)brushToolCapturedStroke:(ICMBrushStroke*)stroke;

@end
